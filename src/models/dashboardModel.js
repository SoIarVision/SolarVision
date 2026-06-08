var database = require("../database/config")

function mostrarEficiencia(idEmpresa) {
    var InstrucaoSQL = `
    SELECT
        r.idRegistro,
        r.valor,
        r.data_registro,
        gs.tipo,
        gs.localizacao,
        e.idEmpresa,
        e.nome AS empresa
    FROM registro r
    JOIN grupo_sensor gs ON gs.idSensor = r.fkSensor
    JOIN placa p ON p.idPlaca = gs.fkPlaca
    JOIN empresa e ON e.idEmpresa = p.fkEmpresa
    WHERE e.idEmpresa = ?
    ORDER BY r.idRegistro DESC
    LIMIT 6;`

    console.log("Executando a instrução SQL: \n" + InstrucaoSQL);
    return database.executar(InstrucaoSQL, [idEmpresa])
}
function ultimaLimpeza() {
    var InstrucaoSQL = `
    select * from historico_eficiencia order by valor_eficiencia >= 92 desc limit 1;`

    console.log("Executando a instrução SQL: \n" + InstrucaoSQL);
    return database.executar(InstrucaoSQL)
}



module.exports = {
    mostrarEficiencia, ultimaLimpeza
}