var dashboardModel = require("../models/dashboardModel")

function mostrarEficiencia(req, res) {
    var idEmpresa = req.params.idEmpresa

    dashboardModel.mostrarEficiencia(idEmpresa)
        .then((resultado) => {
            if (resultado.length === 0) {
                return res.status(404).json({ mensagem: "Eficiência não encontrada." });
            }
            res.json(resultado);
        })
        .catch((erro) => {
            console.error("Erro ao buscar Eficiência:", erro);
            res.status(500).json({ erro: erro.sqlMessage });
        });
}

function ultimaLimpeza(req, res) {

    dashboardModel.ultimaLimpeza()
        .then((resultado) => {
            if (resultado.length === 0) {
                return res.status(404).json({ mensagem: "Ultima limpeza não encontrada." });
            }
            res.json(resultado);
        })
        .catch((erro) => {
            console.error("Erro ao buscar ultima limpeza:", erro);
            res.status(500).json({ erro: erro.sqlMessage });
        });
}



module.exports = {
    mostrarEficiencia, ultimaLimpeza
}