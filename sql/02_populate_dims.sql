-- ==========================================================
-- PROJETO:  Data Warehouse
-- OBJETIVO: Carga de Dados (ETL) para Tabelas de Dimensão
-- ==========================================================

-- 1. Populando a Dimensão Tempo
-- Geramos uma série histórica de 30 anos no passado até 5 anos no futuro.
-- Isso garante que o DW suporte tanto dados históricos quanto metas futuras.
INSERT INTO data_warehouse.dim_tempo(id_tempo, data, ano, mes, dia, trimestre, dia_semana, mes_extenso)
SELECT
    CAST(TO_CHAR(dt, 'YYYYMMDD') AS INT) AS id_tempo, -- Surrogate Key inteligente baseada na data
    dt as data,
    EXTRACT(YEAR FROM dt) AS ano,
    EXTRACT(MONTH FROM dt) AS mes,
    EXTRACT(DAY FROM dt) AS dia,
    EXTRACT(QUARTER FROM dt) AS trimestre,
    TO_CHAR(dt, 'TMDay') AS dia_semana, -- 'TM' traduz para o idioma do servidor (ex: Português)
    TO_CHAR(dt, 'TMMonth') AS mes_extenso
FROM
    generate_series(CURRENT_DATE - INTERVAL '30 years',
                    CURRENT_DATE + INTERVAL '5 years', INTERVAL '1 day') AS dt;

-- 2. Populando a Dimensão Território
-- Utilizamos o DISTINCT para mapear todos os locais de entrega únicos presentes na origem.
INSERT INTO data_warehouse.dim_territorio(endereco, cidade, regiao, cep, pais)
SELECT DISTINCT 
    endereco_navio, 
    cidade_navio, 
    regiao_navio,
    cep_navio,
    pais_navio
FROM public.pedidos;

-- 3. Populando a Dimensão Produtos
-- Unificamos Produto, Fornecedor e Categoria para evitar JOINs excessivos na tabela fato.
INSERT INTO data_warehouse.dim_produtos(id_produto, nome_produto, fornecedor, categoria)
SELECT DISTINCT 
    pro.id AS id_produto,
    pro.nome AS nome_produto,
    f.nome_empresa AS fornecedor, 
    c.nome AS categoria
FROM public.produtos pro
INNER JOIN public.fornecedores f ON pro.id_transportadora = f.id
INNER JOIN public.categorias c ON pro.id_categoria = c.id_1
ORDER BY pro.id;

-- 4. Populando a Dimensão Funcionário
-- Realizamos a limpeza e concatenação de strings para criar o nome completo.
INSERT INTO data_warehouse.dim_funcionario(id_fun, nome_completo, cargo, data_nascimento, data_contratacao)
SELECT DISTINCT 
    fun.id AS id_fun, 
    CONCAT(fun.primeiro_nome, ' ', fun.ultimo_nome) AS nome_completo,
    fun.titulo AS cargo,
    fun.data_nascimento,
    fun.data_contratacao 
FROM public.funcionarios fun
ORDER BY fun.id;
