var empresaModel = require("../models/empresaModel");

function listarTodasEmpresas(req, res) {
  empresaModel.listarTodasEmpresas()
    .then((resultado) => {
      if (resultado.length === 0) {
        return res.status(404).json({ mensagem: "Empresa não encontrada." });
      }
      res.json(resultado);
    })
    .catch((erro) => {
      console.error("Erro ao buscar info da Empresa:", erro);
      res.status(500).json({ erro: erro.sqlMessage });
    });
}

function listarFuncionarios(req, res) {
  var idEmpresa = req.params.idEmpresa

  empresaModel.listarFuncionarios(idEmpresa)
    .then((resultado) => {
      if (resultado.length === 0) {
        return res.status(404).json({ mensagem: "Funcionários não encontrados." });
      }
      res.json(resultado);
    })
    .catch((erro) => {
      console.error("Erro ao buscar info dos Funcionários:", erro);
      res.status(500).json({ erro: erro.sqlMessage });
    });
}

module.exports = {
  listarTodasEmpresas,
  listarFuncionarios,
}