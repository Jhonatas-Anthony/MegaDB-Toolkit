CREATE OR REPLACE FUNCTION realizar_venda(
  produto_id INT,
  quantidade_comprada INT,
  funcionario_id INT
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
    WHERE product_id = produto_id;
    
    -- Inserir na tabela de nota fiscal
    INSERT INTO sales (nota_id, employees_id)
    VALUES (currval('nota_fiscal_id_seq'), funcionario_id);
  ELSE
    -- Se a quantidade comprada for maior que a quantidade em estoque, lançar uma exceção
    RAISE EXCEPTION 'Quantidade insuficiente em estoque.';
  END IF;
END;
$$ LANGUAGE plpgsql;
