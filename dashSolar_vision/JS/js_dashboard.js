const ctx = document.getElementById('grafico_stacked');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro'],
        datasets: [
            {
                label: 'Eficiencia da placa',
                data: [100, 100, 93, 86, 85, 84, 83, 82, 80, 72],
                backgroundColor: 'rgb(68, 114, 196)',
                order:2
            },
            {
                label: 'perda por soiling (%)', 
                data: [0, 0, 7, 14, 15, 16, 17, 18, 20, 28],
                backgroundColor: 'rgb(237, 125, 49)',
                order: 2
            },
         {
              label: 'Limite recomendado',
              data: [75, 75 ,75, 75, 75, 75, 75, 75, 75, 75,75],
              type: 'line',
              backgroundColor: 'rgb(225,0,0)',
              order: 1
          }

        ]
    },
    options: {
        responsive: true,
        plugins: {
            title: {
            display: true,
            text: 'Eficiencia da placa solar e perda por soiling',
        }
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
                title: {
                    display: true,
                    text: 'Meses'
                }
            }
        }
    }
);