-- =========================================================================
-- AULA PRÁTICA: TRANSFORMAÇÃO DO MODELO CONCEITUAL (DER) 
-- Contexto: Módulo de Vendas / E-commerce (Baseado no Exercício de Fixação 1)
-- =========================================================================

-- Remove o banco de dados se ele já existir para evitar erros
DROP DATABASE IF EXISTS VendasDB;

-- Criação do banco de dados (o nosso "container" de tabelas)
CREATE DATABASE VendasDB;
USE VendasDB;

-- =========================================================================
-- 1. TABELA CLIENTE (Entidade Forte)
-- CONCEITO: 
-- * No DER em papel, o Cliente tinha o CPF como identificador (Chave Natural).
-- * DECISÃO DE PROJETO: Adotamos um 'idCliente' artificial (Surrogate Key) do tipo INT UNSIGNED. 
-- * POR QUE 'UNSIGNED'? Removemos os números negativos, dobrando o limite 
--   de clientes que o sistema pode cadastrar (de 2 bilhões para 4 bilhões).
-- =========================================================================
CREATE TABLE Cliente (
-- idCliente: Chave Primária (PK). Identifica unicamente cada cliente de forma segura.
idCliente INT UNSIGNED NOT NULL PRIMARY KEY,

-- nome: Atributo simples/atômico obrigatório (NOT NULL).
nome VARCHAR(125) NOT NULL

-- NOTA SOBRE O CPF: 
    -- Se quiséssemos guardar o CPF, ele não seria a PK. Criaríamos a coluna 
    -- 'cpf VARCHAR(11) UNIQUE NOT NULL' para garantir que não haja CPFs duplicados, 
    -- mantendo o idCliente como a âncora principal da tabela.
);

-- =========================================================================
-- 2. TABELA PEDIDO (O Lado "N" do Relacionamento 1:N com Cliente)
-- CONCEITO DE MAPEAMENTO (REGRA DE OURO):
-- - No relacionamento 1:N ("Um cliente realiza muitos pedidos"), a chave 
--   primária da entidade "1" (Cliente) "viaja" para a entidade "N" (Pedido) 
--   transformando-se em uma Chave Estrangeira (Foreign Key).
-- =========================================================================
CREATE TABLE Pedido (

  -- idPedido: Identificador único de cada pedido realizado
  idPedido int UNSIGNED NOT NULL PRIMARY KEY,

  -- dataPedido: Armazena o momento em que a compra foi efetuada.
  dataPedido DATE NOT NULL,

  -- idCliente (FK): A "ponte" que liga o pedido ao seu respectivo cliente.
  -- Precisa ter EXATAMENTE o mesmo tipo de dado da origem (INT UNSIGNED).
  idCliente INT UNSIGNED NOT NULL,

  -- CONSTRAINT (Restrição de Integridade Referencial):
  -- Garante que nenhum pedido seja cadastrado no sistema para um "fantasma" 
  -- (ou seja, o idCliente informado precisa existir obrigatoriamente na tabela Cliente).
  CONSTRAINT fk_cliente
    FOREIGN KEY (idCliente)
    REFERENCES Cliente(idCliente)
);

-- =========================================================================
-- 3. POVOANDO O BANCO DE DADOS (INSERÇÃO DE DADOS - DML)
-- =========================================================================

-- CONCEITO DE ORDEM DE INSERÇÃO:
-- Como a tabela 'Pedido' depende da tabela 'Cliente' (devido à Chave Estrangeira),
-- DEVEMOS primeiro cadastrar os Clientes. Tentar cadastrar um Pedido para um 
-- Cliente que ainda não existe resultará em erro de integridade referencial!

-- Cadastrando os Clientes na tabela Cliente:
INSERT INTO Cliente (idCliente, nome) VALUES (1, 'Carlos Eduardo Silva');
INSERT INTO Cliente (idCliente, nome) VALUES (2, 'Maria Fernanda Oliveira');
INSERT INTO Cliente (idCliente, nome) VALUES (3, 'João Pedro Santos');
INSERT INTO Cliente (idCliente, nome) VALUES (4, 'Ana Carolina da Silva Bezerril');
INSERT INTO Cliente (idCliente, nome) VALUES (5, 'Ana Luiza Ferreira dos Santos');
INSERT INTO Cliente (idCliente, nome) VALUES (6, 'Breno Gabriel do Nascimento Lins');
INSERT INTO Cliente (idCliente, nome) VALUES (7, 'Bruno Luiz da Silva');
INSERT INTO Cliente (idCliente, nome) VALUES (8, 'Jacinto da Luz Neto');
INSERT INTO Cliente (idCliente, nome) VALUES (9, 'MARIA EDUARDA CAVALCANTE BEZERRA');
INSERT INTO Cliente (idCliente, nome) VALUES (10, 'Maria Luiza do Nascimento Galdino');

-- Cadastrando os Pedidos na tabela Pedido:
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (101, '2026-03-01', 1);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (102, '2026-03-02', 1);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (103, '2026-03-05', 2);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (104, '2026-03-06', 4);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (105, '2026-03-07', 4);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (106, '2026-03-08', 5);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (107, '2026-03-09', 5);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (108, '2026-03-10', 6);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (109, '2026-03-11', 6);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (110, '2026-03-12', 7);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (111, '2026-03-13', 7);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (112, '2026-03-14', 8);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (113, '2026-03-15', 8);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (114, '2026-03-16', 9);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (115, '2026-03-17', 9);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (116, '2026-03-18', 10);
INSERT INTO Pedido (idPedido, dataPedido, idCliente) VALUES (117, '2026-03-19', 10);

-- NOTA SOBRE O CLIENTE 3 (João Pedro):
-- O cliente João Pedro foi cadastrado, mas ainda não realizou nenhum pedido.
-- Isso nos ajudará a entender a diferença nos tipos de consulta (JOINs).


-- =========================================================================
-- TESTE DE SEGURANÇA / INTEGRIDADE REFERENCIAL (DESAFIO PARA OS ALUNOS)
-- =========================================================================
-- O comando abaixo está COMENTADO porque, se for executado, GERARÁ UM ERRO!
-- Motivo: O idCliente 99 não existe na tabela Cliente. A CONSTRAINT 'fk_cliente'
-- impede que o sistema aceite compras feitas por "clientes fantasmas".

-- INSERT INTO Pedido (idPedido, dataPedido, idCliente) 
-- VALUES (118, '2026-03-20', 99); 
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails...


-- =========================================================================
-- 4. CONSULTANDO OS DADOS (SELECT & JOINs)
-- =========================================================================

-- -------------------------------------------------------------------------
-- CONSULTA 1: Listar todos os clientes cadastrados
-- -------------------------------------------------------------------------
SELECT * FROM Cliente;

SELECT idCliente, nome FROM Cliente;

SELECT IdCliente AS 'Codigo do Cliente', nome AS 'Nome' FROM Cliente;


-- -------------------------------------------------------------------------
-- CONSULTA 2: Listar todos os pedidos cadastrados
-- -------------------------------------------------------------------------
SELECT * FROM Pedido;


-- -------------------------------------------------------------------------
-- CONSULTA 3: Cruzamento de Dados (INNER JOIN)
-- Exibe apenas os pedidos que possuem um cliente associado 
-- e apenas os clientes que efetuaram pedidos.
-- -------------------------------------------------------------------------
SELECT 
    p.idPedido AS 'Código do Pedido',
    p.dataPedido AS 'Data da Compra',
    c.nome AS 'Nome do Cliente'
FROM Pedido p
INNER JOIN Cliente c ON p.idCliente = c.idCliente;

-- EXPLICAÇÃO DO INNER JOIN:
-- 1. 'Pedido p' e 'Cliente c': Usamos "apelidos" (aliases) para facilitar a leitura.
-- 2. 'ON p.idCliente = c.idCliente': É a "ponte". Diz ao banco para ligar a FK da 
--    tabela Pedido com a PK da tabela Cliente.


-- -------------------------------------------------------------------------
-- CONSULTA 4: Cruzamento Completo (LEFT JOIN)
-- Exibe TODOS os clientes, inclusive aqueles que NUNCA fizeram pedidos.
-- -------------------------------------------------------------------------
SELECT 
    c.idCliente AS 'ID Cliente',
    c.nome AS 'Nome do Cliente',
    p.idPedido AS 'Código do Pedido',
    p.dataPedido AS 'Data'
FROM Cliente c
LEFT JOIN Pedido p ON c.idCliente = p.idCliente;

-- EXPLICAÇÃO DO LEFT JOIN:
-- A tabela da esquerda (Cliente) é a principal. Todos os seus registros aparecem.
-- Como o cliente 'João Pedro Santos' não realizou compras, as colunas do pedido
-- para ele serão preenchidas como 'NULL' (Vazio/Ausente).

