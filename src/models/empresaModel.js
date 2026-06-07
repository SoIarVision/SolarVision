var database = require("../database/config");

function listarTodasEmpresas() {
  var InstrucaoSQL = `
    SELECT * from vw_listar_empresas;`

  console.log("Executando a instrução SQL: \n" + InstrucaoSQL);
  return database.executar(InstrucaoSQL)
}

function listarFuncionarios(idEmpresa) {
  var InstrucaoSQL = `
    SELECT 
        u.idUsuario id,
        u.nome Nome,
        u.contato Telefone,
        c.cargo Cargo,
        e.idEmpresa idEmpresa,
        e.nome Empresa
    FROM usuario u
    JOIN cargo c ON c.idCargo = u.fkCargo
    JOIN empresa e ON e.idEmpresa = u.fkEmpresa
    where idEmpresa = ?;`

  console.log("Executando a instrução SQL: \n" + InstrucaoSQL);
  return database.executar(InstrucaoSQL, [idEmpresa])
}

module.exports = {
  listarTodasEmpresas,
  listarFuncionarios,
}