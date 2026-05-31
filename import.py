import pandas as pd
from sqlalchemy import create_engine, text
from urllib.parse import quote_plus

# ----------------------------------------
# CONFIGURAÇÕES
# ----------------------------------------
server   = "localhost"
port     = 1433
database = "aptr2"          # Troque pelo nome do seu banco
username = "sa"
password = "SenhaForte123!"

excel_file = "Base_Teste_Vaga_Delphi.xlsx"

# Driver ODBC via FreeTDS (unixODBC) com caminho explícito do driver
odbc_conn = (
    f"DRIVER=/opt/homebrew/Cellar/freetds/1.5.10/lib/libtdsodbc.so;"
    f"SERVER={server};PORT={port};DATABASE={database};UID={username};PWD={password};"
    f"Encrypt=yes;TrustServerCertificate=yes;TDS_Version=8.0"
)

connection_string = f"mssql+pyodbc:///?odbc_connect={quote_plus(odbc_conn)}"

engine = None
try:
    engine = create_engine(connection_string)
    with engine.connect() as conn:
        pass
except Exception as e:
    print(f"⚠️ pyodbc/FreeTDS falhou: {e}. Tentando via python-tds...")
    pytds_conn = f"mssql+pytds://{username}:{password}@{server}:{port}/{database}?autocommit=True"
    engine = create_engine(pytds_conn)

# ----------------------------------------
# PROCESSAR EXCEL
# ----------------------------------------
xlsx = pd.ExcelFile(excel_file)

for sheet in xlsx.sheet_names:
    print(f"📌 Importando aba: {sheet}")

    df = pd.read_excel(excel_file, sheet_name=sheet)

    # Normalizar nomes das colunas (evita erro com espaços)
    df.columns = [c.strip().replace(" ", "_") for c in df.columns]

    # Gravar no SQL (cria a tabela se não existir)
    df.to_sql(sheet, engine, if_exists="replace", index=False)

print("✅ Importação concluída com sucesso!")
