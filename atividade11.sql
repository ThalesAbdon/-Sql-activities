-- Criação do schema
CREATE SCHEMA IF NOT EXISTS `cafeteria_bomgosto` DEFAULT CHARACTER SET utf8;
USE `cafeteria_bomgosto`;

-- Criação da tabela CARDÁPIO
CREATE TABLE IF NOT EXISTS `CARDAPIO` (
  `cardapio_id` INT NOT NULL AUTO_INCREMENT,
  `nome_cafe` VARCHAR(255) NOT NULL,
  `descricao` TEXT NOT NULL,
  `preco_unitario` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`cardapio_id`)
) ENGINE = InnoDB;

-- Criação da tabela COMANDA
CREATE TABLE IF NOT EXISTS `COMANDA` (
  `comanda_id` INT NOT NULL AUTO_INCREMENT,
  `data_comanda` DATE NOT NULL,
  `mesa` INT NOT NULL,
  `nome_cliente` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`comanda_id`)
) ENGINE = InnoDB;

-- Criação da tabela ITENS_COMANDA
CREATE TABLE IF NOT EXISTS `ITENS_COMANDA` (
  `item_id` INT NOT NULL AUTO_INCREMENT,
  `comanda_id` INT NOT NULL,
  `cardapio_id` INT NOT NULL,
  `quantidade` INT NOT NULL,
  PRIMARY KEY (`item_id`),
  FOREIGN KEY (`comanda_id`) REFERENCES `COMANDA`(`comanda_id`),
  FOREIGN KEY (`cardapio_id`) REFERENCES `CARDAPIO`(`cardapio_id`)
) ENGINE = InnoDB;

-- Inserção de dados na tabela CARDÁPIO
INSERT INTO `CARDAPIO` (nome_cafe, descricao, preco_unitario) 
VALUES ('Café Expresso', 'Café puro e forte', 4.50),
       ('Café Latte', 'Café com leite vaporizado', 6.00),
       ('Cappuccino', 'Café com leite vaporizado e espuma', 7.00),
       ('Mocha', 'Café, leite, chocolate e chantilly', 8.50);

-- Inserção de dados na tabela COMANDA
INSERT INTO `COMANDA` (data_comanda, mesa, nome_cliente) 
VALUES ('2024-10-15', 1, 'João'),
       ('2024-10-15', 2, 'Mayara Souza'),
       ('2024-10-16', 1, 'Carlos Pereira');

-- Inserção de dados na tabela ITENS_COMANDA
INSERT INTO `ITENS_COMANDA` (comanda_id, cardapio_id, quantidade) 
VALUES (1, 1, 2),  -- 2 Cafés Expresso para João
       (1, 2, 1),  -- 1 Café Latte para João
       (2, 3, 3),  -- 3 Cappuccinos para Mayara Souza
       (3, 4, 1),  -- 1 Mocha para Carlos Pereira
       (3, 1, 1);  -- 1 Café Expresso para Carlos Pereira

-- Consultas para responder às perguntas:

-- 1) Listagem do cardápio ordenada por nome
SELECT nome_cafe, descricao, preco_unitario 
FROM CARDAPIO 
ORDER BY nome_cafe;

-- 2) Comandas (código, data, mesa, nome do cliente) e itens da comanda (nome do café, descrição, quantidade, preço unitário e preço total do café)
SELECT 
    c.comanda_id, 
    c.data_comanda, 
    c.mesa, 
    c.nome_cliente,
    ca.nome_cafe,
    ca.descricao,
    ic.quantidade,
    ca.preco_unitario,
    (ic.quantidade * ca.preco_unitario) AS preco_total
FROM COMANDA c
INNER JOIN ITENS_COMANDA ic ON c.comanda_id = ic.comanda_id
INNER JOIN CARDAPIO ca ON ic.cardapio_id = ca.cardapio_id
ORDER BY c.data_comanda, c.comanda_id, ca.nome_cafe;

-- 3) Comandas (código, data, mesa, nome do cliente) e o valor total da comanda, ordenado por data
SELECT 
    c.comanda_id, 
    c.data_comanda, 
    c.mesa, 
    c.nome_cliente,
    SUM(ic.quantidade * ca.preco_unitario) AS valor_total_comanda
FROM COMANDA c
INNER JOIN ITENS_COMANDA ic ON c.comanda_id = ic.comanda_id
INNER JOIN CARDAPIO ca ON ic.cardapio_id = ca.cardapio_id
GROUP BY c.comanda_id
ORDER BY c.data_comanda;

-- 4) Comandas com mais de um tipo de café na comanda, ordenadas por data
SELECT 
    c.comanda_id, 
    c.data_comanda, 
    c.mesa, 
    c.nome_cliente,
    SUM(ic.quantidade * ca.preco_unitario) AS valor_total_comanda
FROM COMANDA c
INNER JOIN ITENS_COMANDA ic ON c.comanda_id = ic.comanda_id
INNER JOIN CARDAPIO ca ON ic.cardapio_id = ca.cardapio_id
GROUP BY c.comanda_id
HAVING COUNT(ic.cardapio_id) > 1
ORDER BY c.data_comanda;

-- 5) Total de faturamento por data, ordenado por data
SELECT 
    c.data_comanda, 
    SUM(ic.quantidade * ca.preco_unitario) AS faturamento_total
FROM COMANDA c
INNER JOIN ITENS_COMANDA ic ON c.comanda_id = ic.comanda_id
INNER JOIN CARDAPIO ca ON ic.cardapio_id = ca.cardapio_id
GROUP BY c.data_comanda
ORDER BY c.data_comanda;
