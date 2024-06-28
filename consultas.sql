-- 1. Lista de funcionários ordenando pelo salário decrescente -- 
SELECT nome, cargo, salario
FROM VENDEDORES
ORDER BY salario DESC; 

-- 2. Lista de pedidos de vendas ordenado por data de emissão --
SELECT id_pedido, id_empresa, id_cliente, valor_total, data_emissao, situacao
FROM PEDIDO
ORDER BY data_emissao; 

-- 3. Valor de faturamento por cliente --  
SELECT c.id_cliente, c.razao_social, SUM(p.valor_total) AS faturamento_total
FROM CLIENTES c
JOIN PEDIDO p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.razao_social
ORDER BY faturamento_total DESC;

-- 4. Valor de faturamento por empresa -- 
SELECT e.id_empresa, e.razao_social, SUM(p.valor_total) AS faturamento_total
FROM EMPRESA e
JOIN PEDIDO p ON e.id_empresa = p.id_empresa
GROUP BY e.id_empresa, e.razao_social
ORDER BY faturamento_total DESC; 

-- 5. Valor de faturamento por vendedor --
SELECT v.id_vendedor, v.nome, SUM(p.valor_total) AS faturamento_total
FROM VENDEDORES v
JOIN CLIENTES c ON v.id_vendedor = c.id_vendedor
JOIN PEDIDO p ON c.id_cliente = p.id_cliente
GROUP BY v.id_vendedor, v.nome
ORDER BY faturamento_total DESC; 

-- 6. Valor de faturamento por produto --  
-- Caso não seja possivel retornar o último preço praticado, utiliza a função COALESCE 
-- para retornar o menor preço da configuração de preço de produto--
SELECT 
    p.id_produto, 
    p.descricao, 
    c.id_cliente, 
    c.razao_social AS cliente_razao_social, 
    e.id_empresa, 
    e.razao_social AS empresa_razao_social, 
    v.id_vendedor, 
    v.nome AS vendedor_nome, 
    cpp.preco_minimo, 
    cpp.preco_maximo, 
    COALESCE(
        (SELECT ip.preco_praticado
         FROM ITENS_PEDIDO ip
         JOIN PEDIDO pd ON ip.id_pedido = pd.id_pedido
         WHERE ip.id_produto = p.id_produto 
           AND pd.id_cliente = c.id_cliente
         ORDER BY pd.data_emissao DESC
         LIMIT 1),
        cpp.preco_minimo
    ) AS preco_base
FROM PRODUTOS p
JOIN CONFIG_PRECO_PRODUTO cpp ON p.id_produto = cpp.id_produto
JOIN CLIENTES c ON cpp.id_empresa = c.id_empresa
JOIN EMPRESA e ON c.id_empresa = e.id_empresa
JOIN VENDEDORES v ON c.id_vendedor = v.id_vendedor
ORDER BY p.id_produto, c.id_cliente;


 


