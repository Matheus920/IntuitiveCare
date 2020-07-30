const puppeteer = require('puppeteer');
const http = require('http');
const fs = require('fs');

(async () => {
    // Iniciando o browser do Puppeteer e criando uma nova página
    console.log("Abrindo o puppeteer...");
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    // Acessando a página solicitada no teste
    console.log("Dirigindo-se à página solicitada...");
    await page.goto('http://www.ans.gov.br/prestadores/tiss-troca-de-informacao-de-saude-suplementar');
    // Clicando no link mais recente
    console.log("Clicando no link mais recente...");
    await page.click('a.alert-link');
    await page.waitFor(5000);
    // Recuperando o link para o PDF do componente organizacional
    console.log("Recuperando o link de download...");
    const urlToDownload = await page.$eval('a.btn.center-block', element => element.href);
    await browser.close();

    // Agora é feito o download do arquivo presente no link
    const file = fs.createWriteStream('ComponenteOrganizacional.pdf');
    console.log("Iniciando o download...");
    http.get(urlToDownload, response => {
        // Em caso de sucesso o evento 'finish' é disparado e uma mensagem é escrita ao usuário
        response.pipe(file);
        file.on('finish', () => {
            file.close(() => {
                console.log('Arquivo baixado com sucesso!');
                process.exit(0);
            });
        });
    }).on('error', err => {
        // Em caso de algum erro o arquivo é apagado e uma mensagem é escrita ao usuário informando o erro
        fs.unlink('ComponenteOrganizacional.pdf', () => {
            console.log(`Erro ao gravar o arquivo: ${err.message}`)
            process.exit(1);
        })
    })
})();