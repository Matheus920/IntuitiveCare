const reader = require('../data/reader');
const Fuse = require('fuse.js');

let controller = {}

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

module.exports = controller;