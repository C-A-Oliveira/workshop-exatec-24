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

# categoria = 1
# comando = f"""select categoria = dbo.busca_categoria({categoria})"""


# ret = conexao.execute(comando).fetchall()
# cat = []
# for r in ret:
#     cat.append(r.categoria)
# print(json.dumps(cat))

body = '''{
"item": [
    {
        "nome": "1nome",
        "valor": 0
    }
]
}'''
comando = f"""
declare @ret_msg nvarchar(max), @ret_cd int
exec restaurante.p_adicionar_item N'{body}', @ret_msg output, @ret_cd output
select 
    retorno_msg = @ret_msg
    ,retorno_cd = @ret_cd
"""
retorno = conexao.execute(comando).fetchone()
print(retorno.retorno_msg)