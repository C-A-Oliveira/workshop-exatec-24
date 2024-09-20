from flask import Flask, jsonify, abort, request
import pyodbc, platform

dados_conexao = (
    f"""Driver=SQL Server;
    Server={platform.node()};
    Database=workshop_exatec_24;
    Trusted_Connection=yes;"""
)

conexao = pyodbc.connect(dados_conexao)

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


@app.route("/restaurante/categorias/categoria=<int:id_categoria>"
           , methods=["GET"])
def get_categoria(id_categoria):
    comando = f"""select categoria = dbo.busca_categoria({id_categoria})"""
    retorno = conexao.execute(comando).fetchall()
    categoria = []
    for r in retorno:
        categoria.append(r.categoria)
    return jsonify({"categoria": categoria}), 201


if __name__ == "__main__":
    app.run(debug=True)
