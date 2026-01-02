-- 1️ Create the database safely
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_database WHERE datname = 'DataWarehouse'
   ) THEN
      EXECUTE 'CREATE DATABASE datawarehouse';
   END IF;
END


-- 2 Create schemas safely inside the database
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

