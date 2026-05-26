// importa os bibliotecas necessários
const serialport = require('serialport');
const express = require('express');
const mysql = require('mysql2');

// constantes para configurações
const SERIAL_BAUD_RATE = 9600;
const SERVIDOR_PORTA = 3300;

// habilita ou desabilita a inserção de dados no banco de dados
const HABILITAR_OPERACAO_INSERIR = true;

// função para comunicação serial
const serial = async (
    valoresSensorLuminosidade,
) => {

    // conexão com o banco de dados MySQL
    let poolBancoDados = mysql.createPool(
        {
            host: 'localhost',
            user: 'aluno',
            password: 'Sptech#2024',
            database: 'solar_Vision',
            port: 3307
        }
    ).promise();

    // lista as portas seriais disponíveis e procura pelo Arduino
    const portas = await serialport.SerialPort.list();
    const portaArduino = portas.find((porta) => porta.vendorId == 2341 && porta.productId == 43);
    if (!portaArduino) {
        throw new Error('O arduino não foi encontrado em nenhuma porta serial');
    }

    // configura a porta serial com o baud rate especificado
    const arduino = new serialport.SerialPort(
        {
            path: portaArduino.path,
            baudRate: SERIAL_BAUD_RATE
        }
    );

    // evento quando a porta serial é aberta
    arduino.on('open', () => {
        console.log(`A leitura do arduino foi iniciada na porta ${portaArduino.path} utilizando Baud Rate de ${SERIAL_BAUD_RATE}`);
    });

    // VARIAVEL PARA CONTROLAR ERROS SEQUENCIAIS

        let erro_senquencial_ideal = 0;
        let erro_senquencial_controle = 0;
        let erro_sequenciais = 0;

    // processa os dados recebidos do Arduino
    arduino.pipe(new serialport.ReadlineParser({ delimiter: '\r\n' })).on('data', async (data) => {
        console.log(data);
        const valores = data.split(';');
        var sensorLuminosidade = parseInt(valores[0]);

        // armazena os valores dos sensores nos arrays correspondentes
        valoresSensorLuminosidade.push(sensorLuminosidade);

        

        // insere os dados no banco de dados (se habilitado)
        if (HABILITAR_OPERACAO_INSERIR) {


            // VARIAVEIS PARA TRATAR DADOS JÁ AO RECEBER

        let soma_ideal = 0;
        let soma_controle = 0;
        let ax1 = 0;
        let ax2 = 0;
        let ax3 = 0;
        let ax4 = 0;
        let ax5 = 0;
        let ax6 = 0;
        let limite_variacao_sensores = 50;

        let indicacao_sensor = 0; // vai enviar o registro para o grupo certo do sensor
        



            // LOOP PARA MOCKAR DADOS NO BANCO
            
            for(let i = 1; i <= 6; i++){

                if(i == 1){

                sensorLuminosidade += 10
                soma_ideal += sensorLuminosidade

                 ax1 = sensorLuminosidade

                 indicacao_sensor = 2;

                }else if(i == 2){

                    sensorLuminosidade += 20
                    soma_ideal += sensorLuminosidade

                     ax2 = sensorLuminosidade

                     indicacao_sensor = 2;

                } else if(i == 3){

                    sensorLuminosidade += 2
                    soma_ideal += sensorLuminosidade

                     ax3 = sensorLuminosidade

                     indicacao_sensor = 2;

                }else if(i == 4){

                    sensorLuminosidade -= 100
                    soma_controle += sensorLuminosidade

                     ax4 = sensorLuminosidade

                     indicacao_sensor = 1;

                } else if(i == 5){

                    sensorLuminosidade -= 80
                    soma_controle += sensorLuminosidade

                     ax5 = sensorLuminosidade

                     indicacao_sensor = 1;

                }else if(i == 6){

                    sensorLuminosidade -= 20
                    soma_controle += sensorLuminosidade

                     ax6 = sensorLuminosidade
                     indicacao_sensor = 1;
                }
                    

            
            // este insert irá inserir os dados na tabela "registro" e indicará se a leitura é de um sensor controle ou ideal através da fk

            await poolBancoDados.execute(
            'INSERT INTO registro (valorLuminosidade, fk_grupo, fkplaca) VALUES (?, ?, ?)',
            [sensorLuminosidade, indicacao_sensor, 1]
            );
            console.log("valores inseridos no banco: ", sensorLuminosidade);

        }

        // Verificar erros e demonstrar no banco
        // Se não tem erro, resetar a variável de erro e atualizar no banco

                        if (Math.abs(ax1 - ax2) > limite_variacao_sensores || Math.abs(ax2 - ax3) > limite_variacao_sensores || Math.abs(ax1 - ax3) > limite_variacao_sensores ){
                         
                            erro_senquencial_ideal++
                         erro_sequenciais++


                        } else { erro_senquencial_ideal = 0; 

                            await poolBancoDados.execute(
                        'UPDATE grupo_sensor SET status_sensor = (?) WHERE id_grupo = (?)',
                        ['Em funcionamento', 2] )
                            
                        await poolBancoDados.execute(
                        'UPDATE grupo_sensor SET luminosidade_recebida = (?) WHERE id_grupo = (?)',
                        [soma_ideal, 2]  )

                        }
                        

                        if  (Math.abs(ax4 - ax5) > limite_variacao_sensores || Math.abs(ax5 - ax6) > limite_variacao_sensores || Math.abs(ax4 - ax6) > limite_variacao_sensores ){
                            erro_senquencial_controle++
                            erro_sequenciais++

                         } else { erro_senquencial_controle = 0; 

                            await poolBancoDados.execute(
                        'UPDATE grupo_sensor SET status_sensor = (?) WHERE id_grupo = (?)',
                        ['Em funcionamento', 1]  )

                            await poolBancoDados.execute(
                        'UPDATE grupo_sensor SET luminosidade_recebida = (?) WHERE id_grupo = (?)',
                        [soma_controle, 1]  )

                         }

                          // se tem erro atualiza no banco

                 if(erro_senquencial_controle >= 5){
                    await poolBancoDados.execute(
                        'UPDATE grupo_sensor SET status_sensor = (?) WHERE id_grupo = (?)',
                        ['apresentando falha', 1] 
                    )
                    await poolBancoDados.execute(
                    'INSERT INTO historico_falha (fk_placa, fk_empresa, fk_sensor) VALUES ((?), (?), (?)) ',
                        [1, 1, 1]
                    )
                 }
                 if(erro_senquencial_ideal >= 5){
                    await poolBancoDados.execute(
                        'UPDATE grupo_sensor SET status_sensor = (?) WHERE id_grupo = (?)',
                        ['apresentando falha', 2] 
                    )
                    await poolBancoDados.execute(
                    'INSERT INTO historico_falha (fk_placa, fk_empresa, fk_sensor) VALUES ((?), (?), (?)) ',
                    [1, 1, 2]
                    )
                 }
        // VARIAVEL PARA CALCULAR EFICIENCIA em %
        let eficiencia = (soma_controle / soma_ideal)*100;
        
        await poolBancoDados.execute(
            'INSERT INTO historico_eficiencia (valor, fk_placa, fk_empresa) VALUES ((?), (?), (?)) ',
            [eficiencia, 1, 1]
        )

        
    };


});

    // evento para lidar com erros na comunicação serial
    arduino.on('error', (mensagem) => {
        console.error(`Erro no arduino (Mensagem: ${mensagem}`)
    });
}

// função para criar e configurar o servidor web
const servidor = (
    valoresSensorLuminosidade,
) => {
    const app = express();

    // configurações de requisição e resposta
    app.use((request, response, next) => {
        response.header('Access-Control-Allow-Origin', '*');
        response.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
        next();
    });

    // inicia o servidor na porta especificada
    app.listen(SERVIDOR_PORTA, () => {
        console.log(`API executada com sucesso na porta ${SERVIDOR_PORTA}`);
    });

    // define os endpoints da API para cada tipo de sensor
    app.get('/sensores/luminosidade', (_, response) => {
        return response.json(valoresSensorLuminosidade);
    });
}

// função principal assíncrona para iniciar a comunicação serial e o servidor web
(async () => {
    // arrays para armazenar os valores dos sensores
    const valoresSensorLuminosidade = [];

    // inicia a comunicação serial
    await serial(
        valoresSensorLuminosidade,
    );

    // inicia o servidor web
    servidor(
        valoresSensorLuminosidade,
    );
})();