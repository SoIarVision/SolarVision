const ctx = document.getElementById('grafico_stacked');

let myChart;

function inicializarGraficoLuminosidade() {
    fetch("/dashboard/grafico/eficiencia")
        .then(r => r.json())
        .then(dados => {
            const labels = dados.map(dados => {
                const data = new Date(dados.dia);
                return data.toLocaleDateString('pt-BR')
            });

            const data = dados.map(dados => parseFloat(dados.eficiencia_media));

            console.log('Labels:', labels);
            console.log('Data:', data);

            const ctx = document.getElementById('eficiencia_por_dia').getContext('2d');

            if (myChart) {
                myChart.destroy();
            }

            myChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Eficiência (%)',
                        data: data,
                        borderColor: '#FFD700',
                        backgroundColor: 'rgba(255, 215, 0, 0.1)',
                        borderWidth: 2,
                        tension: 0.4,
                        fill: false
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Eficiência da placa solar',
                            font: { size: 20, weight: 'bold' },
                            padding: { bottom: 30 }
                        },
                        legend: { position: 'bottom' }
                    },
                    scales: {
                        y: {
                            type: 'linear',
                            position: 'left',
                            min: 0,
                            max: 100,
                            title: { display: true, text: 'Eficiência (%)' }
                        },
                        x: {
                            title: { display: true, text: 'Dias' }
                        }
                    }
                }
            });
        })
        .catch(error => console.error('Erro ao carregar gráfico:', error));
}

function atualizarGrafico(novoRegistro) {
    if (!myChart) return;

    const dataFormatada = new Date(novoRegistro.dia).toLocaleDateString('pt-BR');

    myChart.data.labels.shift();
    myChart.data.labels.push(dataFormatada);

    myChart.data.datasets[0].data.shift();
    myChart.data.datasets[0].data.push(parseFloat(novoRegistro.eficiencia_media));

    myChart.update();
}

inicializarGraficoLuminosidade();

const idEmpresa = sessionStorage.ID_EMPRESA;

function atualizar_eficiencia() {
    fetch(`/dashboard/eficiencia/${idEmpresa}`)
        .then((resultado) => resultado.json())
        .then((valores) => {
            var eficienciaCard = document.getElementById("eficiencia")
            var dataEficiencia = document.getElementById("dataEficiencia")
            var statusEficiencia = document.getElementById("status")
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

            eficienciaCard.innerHTML = `${eficiencia}`
            dataEficiencia.innerHTML = `${dataFormatada}`
            statusEficiencia.innerHTML = `${status}`
        });

    setTimeout(() => {
        atualizar_eficiencia()
    }, 2000);
}

function limpeza() {
    fetch("/dashboard/limpeza")
        .then((resultado) => resultado.json())
        .then((resultado) => {
            const data = new Date(resultado[0].dt_eficiencia);
            const dataFormatada = data.toLocaleString('pt-BR');
            var cards = document.getElementById("dataLimpeza")
            cards.innerHTML = `${dataFormatada}`
        })
}

atualizar_eficiencia()
limpeza()