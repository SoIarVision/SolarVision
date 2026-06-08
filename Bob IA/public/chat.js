var mensagens = document.getElementById("mensagens");
var campo_pergunta = document.getElementById("campo_pergunta");
var botao_enviar = document.getElementById("botao_enviar");

function adicionarMensagem(texto, tipo) {
    var novaMensagem = document.createElement("div");

    novaMensagem.classList.add("mensagem");
    novaMensagem.classList.add(tipo);
    novaMensagem.innerText = texto;

    mensagens.appendChild(novaMensagem);
    mensagens.scrollTop = mensagens.scrollHeight;
}

async function enviarMensagem() {
    if (botao_enviar.disabled) {
        return;
    }

    var pergunta = campo_pergunta.value.trim();

    if (pergunta == "") {
        alert("Digite uma mensagem antes de enviar.");
        return;
    }

    adicionarMensagem(pergunta, "usuario");

    campo_pergunta.value = "";
    botao_enviar.disabled = true;
    botao_enviar.innerText = "Aguarde...";

    try {
        var resposta = await fetch("/perguntar", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                pergunta: pergunta
            })
        });

        var dados = await resposta.json();

        if (resposta.ok) {
            adicionarMensagem(dados.resultado, "ia");
        } else {
            console.log(resposta)
            adicionarMensagem("Não foi possível responder agora.", "ia");
        }
    } catch (erro) {
        adicionarMensagem("Erro ao conectar com o assistente.", "ia");
        console.error(erro);
    }

    botao_enviar.disabled = false;
    botao_enviar.innerText = "Enviar";
    campo_pergunta.focus();
}

campo_pergunta.addEventListener("keydown", function (evento) {
    if (evento.key == "Enter") {
        enviarMensagem();
    }
});
