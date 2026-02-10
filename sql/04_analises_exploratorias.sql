-- ==========================================================
-- PROJETO: Northwind Data Warehouse
-- OBJETIVO: Análises Exploratórias e Insights de Negócio
-- ==========================================================

-- 1. Lucratividade por Categoria
-- Descobrimos onde está a maior margem e o peso dos descontos.
SELECT 
    p.categoria, 
    SUM(f.quantidade) AS total_itens,
    SUM(f.preco_unitario * f.quantidade)::numeric(18,2) AS faturamento_bruto,
    SUM(f.preco_liquido_item)::numeric(18,2) AS faturamento_liquido,
    (SUM(f.desconto) / NULLIF(SUM(f.preco_unitario * f.quantidade), 0) * 100)::numeric(10,2) AS perc_medio_desconto
FROM data_warehouse.fato_venda f
JOIN data_warehouse.dim_produtos p ON f.id_produto = p.id_produto
GROUP BY p.categoria
ORDER BY faturamento_liquido DESC;

-- 2. Sazonalidade Mensal
-- Identificamos picos de venda usando a inteligência da dim_tempo.
SELECT 
    t.ano, 
    t.mes_extenso, 
    SUM(f.preco_liquido_item)::numeric(18,2) AS total_vendas
FROM data_warehouse.fato_venda f
JOIN data_warehouse.dim_tempo t ON f.id_tempo = t.id_tempo
GROUP BY t.ano, t.mes, t.mes_extenso
ORDER BY t.ano, t.mes;

-- 3. Impacto do Frete na Margem por País
-- Analisamos se o custo logístico está "engolindo" o lucro em certas regiões.
SELECT 
    tr.pais, 
    COUNT(DISTINCT f.id_pedido) AS total_pedidos,
    SUM(f.frete)::numeric(18,2) AS custo_frete_total,
    SUM(f.preco_liquido_item)::numeric(18,2) AS receita_liquida,
    (SUM(f.frete) / NULLIF(SUM(f.preco_liquido_item), 0) * 100)::numeric(10,2) AS impacto_frete_percentual
FROM data_warehouse.fato_venda f
JOIN data_warehouse.dim_territorio tr ON f.id_territorio = tr.id_territorio
GROUP BY tr.pais

-- 4. Análise Geográfica: As 10 cidades com menor performance de vendas
-- Objetivo: Identificar regiões com baixo volume para ações de marketing ou revisão logística.
SELECT 
    tr.cidade,
    tr.pais,
    COUNT(DISTINCT f.id_pedido) AS total_pedidos,
    SUM(f.preco_liquido_item)::numeric(18,2)::money AS total_vendas
FROM data_warehouse.fato_venda f
JOIN data_warehouse.dim_territorio tr ON f.id_territorio = tr.id_territorio
GROUP BY tr.cidade, tr.pais
ORDER BY total_vendas ASC -- Foco nos menores valores primeiro
LIMIT 10;
ORDER BY impacto_frete_percentual DESC;

-- 5. Performance Trimestral: Visão Executiva

SELECT 
    t.ano, 
    t.trimestre, 
    SUM(f.preco_liquido_item)::numeric(18,2)::money AS total_vendas,
    COUNT(DISTINCT f.id_pedido) AS total_pedidos
FROM data_warehouse.fato_venda f
JOIN data_warehouse.dim_tempo t ON f.id_tempo = t.id_tempo
GROUP BY t.ano, t.trimestre
ORDER BY t.ano DESC, t.trimestre DESC;

