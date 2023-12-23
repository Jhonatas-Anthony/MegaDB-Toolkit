# MegaDB-Toolkit

## Descrição

O MegaDB-Toolkit é um projeto escolar que tem como objetivo implementar todos os recursos abordados na matéria de Programação em Banco de Dados. Através deste projeto, são explorados diversos conceitos importantes no contexto de bancos de dados relacionais, tais como:

1. Joins
2. Subqueries
3. Functions
4. Triggers
5. Views
6. Cursores
7. Transactions
8. Backup

## Primeiro acesso

Caso já possua o pgAdmin instalado localmente pode pular parte do processo a seguir.

Estaremos usando o **Docker** para rodar o pgadmin localmente, siga o processo abaixo para configurar o ambiente de desenvolvimento.

1. No diretório raiz do projeto, execute os seguintes comandos:

    ```bash
    chmod 777 pg
    ```

    E em seguida

    ```bash
    ./pg run
    ```

2. No navegador, vá até a rota [http://localhost:5050]
3. Faça login utilizando as seguintes credenciais:
   * email: `admin@admin.com`
   * senha: `root`
  
4. Após isso vá em Object>Register>Server
5. Insira os dados:
    * Host/Name:            pg_container
    * Port:                 5432
    * Maintenance database: postgres
    * Username:             root
    * Password:             root

Para criar as tabelas, execute o seguinte comando:

```bash
./pg pop
```

Para restaurar as tabelas ao estado original, execute o seguinte comando:

```bash
./pg reset
```

Para popular as tabelas com as funcionalidades criadas, utilize o seguinte comando:

```bash
./pg utils
```

Essas etapas permitirão que você tenha o ambiente de desenvolvimento pronto para explorar as funcionalidades implementadas no projeto.
