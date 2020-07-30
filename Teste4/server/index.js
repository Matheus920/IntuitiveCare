const controller = require ('./controller/controller');
const express = require('express');
const app = express();
const PORT = 3000;

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

app.listen(PORT, () => {
    console.log(`Server funcionando na porta ${PORT}`);
});