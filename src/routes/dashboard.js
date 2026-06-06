var express = require("express");
var router = express.Router();

var dashboardController = require("../controllers/dashboardController")

router.get("/dashboard/empresas/listar", function (req, res) {
    dashboardController.listarTodasEmpresas(req, res);
});

router.get(`/dashboard/funcionarios/listar/:idEmpresa`, function (req, res) {
    dashboardController.listarFuncionarios(req, res);
});

module.exports = router