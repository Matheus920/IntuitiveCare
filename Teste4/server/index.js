const controller = require ('./controller/controller');
const express = require('express');
const app = express();
const PORT = 3000;

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "http://localhost:8080");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

app.get('/:searchText', async (req, res) => {

    const searchText = req.params.searchText;

    if (!searchText || searchText.length > 255 || searchText.length < 3) {
        res.status(400).send({
            mensagem: "Envie um texto com no máximo 255 e no mínimo 3 caracteres para a busca."
        });
    }

    let result = await controller.search(searchText);

    res.send(result);
});

app.get('/details/:registry', async (req, res) => {
    const registry = req.params.registry;

    if(!registry){
        res.status(400).send({
            mensagem: "Entre com um registro válido."
        });
    }

    const result = await controller.find(registry);

    if(!result){
        res.status(404).send({
            mensagem: "O registro procurado não foi encontrado."
        });
    }

    res.send(result);
});

app.listen(PORT, () => {
    console.log(`Server funcionando na porta ${PORT}`);
});