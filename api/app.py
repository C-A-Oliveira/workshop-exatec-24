import json
from flask import Flask, jsonify, abort, request
import pyodbc, platform

dados_conexao = (
    f"""Driver=SQL Server;
    Server={platform.node()};
    Database=workshop_exatec_24;
    Trusted_Connection=yes;"""
)

#conexao = pyodbc.connect(dados_conexao)

days = [
    {"id": 1, "name": "Monday"},
    {"id": 2, "name": "Tuesday"},
    {"id": 3, "name": "Wednesday"},
    {"id": 4, "name": "Thursday"},
    {"id": 5, "name": "Friday"},
    {"id": 6, "name": "Saturday"},
    {"id": 7, "name": "Sunday"},
]

app = Flask(__name__)


@app.route("/", methods=["GET"])
def get_days():
    return jsonify(days)

@app.route("/day=<int:day_id>", methods=["GET"])
def get_day(day_id):
    day = [day for day in days if day["id"] == day_id]
    if len(day) == 0:
        abort(404)
    return jsonify({"day": day[0]})


@app.route("/", methods=["POST"])
def post_days():
    return jsonify({"success": True}), 201

@app.route("/devolve-body/", methods=["POST"])
def post_mes():
    return jsonify({"success": request.get_json()}), 201


# ----- CATEGORIAS

# lista todas as categorias
@app.route("/restaurante/categorias/", methods=["GET"])
# EX. 01 - select basico direto no banco de dados
def get_categorias():
    comando = f"""
                select categorias = concat(nome, ' - ', descricao)
                from restaurante.categoria"""
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    retorno = cursor.execute(comando).fetchall()
    categorias = []
    for r in retorno:
        categorias.append(r.categorias)
    conexao.close()
    
    return jsonify({"success": {"categorias": categorias}}), 200

# busca 1 unica categoria
@app.route("/restaurante/categorias/id_categoria=<int:id_categoria>", methods=["GET"])
# EX. 02 - select com function direto no banco de dados c/ passagem de parametro
def get_categoria(id_categoria):
    comando = f"""select categoria = restaurante.f_get_categoria({id_categoria})"""
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    retorno = cursor.execute(comando).fetchall()
    categoria = []
    for r in retorno:
        categoria.append(r.categoria)
    conexao.close()
    return jsonify({"success": {"categoria": categoria}}), 200


# ----- ITENS

# Lista todos os itens
@app.route("/restaurante/itens/", methods=["GET"])
# EX. 03 - procedure sem parametros de execução
def get_itens():
    comando = f"""exec restaurante.p_get_itens"""
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    retorno = cursor.execute(comando).fetchone()
    
    for r in retorno:
        itens= r
    conexao.close()
        
    return {"success": json.loads(itens)}, 200

# busca 1 unico item
@app.route("/restaurante/item/id_item=<int:id_item>", methods=["GET"])
# EX. 04 - Procedure com paramentro de entrada
def get_item(id_item): 
    comando = f"""exec restaurante.p_get_item {id_item}"""
    
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    retorno = cursor.execute(comando).fetchone()
  
    for r in retorno:
        item = r
    conexao.close()
    
    return {"success": json.loads(item)}, 200

# cria um item novo
@app.route("/restaurante/item/", methods=["POST"])
# EX. 05 - procedure com parametros e output
def add_item():
    
    body = json.dumps(request.json)
    comando = f"""
    declare @ret_msg nvarchar(max)=null, @ret_cd int = null
    exec restaurante.p_add_item N'{body}', @ret_msg output, @ret_cd output
    select 
        retorno_msg = @ret_msg
        ,retorno_cd = @ret_cd
    """ 
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    try:
        retorno_con = cursor.execute(comando).fetchone()
        retorno= jsonify({'success': { 'retorno_msg': retorno_con.retorno_msg,'retorno_cd': retorno_con.retorno_cd}})
        conexao.commit() # Insersão de dados - commit da transação no banco de dados
    except AttributeError:
        retorno= jsonify({'success': { 'retorno_msg': AttributeError,'retorno_cd': -1}})
    finally:    
        conexao.close()
        
    return retorno, 201
    

# ----- PEDIDOS

@app.route("/restaurante/pedidos/", methods=["GET"])
# EX. 06 - lista todos os pedidos
def get_pedidos():
    
    comando = f"""exec restaurante.p_get_pedidos"""
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    retorno = cursor.execute(comando).fetchone()
    
    for r in retorno:
        pedidos = r
    conexao.close()
        
    return {"success": json.loads(pedidos)}, 200

@app.route("/restaurante/pedido/id_pedido=<int:id_pedido>", methods=["GET"])
# EX. 07 - busca 1 unico pedido
def get_pedido(id_pedido):
    
    comando = f"""exec restaurante.p_get_pedido {id_pedido}"""
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    retorno = cursor.execute(comando).fetchone()
    
    for r in retorno:
        pedido = r
    conexao.close()
        
    return {"success": json.loads(pedido)}, 200

@app.route("/restaurante/pedidos/ativos/", methods=["GET"])
# Criar uma procedure que liste todos os pedidos com status “Em-Aberto”.
def get_pedidos_ativos():
    comando = f"""exec restaurante.p_get_pedidos_ativos"""
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    retorno = cursor.execute(comando).fetchone()
    
    for r in retorno:
        pedidos = r
    conexao.close()
        
    return {"success": json.loads(pedidos)}, 200

@app.route("/restaurante/pedido/", methods=["POST"])
# Criar uma procedure que crie/abra um pedido novo, contendo 1 ou mais itens. Não deve permitir a criação sem nenhum item.
def add_pedido():
    body = json.dumps(request.json)
    comando = f"""
    declare @ret_msg nvarchar(max)=null, @ret_cd int = null
    exec restaurante.p_add_pedido N'{body}', @ret_msg output, @ret_cd output
    select 
        retorno_msg = @ret_msg
        ,retorno_cd = @ret_cd
    """ 
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    try:
        retorno_con = cursor.execute(comando).fetchone()
        retorno= jsonify({'success': { 'retorno_msg': retorno_con.retorno_msg,'retorno_cd': retorno_con.retorno_cd}})
        conexao.commit() # Insersão de dados - commit da transação no banco de dados
    except AttributeError:
        retorno= jsonify({'success': { 'retorno_msg': AttributeError,'retorno_cd': -1}})
    finally:    
        conexao.close()
    return retorno, 201

@app.route("/restaurante/pedido/id_pedido=<int:id_pedido>", methods=["POST"])
# Criar uma procedure que acrescenta 1 ou mais itens a um pedido existente.
def add_to_pedido(id_pedido):
    body = json.dumps(request.json)
    comando = f"""
    declare @ret_msg nvarchar(max)=null, @ret_cd int = null
    exec restaurante.p_add_to_pedido {id_pedido}, N'{body}', @ret_msg output, @ret_cd output
    select 
        retorno_msg = @ret_msg
        ,retorno_cd = @ret_cd
    """ 
    conexao = pyodbc.connect(dados_conexao)
    cursor = conexao.cursor()
    try:
        retorno_con = cursor.execute(comando).fetchone()
        retorno= jsonify({'success': { 'retorno_msg': retorno_con.retorno_msg,'retorno_cd': retorno_con.retorno_cd}})
        conexao.commit() # Insersão de dados - commit da transação no banco de dados
    except AttributeError:
        retorno= jsonify({'success': { 'retorno_msg': AttributeError,'retorno_cd': -1}})
    finally:    
        conexao.close()
    return retorno, 201
    return

# Criar uma procedure que liste todos os pedidos, com as descrições de seus itens formatadas de uma forma apresentável (item + categoria)
def get_pedidos_formatado():
    return


######## --- DESAFIOS --- ########
@app.route("/restaurante/desafio/pedidos/ativos/", methods=["GET"])
# D. 01 - Criar uma procedure que liste todos os pedidos com status “Em-Aberto”.
def desafio_get_pedidos_ativos():
    return '', 204

# D. 02 - Criar uma procedure que crie/abra um pedido novo, contendo 1 ou mais itens. Não deve permitir a criação sem nenhum item.
@app.route("/restaurante/desafio/pedido/novo/", methods=["POST"])
def desafio_add_pedido():
    return '', 204

# D. 03 - Criar uma procedure que acrescenta 1 ou mais itens a um pedido existente.
@app.route("/restaurante/desafio/pedido/add-item/", methods=["POST"])
def desafio_add_to_pedido():
    return '', 204

# D. 04 - Criar uma procedure que liste todos os pedidos, com as descrições de seus itens formatadas de uma forma apresentável (item + categoria)
@app.route("/restaurante/desafio/pedido/formatado/", methods=["GET"])
def desafio_get_pedidos_formatado():
    return '', 204


# COMANDAS


if __name__ == "__main__":
    app.run(debug=True)
