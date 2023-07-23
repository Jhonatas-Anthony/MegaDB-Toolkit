CREATE OR REPLACE FUNCTION verificar_preco_compra()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.purchace_price > (
    SELECT price FROM products WHERE id = NEW.product_id
  ) THEN
    RAISE EXCEPTION 'Preço de compra maior que o preço do produto.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verificar_preco_compra
BEFORE INSERT ON infos
FOR EACH ROW
EXECUTE FUNCTION verificar_preco_compra();

/* #################################################################################### */

CREATE OR REPLACE FUNCTION verificar_tipo_funcionario()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT office_id FROM employees WHERE id = NEW.id_employee) NOT IN (1, 6) THEN
    RAISE EXCEPTION 'Apenas um funcionário do tipo operador de caixa ou balconista pode realizar vendas';
  END IF;
  RETURN NEW; -- Retornar NEW apenas se a verificação passar
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER verificar_funcionario
BEFORE INSERT ON nota_fiscal
FOR EACH ROW
EXECUTE FUNCTION verificar_tipo_funcionario();