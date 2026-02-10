## 📊 Business Intelligence: Overview Executivo
Esta página do dashboard foi projetada para oferecer uma visão clara da saúde financeira da Northwind, permitindo o monitoramento de margens e o desempenho comercial através de quatro perspectivas principais:

### 1. Indicadores Estratégicos (KPIs)
Localizados no topo do painel para leitura imediata:

Faturamento Líquido: Representa a receita real que entrou no caixa.

Faturamento Bruto: Calculado via SUMX para garantir a precisão linha a linha ($Preço \times Quantidade$).

Total de Pedidos: Volume único de vendas, utilizando contagem distinta para garantir a integridade do dado.

% de Desconto Médio: Métrica ponderada que demonstra o impacto das políticas comerciais sobre a receita potencial.

### 2. Análise de Sazonalidade
Gráfico de Linhas: Evolução do Faturamento Líquido por Mês/Ano, utilizando a dim_tempo para identificar picos de demanda e comportamentos cíclicos do mercado ao longo do tempo.

### 3. Comparativo de Margem e Erosão de Preço
Gráfico de Barras Clustered: Confronto direto entre Faturamento Líquido vs. Bruto por Categoria.

Insight Técnico: Este visual evidencia quais linhas de produtos sofrem maior "erosão" de preço devido a descontos agressivos, auxiliando na revisão de estratégias de precificação.

### 4. Distribuição Geográfica
Treemap: Visão proporcional das vendas por País (baseado na dim_territorio), permitindo identificar rapidamente as regiões com maior relevância financeira no faturamento global da companhia.
