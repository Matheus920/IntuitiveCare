// Controller responsável pelas ações de fato.
const reader = require('../data/reader');
const Fuse = require('fuse.js');

let controller = {}

// Para a busca é utiilizado o fuse.js de modo a possibilitar fuzzysearch dentro da aplicação.
controller.search = function(searchText) {

    let occurrences = [];

    searchText = searchText.toLowerCase().trim();

    const options = {
        threshold: 0.3,
        keys: [
            "registro",
            "cnpj",
            "razao_social",
            "nome_fantasia"
        ]
    }

    return new Promise((resolve, reject) => {
        reader.readCSV(row => {
            if(row.message){
                const fuse = new Fuse(occurrences, options);
                const result = fuse.search(searchText);
                resolve(result);
            } else {
                occurrences.push(row);
            }
        });
    });
}

controller.find = function(registry) {
    let result = null;

    return new Promise((resolve, reject) => {
        reader.readCSV(row => {
            if(row.message){
                resolve(result);
            } else {
                if(row.registro == registry){
                    result = row;
                }
            }
        });
    });
}

module.exports = controller;