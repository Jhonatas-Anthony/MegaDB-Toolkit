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

/* #################################################################################### */

CREATE OR REPLACE VIEW view_produto_info AS
SELECT
  p.name AS produto_nome,
  COALESCE(i.internal_code, p.id::varchar) AS produto_codigo,
  p.price AS produto_preco,
  i.purchace_price AS preco_compra,
  d.lote,
  i.validity
FROM products p
LEFT JOIN infos i ON p.id = i.product_id
LEFT JOIN deposit d ON p.id = d.product_id AND i.deposit_id = d.id;

/* #################################################################################### */

CREATE OR REPLACE VIEW employee_info_view AS
SELECT 
e.id AS employee_id, 
e.name AS employee_name, 
o.name AS office_name, 
o.salary AS salary
FROM employees e
INNER JOIN offices o ON e.office_id = o.id;
