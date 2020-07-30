// Módulo responsável por fazer a leitura do csv utilizando o módulo csv-parser
const csv = require('csv-parser');
const fs = require('fs');
const path = require('path');

reader = {};

// Função que faz a leitura do CSV e recebe um callback para tratamento dos dados.
reader.readCSV = function (cb) {
    fs.createReadStream(path.join(__dirname, 'Relatorio_cadop.csv'), {encoding: 'latin1'})
        .pipe(csv(
            {
                separator: ';',
                skipLines: 3,
                headers: ['registro', 'cnpj', 'razao_social', 'nome_fantasia',
                    'modalidade', 'logradouro', 'numero', 'complemento', 'bairro',
                    'cidade', 'uf', 'cep', 'ddd', 'telefone', 'fax', 'endereco_eletronico',
                    'representante', 'cargo_representante', 'data_registro']
            }))
        .on('data', (row) => {
            cb(row);
        })
        .on('end', () => {
            cb({ message: 'Finished' });
        });
}

module.exports = reader;