var express = require("express");
var router = express.Router();

var empresaController = require("../controllers/empresaController");

router.get("/listar/empresas", function (req, res) {
    empresaController.listarTodasEmpresas(req, res);
});

router.get(`/funcionarios/listar/:idEmpresa`, function (req, res) {
    empresaController.listarFuncionarios(req, res);
});

module.exports = router