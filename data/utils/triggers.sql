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