# 📊 Projeto: Otimização de Margem e Performance de Vendas

Este projeto consiste na implementação de uma infraestrutura de dados analítica (**Data Warehouse**) focada em medir a saúde financeira e a eficiência comercial da Northwind. 
A solução transforma dados transacionais brutos em um modelo **Star Schema**, otimizado para análises de lucratividade e performance de vendas.


## 🎯 Objetivo do Projeto
O propósito foi migrar dados de um sistema operacional (OLTP) para um ambiente analítico (OLAP), permitindo que a empresa identifique:
* **Margem Real:** O faturamento líquido exato após a aplicação de descontos.
* **Desempenho Geográfico:** Performance de vendas por território e cidade.
* **Produtividade:** Ranking de funcionários por volume financeiro gerado.
* **Sazonalidade:** Tendências de vendas através de uma dimensão de tempo dedicada.

## 🏗️ Arquitetura do Data Warehouse
A modelagem seguiu a metodologia **Star Schema** (Modelo Estrela), garantindo simplicidade para o usuário final e alta performance em consultas analíticas.

### 1. Tabela Fato (`fato_venda`)
A peça central que armazena as métricas quantitativas e chaves estrangeiras.
* **Cálculo de Valor Líquido:** Implementação da lógica `(Preço * Quantidade) - Desconto` diretamente no processo de carga.
* **Granularidade:** Nível de item de pedido para permitir drill-down detalhado/e uma análise exploratórica dos dados.

### 2. Dimensões (O Contexto)
* **`dim_produtos`**: Consolida informações de categorias e fornecedores.
* **`dim_funcionario`**: Atributos dos vendedores responsáveis pelas vendas.
* **`dim_territorio`**: Estrutura geográfica baseada nos dados de envio.
* **`dim_tempo`**: Dimensão inteligente gerada via SQL para análises temporais completas (Trimestre, Mês, Dia da Semana).


## 🛠️ Destaques Técnicos e Engenharia
* **Precisão Financeira:** Uso do tipo `NUMERIC(18,2)` para garantir cálculos exatos, evitando os erros de precisão comuns do tipo `FLOAT`.
* **Transformação via SQL (ETL):** Todo o processo de limpeza e carga foi realizado com comandos `INSERT INTO ... SELECT` e `INNER JOINs`, transformando chaves naturais em chaves substitutas (surrogate keys).
* **Integridade de Dados:** Configuração de restrições de chave (PK/FK) para assegurar a consistência dos dados analíticos.

## 🚀 Tecnologias Utilizadas
* **PostgreSQL:** SGBD para hospedagem do Data Warehouse.
* **SQL:** DDL e DML para estruturação e transformação dos dados.
* **Modelagem Dimensional:** Padrões de projeto Star Schema.

## 📂 Estrutura de Arquivos
* `sql/01_schema_setup.sql`: Criação das tabelas e schemas.
* `sql/02_populate_dims.sql`: Scripts de carga das dimensões.
* `sql/03_load_fact.sql`: Lógica de transformação e carga da tabela fato.

---

