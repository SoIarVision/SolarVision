// sessão
function validarSessao() {
    var email = sessionStorage.EMAIL_USUARIO;
    var nome = sessionStorage.NOME_USUARIO;

    if (email != null && nome != null) {
    } else {
        window.location = "../login.html";
    }
}

function ajustarNavbarSessao() {
    /*var idUsuario = sessionStorage.ID_USUARIO;
    var tipoUsuario = sessionStorage.TIPO
*/
    let cargo = sessionStorage.CARGO_USUARIO;

    let idUsuario = sessionStorage.ID_USUARIO

    if (idUsuario == undefined) {
        nav_home.style.display = "block";
        nav_sobre.style.display = "block";
        nav_simulador.style.display = "none";
        nav_dash.style.display = "none";
        nav_logar.style.display = "block";
        nav_cadastro.style.display = "block";
    } else {
        nav_home.style.display = "block";
        nav_sobre.style.display = "block";
        nav_simulador.style.display = "block";
        nav_dash.style.display = "block";
        nav_logar.style.display = "none";
        nav_cadastro.style.display = "none";

        // Gerente, Suporte, Adminastrador, Funcionário

        if (cargo == 'Adminastrador') {
            side_dashboard.style.display = "block";
            side_empresa.style.display = "block";
            side_suporte.style.display = "block";
            side_bobIA.style.display = "block";
            side_manual.style.display = "block";
        } else if (cargo == 'Suporte') {
            side_dashboard.style.display = "block";
            side_empresa.style.display = "none";
            side_suporte.style.display = "block";
            side_bobIA.style.display = "block";
            side_manual.style.display = "block";
        } else if (cargo == 'Funcionário') {
            side_dashboard.style.display = "block";
            side_empresa.style.display = "none";
            side_suporte.style.display = "block";
            side_bobIA.style.display = "none";
            side_manual.style.display = "none";
        } else if (cargo == 'Gerente') {
            side_dashboard.style.display = "block";
            side_empresa.style.display = "block";
            side_suporte.style.display = "block";
            side_bobIA.style.display = "none";
            side_manual.style.display = "none";
        }

    }


}

function limparSessao() {
    sessionStorage.clear();
    window.location = "../login.html";
}

// carregamento (loading)
function aguardar() {
    var divAguardar = document.getElementById("div_aguardar");
    divAguardar.style.display = "flex";
}

function finalizarAguardar(texto) {
    var divAguardar = document.getElementById("div_aguardar");
    divAguardar.style.display = "none";

    var divErrosLogin = document.getElementById("div_erros_login");
    if (texto) {
        divErrosLogin.style.display = "flex";
        divErrosLogin.innerHTML = texto;
    }
}

