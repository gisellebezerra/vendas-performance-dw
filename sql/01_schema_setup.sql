-- ==========================================================
-- PROJETO: Data Warehouse
-- OBJETIVO: Criação das tabelas (Dimensões e Fato)
-- ARQUITETURA: Star Schema
-- ==========================================================

-- 1. Criação do Schema (Garante que o ambiente esteja isolado)
CREATE SCHEMA IF NOT EXISTS data_warehouse;

-- 2. Criação da Dimensão Tempo

CREATE TABLE data_warehouse.dim_tempo (
    id_tempo INT PRIMARY KEY,  
    data DATE UNIQUE,       
    dia INT,
    mes INT,
    ano INT,
    trimestre INT,
    dia_semana VARCHAR(30),   
    mes_extenso VARCHAR(30)    
);

-- 3. Criação da Dimensão Território

CREATE TABLE data_warehouse.dim_territorio ( 
    id_territorio SERIAL PRIMARY KEY,  
    endereco VARCHAR,  
    cidade VARCHAR,  
    regiao VARCHAR,  
    pais VARCHAR,  
    cep VARCHAR
); 

-- 4. Criação da Dimensão Produtos

CREATE TABLE data_warehouse.dim_produtos (
    id_produto INT PRIMARY KEY,
    nome_produto VARCHAR(300),
    fornecedor VARCHAR(300),
    categoria VARCHAR(300)
);

-- 5. Criação da Dimensão Funcionário

CREATE TABLE data_warehouse.dim_funcionario (
    id_fun INT PRIMARY KEY,
    nome_completo VARCHAR,
    cargo VARCHAR,
    data_nascimento DATE,
    data_contratacao DATE 
);

-- 6. Criação da Tabela Fato (fato_venda)

CREATE TABLE data_warehouse.fato_venda (
    id_venda SERIAL PRIMARY KEY,
    id_tempo INT REFERENCES data_warehouse.dim_tempo(id_tempo),
    id_territorio INT REFERENCES data_warehouse.dim_territorio(id_territorio),
    id_produto INT REFERENCES data_warehouse.dim_produtos(id_produto),
    id_fun INT REFERENCES data_warehouse.dim_funcionario(id_fun),
    id_pedido INT, 
    quantidade INT,
    preco_unitario NUMERIC(18,2),
    desconto NUMERIC(18,2),
    preco_liquido_item NUMERIC(18,2),
    frete NUMERIC(18,2),
    data_pedido DATE,
    data_enviado DATE
);

-- Comentário técnico: O uso de NUMERIC(18,2) garante precisão absoluta para cálculos financeiros.
