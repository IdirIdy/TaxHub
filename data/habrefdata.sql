SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = ref_habitat, pg_catalog;

TRUNCATE TABLE import_habref_corresp_hab;
-- TODO
COPY import_taxref (cd_corresp_hab)
FROM  '/tmp/taxhub/TAXREFv11.txt'
WITH  CSV HEADER 
DELIMITER E'\t'  encoding 'UTF-8';