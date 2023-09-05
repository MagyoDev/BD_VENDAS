CREATE DATABASE BD_VENDAS

USE BD_VENDAS

DROP DATABASE BD_VENDAS

CREATE TABLE TBL_ESTADO_CIVIL(
cod_est_civ int identity NOT NULL,
desc_est_civ varchar(15) NOT NULL,
primary key(cod_est_civ)
)

CREATE TABLE TBL_TIPO_FONE(
cod_fone int identity NOT NULL,
desc_fone varchar(15) NOT NULL,
primary key(cod_fone)
)

CREATE TABLE TBL_CLIENTE(
cod_cliente int identity NOT NULL,
nome_cliente varchar(50) NOT NULL,
cod_est_civ int NOT NULL,
salario float NOT NULL,
primary key(cod_cliente),
FOREIGN KEY (cod_est_civ) REFERENCES TBL_ESTADO_CIVIL(cod_est_civ)
)

CREATE TABLE TBL_TELEFONE(
cod_cliente int NOT NULL,
cod_fone int NOT NULL,
numero_fone int NOT NULL,
FOREIGN KEY (cod_cliente) REFERENCES TBL_CLIENTE(cod_cliente),
FOREIGN KEY (cod_fone) REFERENCES TBL_TIPO_FONE(cod_fone)
)

CREATE TABLE TBL_CONJUGE(
cod_conjuge int identity NOT NULL,
nome_conjuge varchar(50) NOT NULL,
cod_cliente int NOT NULL,
primary key(cod_conjuge),
FOREIGN KEY (cod_cliente) REFERENCES TBL_CLIENTE(cod_cliente)
)

CREATE TABLE TBL_PRODUTO(
cod_produto int identity NOT NULL,
nome_produto varchar(50) NOT NULL,
tipo_produto varchar(50) NOT NULL,
primary key(cod_produto)
)

CREATE TABLE TBL_FUNC(
cod_func int identity NOT NULL,
nome_func varchar(50) NOT NULL,
primary key(cod_func)
)

CREATE TABLE TBL_PEDIDO(
cod_pedido int identity NOT NULL,
cod_cliente int NOT NULL,
cod_func int NOT NULL,
data_pedido datetime NOT NULL DEFAULT (getdate()),
primary key(cod_pedido),
FOREIGN KEY (cod_cliente) REFERENCES TBL_CLIENTE(cod_cliente),
FOREIGN KEY (cod_func) REFERENCES TBL_FUNC(cod_func)
)

CREATE TABLE TBL_ITEM_PEDIDO(
cod_pedido int NOT NULL,
cod_produto int NOT NULL,
qtde_produto int NOT NULL,
FOREIGN KEY (cod_pedido) REFERENCES TBL_PEDIDO(cod_pedido),
FOREIGN KEY (cod_produto) REFERENCES TBL_PRODUTO(cod_produto)
)

CREATE TABLE TBL_DEPENDENTE(
cod_dep int identity NOT NULL,
nome_dep varchar(50) NOT NULL,
data_nasc date NOT NULL,
cod_func int NOT NULL,
primary key(cod_dep),
FOREIGN KEY (cod_func) REFERENCES TBL_FUNC(cod_func)
)

CREATE TABLE TBL_PREMIO(
cod_func int NOT NULL,
valor_premio int NOT NULL,
FOREIGN KEY (cod_func) REFERENCES TBL_FUNC(cod_func)
)

-- Inserindo valores de estado civil
INSERT INTO TBL_ESTADO_CIVIL (desc_est_civ)
VALUES ('Solteiro'),
       ('Casado'),
       ('Divorciado'),
       ('Viúvo');

-- Inserindo valores de tipos de telefone
INSERT INTO TBL_TIPO_FONE (desc_fone)
VALUES ('Celular'),
       ('Residencial'),
       ('Trabalho');

-- Inserindo informações de clientes
INSERT INTO TBL_CLIENTE (nome_cliente, cod_est_civ, salario)
VALUES ('Rener Silva', 1, 5000),
       ('Daniel Santos', 2, 6000),
       ('Carlos Ferreira', 1, 4500);

-- Inserindo números de telefone para clientes
INSERT INTO TBL_TELEFONE (cod_cliente, cod_fone, numero_fone)
VALUES (1, 1, 123456789),
       (1, 2, 987654321),
       (2, 1, 555555555),
       (3, 1, 999999999);

-- Inserindo informações de cônjuges
INSERT INTO TBL_CONJUGE (nome_conjuge, cod_cliente)
VALUES ('Ana Silva', 1),
       ('José Santos', 2);

-- Inserindo informações de produtos
INSERT INTO TBL_PRODUTO (nome_produto, tipo_produto)
VALUES ('Camiseta', 'Vestuário'),
       ('Fósforo', 'Cozinha'),
       ('Livro', 'Cultural');

-- Inserindo informações de funcionários
INSERT INTO TBL_FUNC (nome_func)
VALUES ('Roseane Almeida'),
       ('Rita Oliveira'),
       ('Francisco Sousa');

-- Inserindo informações de pedidos
INSERT INTO TBL_PEDIDO (cod_cliente, cod_func)
VALUES (1, 1),
       (2, 2),
       (1, 3);

-- Inserindo informações de itens de pedido
INSERT INTO TBL_ITEM_PEDIDO (cod_pedido, cod_produto, qtde_produto)
VALUES (1, 1, 2),
       (1, 2, 1),
       (2, 3, 3);

-- Inserindo informações de dependentes
INSERT INTO TBL_DEPENDENTE (nome_dep, data_nasc, cod_func)
VALUES ('Ana', '2005-03-15', 1),
       ('Lucas', '2010-08-22', 2);

-- Inserindo informações de prêmios
INSERT INTO TBL_PREMIO (cod_func, valor_premio)
VALUES (1, 1000),
       (2, 750),
       (3, 500);

-- 1 - Selecione o nome dos clientes e o número de todos os telefones que cada cliente possui:
SELECT TBL_CLIENTE.nome_cliente, TBL_TELEFONE.numero_fone
FROM TBL_CLIENTE INNER JOIN TBL_TELEFONE 
ON TBL_CLIENTE.cod_cliente = TBL_TELEFONE.cod_cliente

-- 2 - Selecione o nome dos clientes casados e o nome de seus cônjuges:
SELECT TBL_CLIENTE.nome_cliente, TBL_CONJUGE.nome_conjuge
FROM TBL_CLIENTE INNER JOIN TBL_CONJUGE 
ON TBL_CLIENTE.cod_cliente = TBL_CONJUGE.cod_cliente
WHERE TBL_CLIENTE.cod_est_civ = 2 -- Código 2 é o casado

-- 3 - Selecione o nome dos clientes, o número e o tipo de telefone que cada um possui:
SELECT TBL_CLIENTE.nome_cliente, TBL_TELEFONE.numero_fone, TBL_TIPO_FONE.desc_fone
FROM TBL_CLIENTE INNER JOIN TBL_TELEFONE 
ON TBL_CLIENTE.cod_cliente = TBL_TELEFONE.cod_cliente INNER JOIN TBL_TIPO_FONE 
ON TBL_TELEFONE.cod_fone = TBL_TIPO_FONE.cod_fone

-- 4 - Selecione todas as colunas da tabela pedido, o nome do cliente que fez o pedido e o nome do funcionário que atendeu cada pedido:
SELECT TBL_PEDIDO.*, TBL_CLIENTE.nome_cliente, TBL_FUNC.nome_func
FROM TBL_PEDIDO INNER JOIN TBL_CLIENTE 
ON TBL_PEDIDO.cod_cliente = TBL_CLIENTE.cod_cliente INNER JOIN TBL_FUNC 
ON TBL_PEDIDO.cod_func = TBL_FUNC.cod_func

-- 5 - Selecione o código e a data do pedido, o nome do cliente que fez o pedido do funcionário “Francisco”:
SELECT TBL_PEDIDO.cod_pedido, TBL_PEDIDO.data_pedido, TBL_CLIENTE.nome_cliente
FROM TBL_PEDIDO INNER JOIN TBL_CLIENTE 
ON TBL_PEDIDO.cod_cliente = TBL_CLIENTE.cod_cliente INNER JOIN TBL_FUNC 
ON TBL_PEDIDO.cod_func = TBL_FUNC.cod_func
WHERE TBL_FUNC.nome_func = 'Francisco Sousa'

-- 6 - Selecione o código e a data do pedido, o nome do funcionário que atendeu o pedido do cliente "Rener":
SELECT TBL_PEDIDO.cod_pedido, TBL_PEDIDO.data_pedido, TBL_FUNC.nome_func
FROM TBL_PEDIDO INNER JOIN TBL_CLIENTE 
ON TBL_PEDIDO.cod_cliente = TBL_CLIENTE.cod_cliente INNER JOIN TBL_FUNC 
ON TBL_PEDIDO.cod_func = TBL_FUNC.cod_func
WHERE TBL_CLIENTE.nome_cliente = 'Rener Silva'

-- 7 - Mostre o nome e a data de nascimento dos dependentes de cada funcionário:
SELECT TBL_FUNC.nome_func, TBL_DEPENDENTE.nome_dep, TBL_DEPENDENTE.data_nasc
FROM TBL_FUNC INNER JOIN TBL_DEPENDENTE 
ON TBL_FUNC.cod_func = TBL_DEPENDENTE.cod_func

-- 8 - Selecione o código e a data do pedido e o nome de cada produto vendido:
SELECT TBL_ITEM_PEDIDO.cod_pedido, TBL_PEDIDO.data_pedido, TBL_PRODUTO.nome_produto
FROM TBL_ITEM_PEDIDO INNER JOIN TBL_PEDIDO 
ON TBL_ITEM_PEDIDO.cod_pedido = TBL_PEDIDO.cod_pedido INNER JOIN TBL_PRODUTO 
ON TBL_ITEM_PEDIDO.cod_produto = TBL_PRODUTO.cod_produto

-- 9 - Selecione o código e a data do pedido e o nome de funcionário que vendeu "Fósforo":
SELECT TBL_PEDIDO.cod_pedido, TBL_PEDIDO.data_pedido, TBL_FUNC.nome_func
FROM TBL_PEDIDO INNER JOIN TBL_FUNC 
ON TBL_PEDIDO.cod_func = TBL_FUNC.cod_func INNER JOIN TBL_ITEM_PEDIDO 
ON TBL_PEDIDO.cod_pedido = TBL_ITEM_PEDIDO.cod_pedido INNER JOIN TBL_PRODUTO 
ON TBL_ITEM_PEDIDO.cod_produto = TBL_PRODUTO.cod_produto
WHERE TBL_PRODUTO.nome_produto = 'Fósforo'

-- 10 - Selecione o código e a data do pedido e o nome dos produtos comprados pelo cliente "Daniel":
SELECT TBL_PEDIDO.cod_pedido, TBL_PEDIDO.data_pedido, TBL_PRODUTO.nome_produto
FROM TBL_PEDIDO INNER JOIN TBL_CLIENTE 
ON TBL_PEDIDO.cod_cliente = TBL_CLIENTE.cod_cliente INNER JOIN TBL_ITEM_PEDIDO 
ON TBL_PEDIDO.cod_pedido = TBL_ITEM_PEDIDO.cod_pedido INNER JOIN TBL_PRODUTO 
ON TBL_ITEM_PEDIDO.cod_produto = TBL_PRODUTO.cod_produto
WHERE TBL_CLIENTE.nome_cliente = 'Daniel Santos'

-- 11 - Selecione todos os produtos vendidos pela funcionária "Roseane":
SELECT TBL_PRODUTO.nome_produto
FROM TBL_FUNC INNER JOIN TBL_PEDIDO 
ON TBL_FUNC.cod_func = TBL_PEDIDO.cod_func INNER JOIN TBL_ITEM_PEDIDO 
ON TBL_PEDIDO.cod_pedido = TBL_ITEM_PEDIDO.cod_pedido INNER JOIN TBL_PRODUTO 
ON TBL_ITEM_PEDIDO.cod_produto = TBL_PRODUTO.cod_produto
WHERE TBL_FUNC.nome_func = 'Roseane Almeida'

-- 12 - Selecione o nome dos clientes e o nome dos produtos comprados respectivamente:
SELECT TBL_CLIENTE.nome_cliente, TBL_PRODUTO.nome_produto
FROM TBL_CLIENTE INNER JOIN TBL_PEDIDO 
ON TBL_CLIENTE.cod_cliente = TBL_PEDIDO.cod_cliente INNER JOIN TBL_ITEM_PEDIDO 
ON TBL_PEDIDO.cod_pedido = TBL_ITEM_PEDIDO.cod_pedido INNER JOIN TBL_PRODUTO 
ON TBL_ITEM_PEDIDO.cod_produto = TBL_PRODUTO.cod_produto;

-- 13 - Selecione o nome dos funcionários e o nome dos produtos vendidos respectivamente:
SELECT TBL_FUNC.nome_func, TBL_PRODUTO.nome_produto
FROM TBL_FUNC INNER JOIN TBL_PEDIDO 
ON TBL_FUNC.cod_func = TBL_PEDIDO.cod_func INNER JOIN TBL_ITEM_PEDIDO 
ON TBL_PEDIDO.cod_pedido = TBL_ITEM_PEDIDO.cod_pedido INNER JOIN TBL_PRODUTO 
ON TBL_ITEM_PEDIDO.cod_produto = TBL_PRODUTO.cod_produto

-- 14 - Mostre o nome dos funcionários e o valor total dos prêmios que cada funcionário tem:
SELECT TBL_FUNC.nome_func, SUM(TBL_PREMIO.valor_premio) AS valor_total_premios
FROM TBL_FUNC INNER JOIN TBL_PREMIO 
ON TBL_FUNC.cod_func = TBL_PREMIO.cod_func
GROUP BY TBL_FUNC.nome_func

-- 15 - Mostre o nome dos funcionários e quantidade de dependentes de cada funcionário:
SELECT TBL_FUNC.nome_func, COUNT(TBL_DEPENDENTE.cod_dep) 
AS quantidade_dependentes
FROM TBL_FUNC INNER JOIN TBL_DEPENDENTE 
ON TBL_FUNC.cod_func = TBL_DEPENDENTE.cod_func
GROUP BY TBL_FUNC.nome_func

-- 16 - Mostre a quantidade de clientes “Casados”, “Solteiros” e “Separados”:
SELECT TBL_ESTADO_CIVIL.desc_est_civ, COUNT(TBL_CLIENTE.cod_cliente) 
AS quantidade_clientes
FROM TBL_ESTADO_CIVIL INNER JOIN TBL_CLIENTE 
ON TBL_ESTADO_CIVIL.cod_est_civ = TBL_CLIENTE.cod_est_civ
GROUP BY TBL_ESTADO_CIVIL.desc_est_civ

-- 17 - Selecione os dados dos clientes que não têm telefone:
SELECT TBL_CLIENTE.*
FROM TBL_CLIENTE INNER JOIN TBL_TELEFONE 
ON TBL_CLIENTE.cod_cliente = TBL_TELEFONE.cod_cliente
WHERE TBL_TELEFONE.cod_fone IS NULL

-- 18 - Selecione os dados dos clientes “Solteiros”:
SELECT TBL_CLIENTE.*
FROM TBL_CLIENTE INNER JOIN TBL_ESTADO_CIVIL 
ON TBL_CLIENTE.cod_est_civ = TBL_ESTADO_CIVIL.cod_est_civ
WHERE TBL_ESTADO_CIVIL.desc_est_civ = 'Solteiro'

-- 19 - Selecione os dados dos clientes “Casados”:
SELECT TBL_CLIENTE.*
FROM TBL_CLIENTE INNER JOIN TBL_ESTADO_CIVIL 
ON TBL_CLIENTE.cod_est_civ = TBL_ESTADO_CIVIL.cod_est_civ
WHERE TBL_ESTADO_CIVIL.desc_est_civ = 'Casado'

-- 20 - Selecione os dados dos funcionários que não têm prêmios:
SELECT TBL_FUNC.*
FROM TBL_FUNC INNER JOIN TBL_PREMIO 
ON TBL_FUNC.cod_func = TBL_PREMIO.cod_func
WHERE TBL_PREMIO.cod_func IS NULL

-- 21 - Selecione os dados dos funcionários que não têm dependentes:
SELECT TBL_FUNC.*
FROM TBL_FUNC INNER JOIN TBL_DEPENDENTE 
ON TBL_FUNC.cod_func = TBL_DEPENDENTE.cod_func
WHERE TBL_DEPENDENTE.cod_func IS NULL

-- 22 - Selecione os produtos que nunca foram vendidos:
SELECT TBL_PRODUTO.*
FROM TBL_PRODUTO INNER JOIN TBL_ITEM_PEDIDO 
ON TBL_PRODUTO.cod_produto = TBL_ITEM_PEDIDO.cod_produto
WHERE TBL_ITEM_PEDIDO.cod_produto IS NULL

SELECT        
FROM            TBL_FUNC INNER JOIN
                         TBL_DEPENDENTE ON TBL_FUNC.cod_func = TBL_DEPENDENTE.cod_func INNER JOIN
                         TBL_PEDIDO ON TBL_FUNC.cod_func = TBL_PEDIDO.cod_func INNER JOIN
                         TBL_CLIENTE INNER JOIN
                         TBL_CONJUGE ON TBL_CLIENTE.cod_cliente = TBL_CONJUGE.cod_cliente INNER JOIN
                         TBL_ESTADO_CIVIL ON TBL_CLIENTE.cod_est_civ = TBL_ESTADO_CIVIL.cod_est_civ ON TBL_PEDIDO.cod_cliente = TBL_CLIENTE.cod_cliente INNER JOIN
                         TBL_ITEM_PEDIDO ON TBL_PEDIDO.cod_pedido = TBL_ITEM_PEDIDO.cod_pedido INNER JOIN
                         TBL_PREMIO ON TBL_FUNC.cod_func = TBL_PREMIO.cod_func INNER JOIN
                         TBL_PRODUTO ON TBL_ITEM_PEDIDO.cod_produto = TBL_PRODUTO.cod_produto INNER JOIN
                         TBL_TELEFONE ON TBL_CLIENTE.cod_cliente = TBL_TELEFONE.cod_cliente INNER JOIN
                         TBL_TIPO_FONE ON TBL_TELEFONE.cod_fone = TBL_TIPO_FONE.cod_fone
