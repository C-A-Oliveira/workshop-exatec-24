from flask import jsonify
import pyodbc, platform,json

dados_conexao = (
    f"""Driver=SQL Server;
    Server={platform.node()};
    Database=workshop_exatec_24;
    Trusted_Connection=yes;"""
)

conexao = pyodbc.connect(dados_conexao)
print("Conexão Bem Sucedida")

categoria = 1
comando = f"""select categoria = dbo.busca_categoria({categoria})"""


ret = conexao.execute(comando).fetchall()
cat = []
for r in ret:
    cat.append(r.categoria)

print(json.dumps(cat))
