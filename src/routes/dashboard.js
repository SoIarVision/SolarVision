var express = require("express");
var router = express.Router();

var dashboardController = require("../controllers/dashboardController")

router.get("/dashboard/eficiencia/:idEmpresa", function (req, res) {
    dashboardController.mostrarEficiencia(req, res);
});

module.exports = router