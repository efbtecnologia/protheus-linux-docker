-- /mnt/Acer_HD/docker/totvs/postgres_init_scripts/init-protheus-db.sql
-- Verifica se o banco de dados 'protheus_dev' já existe antes de tentar criá-lo
DO
$$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'protheus_dev') THEN
        -- Cria o banco de dados 'protheus_dev' com TODAS as especificações CORRETAS do Protheus
        -- OWNER 'protheus' será criado automaticamente pelo POSTGRES_USER do Docker Compose
        EXECUTE 'CREATE DATABASE protheus_dev
                 WITH
                 OWNER = protheus
                 ENCODING = ''WIN1252''
                 LC_COLLATE = ''C''
                 LC_CTYPE = ''C''
                 TABLESPACE = pg_default
                 CONNECTION LIMIT = -1
                 IS_TEMPLATE = False;';
        RAISE NOTICE 'Banco de dados protheus_dev criado com sucesso.';
    ELSE
        RAISE NOTICE 'Banco de dados protheus_dev já existe. Pulando criação.';
    END IF;
END
$$;
