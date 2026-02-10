-- ==========================================================
-- PROJETO: Data Warehouse
-- OBJETIVO: Carga da Tabela Fato (Processo de ETL Final)
-- ==========================================================

INSERT INTO data_warehouse.fato_venda (
    id_tempo, 
    id_territorio, 
    id_produto, 
    id_fun, 
    id_pedido, 
    quantidade, 
    preco_unitario, 
    desconto, 
    preco_liquido_item, 
    frete,
    data_pedido,
    data_enviado
)
SELECT DISTINCT 
    tp.id_tempo,
    tr.id_territorio,
    pro.id_produto,
    f.id_fun,
    p.id as id_pedido,
    pd.quantidade,
    pd.preco_unitario,
    pd.desconto,
    -- Cálculo da métrica de performance: Valor Líquido por Item
    ((pd.preco_unitario * pd.quantidade) - pd.desconto)::numeric(18,2) AS preco_liquido_item, 
    p.frete,
    p.data_pedido,
    p.data_enviado
FROM public.pedido_detalhe pd
INNER JOIN public.pedidos p ON pd.id_pedido = p.id
-- Joins com as dimensões para capturar as Surrogate Keys
INNER JOIN data_warehouse.dim_tempo tp ON p.data_pedido = tp.data
INNER JOIN data_warehouse.dim_territorio tr ON p.cidade_navio = tr.cidade
INNER JOIN data_warehouse.dim_produtos pro ON pd.id_produto = pro.id_produto
INNER JOIN data_warehouse.dim_funcionario f ON p.id_funcionario = f.id_fun;

-- Nota: Usando o SELECT DISTINCT para garante que não haja duplicidade de registros
-- caso existam inconsistências nas tabelas de origem (JOINs muitos-para-muitos).
