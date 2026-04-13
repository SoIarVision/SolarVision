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
            title :  {
            display: true,
            text : 'Perda por Soiling Mensal ',     
              font: {
                size: 20,
                weigth: 'bold'
            },
            padding: {
                bottom: 30,
            },
           }, 
        legend: { position: 'bottom'}
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
for(let i = 1; i <=30 ; i++){
   dias.push(i);
}

const dados = [];
let valores = 100
for(let i = 1; i <=30 ; i++){
   dados.push(valores);

   valores -= 0.5
}

/* dados[4] = 50 */


/* CRIAÇÃO E CONFIGURAÇÃO DOS GRÁFICOS */

new Chart(ctx_linha, {
    type: 'line',
    data: {
        labels: dias,
        datasets: [{
        
        label:  'Eficiência diária',
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
        legend: { position: 'bottom'}
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