const ctx = document.getElementById('grafico_stacked');

let grafico = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro'],
        datasets: [
            {
                label: 'Eficiencia da placa',
                data: [100, 100, 93, 86, 85, 84, 83, 82, 80, 50],
                backgroundColor: 'rgb(68, 114, 196)',
                order: 2
            },
            {
                label: 'perda por soiling (%)',
                data: [0, 0, 7, 14, 15, 16, 17, 18, 20, 50],
                backgroundColor: 'rgb(237, 125, 49)',
                order: 2
            },
            {
                label: 'Limite recomendado',
                data: [75, 75, 75, 75, 75, 75, 75, 75, 75, 75, 75],
                type: 'line',
                backgroundColor: 'rgb(225,0,0)',
                borderColor: 'red',
                order: 1,
                borderWidth: 2,
                borderHeight: 5,
                pointRadius: 0,


            }

        ]
    },
    options: {
        responsive: true,
        plugins: {
            title: {
                display: true,
                text: 'Perda por Soiling Mensal ',
                font: {
                    size: 20,
                    weigth: 'bold'
                },
                padding: {
                    bottom: 30,
                },
            },
            legend: { position: 'bottom' }
        },
        scales: {
            y: {
                type: 'linear',
                position: 'left',
                stacked: true,
                min: 0,
                max: 100,
            }
        },
        x: {
            type: 'bar',
            stacked: true,
            offset: false,
            title: {
                display: true,
                text: 'Meses'
            }
        }
    }
}
);

const ctx_linha = document.getElementById("eficiencia_por_dia");

/* DECLARAÇÃO DE VARIÁVEIS PARA MOCKAR DADOS */
const dias = [];
for (let i = 1; i <= 30; i++) {
    dias.push(i);
}

const dados = [];
let valores = 100
for (let i = 1; i <= 30; i++) {
    dados.push(valores);

    valores -= 0.5
}

/* dados[4] = 50 */

function trocarGrafico() {
    let graficoSelecionado = selectGrafico.value;

    if (graficoSelecionado == "grafico_stacked") {
        grafico_stacked.style.display = "block";
        eficiencia_por_dia.style.display = "none";
    } else if (graficoSelecionado == "eficiencia_por_dia") {
        grafico_stacked.style.display = "none";
        eficiencia_por_dia.style.display = "block";
    }
}

/* CRIAÇÃO E CONFIGURAÇÃO DOS GRÁFICOS */

new Chart(ctx_linha, {
    type: 'line',
    data: {
        labels: dias,
        datasets: [{

            label: 'Eficiência diária',
            data: dados,

        }

        ]

    },

    options: {
        responsive: true,
        plugins: {
            title: {
                display: true,
                text: 'Eficiência da placa solar ',
                font: {
                    size: 20,
                    weigth: 'bold'
                },
                padding: {
                    bottom: 30,
                }
            },
            legend: { position: 'bottom' }
        },
        scales: {
            y: {
                type: 'linear',
                position: 'left',
                stacked: true,
                min: 0,
                max: 100,
            }
        },

        x: {
            type: 'line',
            title: {
                display: true,
                text: 'dias'
            }

        }
    }
}


);

/* verificações de variável */

/* CRIAR UM FOR PARA ALERT CASO TENHAM 4 LEITURAS SEQUENCIAIS COM DIFERENCÇA GRANDE =150 ENTRE SENSORES    */

var paginacao = {};
var tempo = {};

function obterDados(grafico, endpoint) {
    fetch('http://localhost:3300/sensores/' + endpoint)
        .then(response => response.json())
        .then(valores => {
            if (paginacao[endpoint] == null) {
                paginacao[endpoint] = 0;
            }
            if (tempo[endpoint] == null) {
                tempo[endpoint] = 0;
            }

            var ultimaPaginacao = paginacao[endpoint];
            paginacao[endpoint] = valores.length;
            valores = valores.slice(ultimaPaginacao);

            valores.forEach((valor) => {
                if (grafico.data.labels.length == 10 && grafico.data.datasets[0].data.length == 10) {
                    grafico.data.labels.shift();
                    grafico.data.datasets[0].data.shift();
                }

                grafico.data.labels.push(tempo[endpoint]++);
                grafico.data.datasets[0].data.push(parseFloat(valor));
                grafico.update();
            });
        })
        .catch(error => console.error('Erro ao obter dados:', error));
}

/*
setInterval(() => {
    obterDados(sensorLuminosidade, 'luminosidade');
}, 1000);
*/


// Sidebar

document.getElementById("id_fechar").addEventListener("click", function () {

    document.getElementById("id_sidebar").classList.toggle("fechar");
    document.getElementById("id_conteudo_principal").classList.toggle("fechar");
    document.getElementById("id_navbar").classList.toggle("fechar");



    if (document.getElementById("id_navbar").classList.contains("fechar")) {
        document.getElementById("logo_navbar").style.display = "block";
    } else {
        document.getElementById("logo_navbar").style.display = "none";
    }
});

const idEmpresa = sessionStorage.ID_EMPRESA;
function atualizar_eficiencia() {
    
fetch(`/dashboard/eficiencia/${idEmpresa}`)
    .then((resultado) => resultado.json())
    .then((valores) => {
        var cards = document.getElementById("cards")
        var controle = 0
        var ideal = 0

        for (let i = 0; i < valores.length; i++) {
            if (valores[i].tipo == 'Controle') {
                controle += Number(valores[i].valor)
            } else {
                ideal += Number(valores[i].valor)
            }
        }

        var eficiencia = ((controle / ideal) * 100).toFixed(1)
        const data = new Date(valores[0].data_registro);

        const dataFormatada = data.toLocaleString('pt-BR');
        var status = "";

        if (eficiencia >= 95) {
            status = "Operação normal";
        }
        else if (eficiencia >= 85) {
            status = "Monitoramento recomendado";
        }
        else if (eficiencia >= 70) {
            status = "Limpeza recomendada";
        }
        else if (eficiencia >= 50) {
            status = "Limpeza necessária";
        }
        else {
            status = "Verificação urgente";
        }

        cards.innerHTML = `
            <div class="card">
                <h3>Eficiência atual</h3>
                <p>${eficiencia}%</p>
                <h5>Última leitura: <br>${dataFormatada}</h5>
            </div>
            <div class="card">
                <h3> Status </h3>
                <p>${status}</p>
            </div>
            <div class="card">
                <h3> Ultima limpeza </h3>
                <p> 13/05/2026 </p>
            </div>`
    });

    setTimeout(() => {
        atualizar_eficiencia()}, 3000);
}
atualizar_eficiencia()