CREATE TABLE IF NOT EXISTS "products" (
    "id" serial PRIMARY KEY,
    "name" VARCHAR(100),
    "price" float
);

CREATE TABLE IF NOT EXISTS "infos" (
  "id" serial PRIMARY KEY ,
  "product_id" integer,
  "supplier_id" integer,
  "deposit_id" integer, 
  "validity" date,
  "purchace_price" float,
  "internal_code" varchar
);

CREATE TABLE IF NOT EXISTS "deposit" (
  "id" serial PRIMARY KEY, 
  "product_id" integer,
  "quanty" integer,
  "lote" date
);

CREATE TABLE IF NOT EXISTS "nota_fiscal" (
  "id" serial PRIMARY KEY ,
  "product_id" integer,
  "quanty" integer,
  "total" float,
  "id_employee" integer
);

CREATE TABLE IF NOT EXISTS "sales" (
  "id" serial PRIMARY KEY ,
  "nota_id" integer,
  "employees_id" integer
);

CREATE TABLE IF NOT EXISTS "supliers" (
  "id" serial PRIMARY KEY ,
  "name" varchar,
  "email" varchar,
  "address" varchar,
  "phone" varchar,
  "cnpj" varchar
);

CREATE TABLE IF NOT EXISTS "employees" (
  "id" serial PRIMARY KEY ,
  "office_id" integer,
  "name" varchar,
  "email" varchar,
  "address" varchar,
  "phone" varchar,
  "cpf" varchar
);

CREATE TABLE IF NOT EXISTS "offices" (
  "id" serial PRIMARY KEY ,
  "name" varchar,
  "salary" float
);

-- Adicionando chaves estrangeiras

ALTER TABLE "infos" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");
ALTER TABLE "infos" ADD FOREIGN KEY ("supplier_id") REFERENCES "supliers" ("id");
ALTER TABLE "nota_fiscal" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");
ALTER TABLE "nota_fiscal" ADD FOREIGN KEY ("id_employee") REFERENCES "employees" ("id");
ALTER TABLE "sales" ADD FOREIGN KEY ("nota_id") REFERENCES "nota_fiscal" ("id");
ALTER TABLE "sales" ADD FOREIGN KEY ("employees_id") REFERENCES "employees" ("id");
ALTER TABLE "deposit" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");
ALTER TABLE "deposit" ADD CONSTRAINT "comp" UNIQUE ("product_id","lote");
ALTER TABLE "employees" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id");
ALTER TABLE "infos" ADD FOREIGN KEY ("deposit_id") REFERENCES "deposit" ("id");
