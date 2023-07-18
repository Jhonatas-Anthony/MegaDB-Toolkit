# MegaDB-Toolkit

## Descrição 

Projeto escolar com a finalidade de implementar todos recursos vistos na matéria de Programação em Banco de Dados: 

1. Joins 
2. Subqueries 
3. Functions 
4. Triggers
5. Views
6. Cursores
7. Transactions 
8. Backup

## Primeiro acesso: 

Caso já possua o pgAdmin instalado localmente pode pular parte do processo a seguir. 

Estaremos usando o docker para rodar o pgadmin localmente, para iniciar o pgAdmin faça:

1. No diretório raiz: 
```bash
chmod 777 pg
# Depois: 
./pg run
```
2. No navegador, vá até a rota http://localhost:5050
3. Para acessar, basta inserir o email: admin@admin.com e a senha: root
4. Após isso vá em Object>Register>Server 
5. Insira os dados: 
    - Host/Name:            pg_container
    - Port:                 5432
    - Maintenance database: postgres
    - Username:             root
    - Password:             root

Para criar as tabelas dê: 
```bash
./pg pop
```
Para recriar as tabelas dê: 
```bash
./pg reset
```
Para popular as tabelas com as funcionalidades criadas: 
```bash
./pg utils
```
