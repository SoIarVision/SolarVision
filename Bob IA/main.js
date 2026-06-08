// importando os bibliotecas necessárias
const { GoogleGenAI } = require("@google/genai");
const express = require("express");
const path = require("path");

// carregando as variáveis de ambiente do projeto do arquivo .env
require("dotenv").config();
// configurando o servidor express

const app = express();
const PORTA_SERVIDOR = process.env.PORTA ;
// configurando o gemini (IA)
const chatIA = new GoogleGenAI({ apiKey: process.env.MINHA_CHAVE });

// configurando o servidor para receber requisições JSON

app.use(express.json());
// configurando o servidor para servir arquivos estáticos

// configurando CORS
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
    next();
});

// inicializando o servidor
app.listen(PORTA_SERVIDOR, () => {
    console.info(
        `
        ######                ###    #    
        #     #  ####  #####   #    # #   
        #     # #    # #    #  #   #   #  
        ######  #    # #####   #  #     # 
        #     # #    # #    #  #  ####### 
        #     # #    # #    #  #  #     # 
        ######   ####  #####  ### #     # 
        `
    );
    console.info(`A API BobIA iniciada, acesse http://localhost:${PORTA_SERVIDOR}`);
});


// cria uma rota para usar o arquivo 
app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "public", "chat.html"));
});

app.use(express.static(path.join(__dirname, "public")));

app.post("/perguntar", async (req, res) => {
    const pergunta = req.body.pergunta?.trim();

    if (!pergunta) {
        return res.status(400).json({ error: "A pergunta não pode estar vazia." });
    }


    try {
        const resultado = await gerarResposta(pergunta);
        return res.json({ resultado });
    } catch (error) {
        
        return res.status(500).json({ error: "Erro interno do servidor." });
    }
});

// função para gerar respostas usando o gemini
async function gerarResposta(mensagem) {

    try {
        // gerando conteúdo com base na pergunta

    const prompt = `
Você é o assistente virtual de suporte do SolarVision, uma plataforma que monitora
perdas de eficiência causadas por sujeira em painéis solares. Responda em português
brasileiro, de forma clara, cordial e objetiva. Ajude com dúvidas sobre o dashboard,
eficiência, soiling, sensores, instalação e uso da plataforma. Não invente dados do
cliente nem afirme que executou ações no sistema. Quando não houver informação
suficiente, explique a limitação e oriente o usuário a procurar o suporte técnico.

Pergunta do usuário: ${mensagem}
    `.trim();

    const resultado = await chatIA.models.generateContent({
        model: "gemini-2.5-flash",
        contents: prompt
    });

        const resposta = resultado.text;
        const tokens = resultado.usageMetadata;

        console.log(resposta);
        console.log("Uso de Tokens:", tokens);

        return resposta;

        } catch (error) {
        console.error(error);
        throw error;
    }
}
