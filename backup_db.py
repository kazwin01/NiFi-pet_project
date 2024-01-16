import subprocess
from datetime import datetime

# Конфигурации баз данных
databases = [
    {
        'dbname': 'mrr',
        'user': 'postgres',
        'password': 'ASD12asd',
        'host': 'localhost',
        'port': '5432'
    },
    {
        'dbname': 'stg',
        'user': 'postgres',
        'password': 'ASD12asd',
        'host': 'localhost',
        'port': '5432'
    },
    {
        'dbname': 'dwh',
        'user': 'postgres',
        'password': 'ASD12asd',
        'host': 'localhost',
        'port': '5432'
    }
]

pg_dump_path = r"C:\Program Files\PostgreSQL\14\bin\pg_dump.exe"

for db_config in databases:
    backup_file = f"backup_{db_config['dbname']}_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.sql"
    command = [
        f'"{pg_dump_path}"',
        "--encoding=UTF-8 -U", db_config["user"],
        "-h", db_config["host"],
        "-p", db_config["port"],
        "-Fp", db_config["dbname"],
        f"> C:\demo\{backup_file}"
    ]
    
    try:
        subprocess.run(" ".join(command), shell=True, check=True)
        print(f"Created for {db_config['dbname']}: {backup_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error during backup of {db_config['dbname']}: {e}")
