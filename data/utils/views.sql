CREATE OR REPLACE VIEW produto_view AS
SELECT
    p.name AS nome_produto,
    i.validity,
    i.internal_code,
    d.lote,
    p.price
FROM
    products p
LEFT JOIN
    infos i ON p.id = i.product_id
LEFT JOIN
    deposit d ON p.id = d.product_id
UNION
SELECT
    'Produto não encontrado' AS nome_produto,
    i.validity,
    i.internal_code,
    d.lote,
    NULL AS price
FROM
    infos i
LEFT JOIN
    deposit d ON i.product_id = d.product_id
WHERE
    NOT EXISTS (SELECT 1 FROM products WHERE id = i.product_id);
