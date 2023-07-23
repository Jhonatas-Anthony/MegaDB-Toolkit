CREATE OR REPLACE FUNCTION realizar_venda(
  produto_id INT,
  quantidade_comprada INT,
  funcionario_id INT,
  lote_product DATE
) RETURNS VOID AS $$
DECLARE
  produto_preco float;
  produto_quantidade_deposito integer;
  total_venda float;
BEGIN
  -- Verificar a quantidade disponível no depósito
  SELECT quanty INTO produto_quantidade_deposito
  FROM deposit
  WHERE product_id = produto_id;
  
  IF quantidade_comprada <= produto_quantidade_deposito THEN
    -- Buscar o preço do produto
    SELECT price INTO produto_preco
    FROM products
    WHERE id = produto_id;
    
    -- Calcular o total da venda
    total_venda := produto_preco * quantidade_comprada;
    
    -- Inserir a venda na tabela de vendas
    INSERT INTO nota_fiscal (product_id, quanty, total)
    VALUES (produto_id, quantidade_comprada, total_venda);
    
    -- Atualizar a quantidade no depósito
    UPDATE deposit
    SET quanty = quanty - quantidade_comprada
    WHERE product_id = produto_id AND lote = lote_product;
    
    -- Inserir na tabela de nota fiscal
    INSERT INTO sales (nota_id, employees_id)
    VALUES (currval('nota_fiscal_id_seq'), funcionario_id);
  ELSE
    -- Se a quantidade comprada for maior que a quantidade em estoque, lançar uma exceção
    RAISE EXCEPTION 'Quantidade insuficiente em estoque.';
  END IF;
END;
$$ LANGUAGE plpgsql;

/* ############################################################################################## */
/* ############################################################################################## */
/* ############################################################################################## */

CREATE OR REPLACE FUNCTION realizar_pedido(
  nome_produto VARCHAR,
  sup_id INT,
  lote_produto DATE,
  preco_compra FLOAT,
  quantidade INT,
  data_validade DATE
) RETURNS VOID AS $$
DECLARE
  produto_id INTEGER;
  deposito_id INTEGER;
  produto_price FLOAT;
BEGIN
  -- Verificar se o produto já existe na tabela products
  SELECT id, price INTO produto_id, produto_price
  FROM products
  WHERE name = nome_produto;
  
  IF produto_id IS NULL THEN
    -- Se o produto não existe, criar um novo produto com o nome e preço calculado
    INSERT INTO products (name, price)
    VALUES (nome_produto, preco_compra * 2.5)
    RETURNING id INTO produto_id;
  END IF;

  -- Verificar se o produto e o lote já existem na tabela deposit
  IF NOT EXISTS (SELECT 1 FROM deposit WHERE product_id = produto_id AND lote = lote_produto) THEN
    
    -- Se não existir, criar um novo registro no deposito
    INSERT INTO deposit (product_id, quanty, lote)
    VALUES (produto_id, quantidade, lote_produto)
    RETURNING id INTO deposito_id;
  ELSE
    -- Se existir, adicionar a quantidade comprada à quantidade do deposito
    IF preco_compra >= produto_price THEN
      RAISE EXCEPTION 'O preco_compra nao pode ser maior que o price na tabela products.';
    END IF;
    
    UPDATE deposit
    SET quanty = quanty + quantidade
    WHERE product_id = produto_id AND lote = lote_produto
    RETURNING id INTO deposito_id;
  END IF;
  
  -- Verificar se o produto, fornecedor e depósito existem na tabela infos
  IF NOT EXISTS (
    SELECT 1 FROM infos
    WHERE product_id = produto_id AND supplier_id = sup_id AND deposit_id = deposito_id
  ) THEN
    -- Se não existir, criar um novo registro na tabela infos
    INSERT INTO infos (product_id, supplier_id, deposit_id, validity, purchace_price, internal_code)
    VALUES (produto_id, sup_id, deposito_id, data_validade, preco_compra, LPAD((RANDOM() * 999000 + 1000)::INT::TEXT, 6, '0'));
  END IF;
END;
$$ LANGUAGE plpgsql;

/* ############################################################################################## */

CREATE OR REPLACE FUNCTION obter_notas_fiscais()
RETURNS TABLE (
  nota_fiscal_id integer,
  total float,
  nome_produto varchar,
  quantidade integer
) AS $$
BEGIN
  RETURN QUERY
  SELECT nf.id AS nota_fiscal_id, nf.total, p.name AS nome_produto, nf.quanty AS quantidade
  FROM nota_fiscal nf
  JOIN products p ON nf.product_id = p.id;
END;
$$ LANGUAGE PLPGSQL;

/* ############################################################################################## */

CREATE OR REPLACE FUNCTION calcular_total_vendas_funcionario(
    funcionario_id integer
)
RETURNS float AS $$
DECLARE
    total_vendas float;
BEGIN
    SELECT SUM(nf.total) INTO total_vendas
    FROM nota_fiscal nf
    WHERE nf.id IN (
        SELECT nota_id
        FROM sales
        WHERE employees_id = funcionario_id
    );

    RETURN COALESCE(total_vendas, 0.0); -- Retorna o total de vendas ou 0.0 se não houver vendas
END;
$$ LANGUAGE PLPGSQL;
