var express = require("express");
var router = express.Router();

var dashboardController = require("../controllers/dashboardController")

router.get("/dashboard/eficiencia/:idEmpresa", function (req, res) {
    dashboardController.mostrarEficiencia(req, res);
});

router.get("/dashboard/limpeza", function (req, res) {
    dashboardController.ultimaLimpeza(req, res);
});

router.get("/dashboard/grafico/eficiencia", function (req, res) {
    dashboardController.graficoEficiencia(req, res);
});

module.exports = router