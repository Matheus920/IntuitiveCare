# Primeiro é criada uma database para conter as tabelas que serão criadas
CREATE DATABASE IF NOT EXISTS IntuitiveCare;

# Em seguida é utilizado um comando para indicar que essa database será usada
USE IntuitiveCare;

# A tabela criada a seguir tem os campos correspondentes ao do CSV dos Registros_ANS.
# Entretanto a maioria dos campos estão como VARCHAR de tamanho 255 devido ao grande
# número de dados truncados que encontrei durante meus testes. 
CREATE TABLE IF NOT EXISTS registros (
	Registro_ANS VARCHAR(255) NOT NULL,
    CNPJ VARCHAR(255),
    Razao_Social VARCHAR(255),
    Nome_Fantasia VARCHAR(255),
    Modalidade VARCHAR(255),
    Logradouro VARCHAR(255),
    Numero VARCHAR(255),
    Complemento VARCHAR(255),
    Bairro VARCHAR(255),
    Cidade VARCHAR(255),
    UF VARCHAR(2),
    CEP VARCHAR(255),
    DDD VARCHAR(5),
    Telefone VARCHAR(255),
    Fax VARCHAR(255),
    Endereco_Eletronico VARCHAR(255),
    Representante VARCHAR(255),
    Cargo_Representante VARCHAR(255),
    Data_Registro_ANS VARCHAR(255),
    PRIMARY KEY (Registro_ANS)
);

# Em seguida a tabela criada é preenchida com os dados do Relatorio_cadop.csv
# IMPORTANTE: É necessário alterar o path do arquivo para o que você utilizará em sua máquina.
LOAD DATA LOCAL INFILE '/home/matheus/Documents/IntuitiveCare/Teste3/resources/Relatorio_cadop.csv'
INTO TABLE registros
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 3 ROWS;

# Para a tabela das demonstrações é necessário ter campos do tipo Date e Double
# de modo a permitir responder as perguntas num futuro próximo.
CREATE TABLE IF NOT EXISTS demonstracoes (
	`DATA` DATE,
    REG_ANS VARCHAR(255) NOT NULL,
    CD_CONTA_CONTABIL VARCHAR(255),
    DESCRICAO VARCHAR(255),
    VL_SALDO_FINAL DOUBLE
);

# Em seguida a tabela criada é preenchida com os dados dos trimestres, aproveitando
# para fazer a conversão do formato brasileiro para o americano dos pontos flutuantes
# e das datas.
# IMPORTANTE: É necessário alterar o path do arquivo para o que você utilizará em sua máquina.
LOAD DATA LOCAL INFILE '/home/matheus/Documents/IntuitiveCare/Teste3/resources/1T2019.csv'
INTO TABLE demonstracoes
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@`DATA`, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET `DATA` = STR_TO_DATE(@`DATA`, '%d/%m/%Y'),
VL_SALDO_FINAL = replace(@VL_SALDO_FINAL, ',', '.');

# IMPORTANTE: É necessário alterar o path do arquivo para o que você utilizará em sua máquina.
LOAD DATA LOCAL INFILE '/home/matheus/Documents/IntuitiveCare/Teste3/resources/2T2019.csv'
INTO TABLE demonstracoes
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@`DATA`, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET `DATA` = STR_TO_DATE(@`DATA`, '%d/%m/%Y'),
VL_SALDO_FINAL = replace(@VL_SALDO_FINAL, ',', '.');

# IMPORTANTE: É necessário alterar o path do arquivo para o que você utilizará em sua máquina.
LOAD DATA LOCAL INFILE '/home/matheus/Documents/IntuitiveCare/Teste3/resources/3T2019.csv'
INTO TABLE demonstracoes
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@`DATA`, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET `DATA` = STR_TO_DATE(@`DATA`, '%d/%m/%Y'),
VL_SALDO_FINAL = replace(@VL_SALDO_FINAL, ',', '.');

# IMPORTANTE: É necessário alterar o path do arquivo para o que você utilizará em sua máquina.
LOAD DATA LOCAL INFILE '/home/matheus/Documents/IntuitiveCare/Teste3/resources/4T2019.csv'
INTO TABLE demonstracoes
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@`DATA`, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET `DATA` = STR_TO_DATE(@`DATA`, '%d/%m/%Y'),
VL_SALDO_FINAL = replace(@VL_SALDO_FINAL, ',', '.');

# IMPORTANTE: É necessário alterar o path do arquivo para o que você utilizará em sua máquina.
LOAD DATA LOCAL INFILE '/home/matheus/Documents/IntuitiveCare/Teste3/resources/1T2020.csv'
INTO TABLE demonstracoes
CHARACTER SET latin1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@`DATA`, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, @VL_SALDO_FINAL)
SET `DATA` = STR_TO_DATE(@`DATA`, '%d/%m/%Y'),
VL_SALDO_FINAL = replace(@VL_SALDO_FINAL, ',', '.');

# Enfim, temos o primeiro SELECT, que responde à pergunta de quais empresas tiveram
# mais gastos com EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR
# no último trimestre.
SELECT demonstracoes.REG_ANS, 
registros.Razao_social,
demonstracoes.DESCRICAO,
demonstracoes.VL_SALDO_FINAL
FROM demonstracoes
INNER JOIN  registros
ON demonstracoes.REG_ANS = registros.Registro_ANS
WHERE DESCRICAO = "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR "
AND `DATA` = "2020-01-01" 
ORDER BY VL_SALDO_FINAL DESC
LIMIT 10;

# A query a seguir responde à segunda pergunta, dessa vez relativa ao último ano como um todo.
# Foi utilizado o ano de 2019 como referência.
SELECT demonstracoes.REG_ANS, 
registros.Razao_social,
demonstracoes.DESCRICAO,
SUM(demonstracoes.VL_SALDO_FINAL) AS SALDO_FINAL_SOMADO
FROM demonstracoes
INNER JOIN  registros
ON demonstracoes.REG_ANS = registros.Registro_ANS
WHERE DESCRICAO = "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR "
AND `DATA` BETWEEN "2019-01-01" AND "2019-12-31"
GROUP BY demonstracoes.REG_ANS 
ORDER BY SALDO_FINAL_SOMADO DESC
LIMIT 10;