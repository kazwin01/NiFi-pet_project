CREATE OR REPLACE FUNCTION dwh.get_total_sales(customer_id integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    total_sales INT;
BEGIN
    SELECT COALESCE(SUM(qty), 0) INTO total_sales
    FROM dwh.dwh_fct_sales
    WHERE customer_id = $1;

    RETURN total_sales;
END;
$function$
;

CREATE OR REPLACE PROCEDURE dwh.pop_dim_tables()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    customer_data RECORD;
    product_group_name VARCHAR(255);
    product_data RECORD;
    all_inserts_succeeded BOOLEAN := TRUE; -- Переменная-флаг для отслеживания успешности всех вставок
BEGIN
    -- Курсор для данных о клиентах
    FOR customer_data IN (SELECT id, "name", country FROM ext.ext_dim_customers) LOOP
        BEGIN
            INSERT INTO dwh.dwh_dim_customers (id, "name", country, created_dt) 
            VALUES (customer_data.id, customer_data."name", customer_data.country, CURRENT_TIMESTAMP)
            ON CONFLICT (id) DO UPDATE 
                SET "name" = EXCLUDED."name", country = EXCLUDED.country, modified_dt = CURRENT_TIMESTAMP
            WHERE 
                dwh.dwh_dim_customers."name" <> EXCLUDED."name" OR dwh.dwh_dim_customers.country <> EXCLUDED.country;
        EXCEPTION
            WHEN OTHERS THEN
                INSERT INTO dwh.error_logs (component, error_timestamp, error_description, layer)
                VALUES ('pop_dim_tables/dwh_dim_customers', CURRENT_TIMESTAMP, sqlerrm,'dwh');
                all_inserts_succeeded := FALSE; -- Устанавливаем флаг в FALSE при возникновении ошибки
                CONTINUE;
        END;
    END LOOP;

    -- Курсор для данных о группах продуктов
    FOR product_group_name IN (SELECT DISTINCT groupname FROM ext.ext_dim_products) LOOP
        BEGIN
            INSERT INTO dwh.dwh_dim_product_groups ("name", created_dt)
            VALUES (product_group_name, CURRENT_TIMESTAMP)
            ON CONFLICT DO NOTHING;
        EXCEPTION
            WHEN OTHERS THEN
                INSERT INTO dwh.error_logs (component, error_timestamp, error_description, layer)
                VALUES ('pop_dim_tables/dwh_dim_product_groups', CURRENT_TIMESTAMP, sqlerrm, 'dwh');
                all_inserts_succeeded := FALSE; -- Устанавливаем флаг в FALSE при возникновении ошибки
                CONTINUE;
        END;
    END LOOP;

    -- Курсор для данных о продуктах
    FOR product_data IN (SELECT p.id, p."name", ddpg.id as product_group_id FROM ext.ext_dim_products p
                         INNER JOIN dwh.dwh_dim_product_groups ddpg ON ddpg."name" = p.groupname) LOOP
        BEGIN
            INSERT INTO dwh.dwh_dim_products (id, "name", product_group_id, created_dt)
            VALUES (product_data.id, product_data."name", product_data.product_group_id, CURRENT_TIMESTAMP)
            ON CONFLICT (id) DO UPDATE 
                SET "name" = EXCLUDED."name", product_group_id = EXCLUDED.product_group_id, modified_dt = CURRENT_TIMESTAMP
            WHERE 
                dwh.dwh_dim_products."name" <> EXCLUDED."name" OR dwh.dwh_dim_products.product_group_id <> EXCLUDED.product_group_id;
        EXCEPTION
            WHEN OTHERS THEN
                INSERT INTO dwh.error_logs (component, error_timestamp, error_description, layer)
                VALUES ('pop_dim_tables/dwh_dim_products', CURRENT_TIMESTAMP, sqlerrm, 'dwh');
                all_inserts_succeeded := FALSE; -- Устанавливаем флаг в FALSE при возникновении ошибки
                CONTINUE;
        END;
    END LOOP;

    -- Вставляем запись в pipelines_logs со статусом "SUCCEED", если все вставки прошли успешно
    IF all_inserts_succeeded THEN
        INSERT INTO dwh.pipelines_logs (stop_dt, last_layer, status) 
        VALUES (CURRENT_TIMESTAMP, 'dwh/pop_dim_tables', 'Succeed');
    ELSE
        INSERT INTO dwh.pipelines_logs (stop_dt, last_layer, status) 
        VALUES (CURRENT_TIMESTAMP, 'dwh/pop_dim_tables', 'Failed');
    END IF;
END;
$procedure$
;

CREATE OR REPLACE PROCEDURE dwh.pop_dim_tables_short()
 LANGUAGE plpgsql
AS $procedure$
begin
    ---Customers---
    INSERT INTO dwh.dwh_dim_customers (id, "name", country, created_dt) 
    SELECT
        src.id,
        src."name",
        src.country,
        CURRENT_TIMESTAMP
    FROM ext.ext_dim_customers src
    ON CONFLICT (id) 
    DO UPDATE 
        SET "name" = EXCLUDED."name", country = EXCLUDED.country, modified_dt = CURRENT_TIMESTAMP
    WHERE 
        dwh.dwh_dim_customers."name" <> EXCLUDED."name" OR dwh.dwh_dim_customers.country <> EXCLUDED.country;
    ---Products groups--- 
    INSERT INTO dwh.dwh_dim_product_groups ("name", created_dt)
    SELECT DISTINCT 
        src.groupname,
        CURRENT_TIMESTAMP
    FROM ext.ext_dim_products src
    ON CONFLICT DO NOTHING;
    ---Products--- 
    INSERT INTO dwh.dwh_dim_products (id, "name", product_group_id, created_dt)
    SELECT
        src.id,
        src."name",
        ddpg.id as product_group_id,
        CURRENT_TIMESTAMP
    FROM ext.ext_dim_products src
    INNER JOIN dwh.dwh_dim_product_groups ddpg ON ddpg."name" = src.groupname 
    ON CONFLICT (id) 
    DO UPDATE 
        SET "name" = EXCLUDED."name", product_group_id = EXCLUDED.product_group_id, modified_dt = CURRENT_TIMESTAMP
    WHERE 
        dwh.dwh_dim_products."name" <> EXCLUDED."name" OR dwh.dwh_dim_products.product_group_id <> EXCLUDED.product_group_id;
END;
$procedure$
;

CREATE OR REPLACE PROCEDURE dwh.pop_fct_tables()
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    sales RECORD;
    all_inserts_succeeded BOOLEAN := TRUE; -- Переменная-флаг для отслеживания успешности всех вставок

BEGIN
    -- Курсор для данных о продуктах
    FOR sales IN (SELECT p.customer_id, p.product_id, p.qty, p.invoice_dt FROM ext.ext_fct_sales p
                         INNER JOIN dwh.dwh_dim_customers ddc on ddc.id = p.customer_id
                         INNER JOIN dwh.dwh_dim_products ddp on ddp.id = p.product_id) LOOP
        BEGIN
            INSERT INTO dwh.dwh_fct_sales (customer_id, product_id, qty, invoice_dt)
            VALUES (sales.customer_id, sales.product_id, sales.qty, sales.invoice_dt)
            ON CONFLICT (customer_id, product_id, qty, invoice_dt) DO NOTHING;
        EXCEPTION
            WHEN OTHERS THEN
                INSERT INTO dwh.error_logs (component, error_timestamp, error_description, layer)
                VALUES ('pop_fct_tables/dwh_fct_sales', CURRENT_TIMESTAMP, sqlerrm, 'dwh/pop_fct_tables');
                all_inserts_succeeded := FALSE; -- Устанавливаем флаг в FALSE при возникновении ошибки
                CONTINUE;
        END;
    END LOOP;
    IF all_inserts_succeeded THEN
        INSERT INTO dwh.pipelines_logs (stop_dt, last_layer, status) 
        VALUES (CURRENT_TIMESTAMP, 'dwh/pop_fct_tables', 'Succeed');
    ELSE
        INSERT INTO dwh.pipelines_logs (stop_dt, last_layer, status) 
        VALUES (CURRENT_TIMESTAMP, 'dwh/pop_fct_tables', 'Failed');
    END IF;
END;
$procedure$
;
