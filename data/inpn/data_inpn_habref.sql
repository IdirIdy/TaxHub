SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = ref_habitat, pg_catalog;


TRUNCATE TABLE habref CASCADE;
TRUNCATE TABLE typoref CASCADE;
TRUNCATE TABLE habref_typo_rel CASCADE;
TRUNCATE TABLE habref_corresp_taxon;
TRUNCATE TABLE habref_corresp_hab;

TRUNCATE TABLE bib_habref_typo_rel;

TRUNCATE TABLE bib_habref_statuts;
TRUNCATE TABLE cor_habref_terr_statut;
TRUNCATE TABLE typoref_fields CASCADE;
TRUNCATE TABLE cor_habref_description CASCADE;
TRUNCATE TABLE habref_sources CASCADE;
TRUNCATE TABLE cor_hab_source CASCADE;

COPY typoref 
FROM '/tmp/habref/TYPOREF_40.csv' 
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';

COPY habref 
FROM '/tmp/habref/HABREF_NOHTML_40.csv' 
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';

COPY habref_corresp_hab
FROM  '/tmp/habref/HABREF_CORRESP_HAB_40.csv'
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';

COPY habref_corresp_taxon 
FROM  '/tmp/habref/HABREF_CORRESP_TAXON_40.csv'
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';


COPY bib_habref_typo_rel 
FROM  '/tmp/habref/HABREF_TYPE_REL_40.csv'
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';

COPY bib_habref_statuts 
FROM  '/tmp/habref/HABREF_STATUTS_40.csv'
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';

COPY cor_habref_terr_statut 
FROM  '/tmp/habref/HABREF_TERR_40.csv'
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';

COPY typoref_fields 
FROM  '/tmp/habref/TYPOREF_FIELDS_40.csv'
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';

COPY cor_habref_description 
FROM  '/tmp/habref/HABREF_DESCRIPTION_NOHTML_40.csv'
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';

COPY habref_sources 
FROM  '/tmp/habref/HABREF_SOURCES_40.csv'
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';

COPY cor_hab_source 
FROM  '/tmp/habref/HABREF_LIEN_SOURCES_40.csv'
WITH  CSV HEADER 
DELIMITER E';'  encoding 'UTF-8';


-- INSERT INTO habref_corresp_hab
-- SELECT 
--     cd_corresp_hab,
--     cd_hab_entre ,
--     cd_hab_sortie ,
--     cd_type_relation ,
--     lb_condition ,
--     lb_remarques,
--     validite ,
--     cd_typo_entre ,
--     cd_typo_sortie ,
--     to_timestamp(date_crea, 'YYYYMMDDHH24MISS') ,
--     to_timestamp(date_modif, 'YYYYMMDDHH24MISS') ,
--     diffusion 
-- FROM import_habref_corresp_hab;

-- INSERT INTO ref_habitat.habref_corresp_taxon
-- SELECT
--     cd_corresp_tax,
--     cd_hab_entre ,
--     cd_nom,
--     cd_type_relation,
--     lb_condition,
--     lb_remarques,
--     nom_cite,
--     validite,
--     to_timestamp(date_crea, 'YYYYMMDDHH24MISS') ,
--     to_timestamp(date_modif, 'YYYYMMDDHH24MISS')
--   FROM ref_habitat.import_habref_corresp_taxon;

-- INSERT INTO habref_typo_rel
-- SELECT
--     cd_type_rel,
--     lb_type_rel,
--     lb_rel,
--     corresp_hab ,
--     corresp_esp ,
--     corresp_syn,
--     to_timestamp(date_crea, 'YYYYMMDDHH24MISS') ,
--     to_timestamp(date_modif, 'YYYYMMDDHH24MISS')
--   FROM  import_habref_typo_rel;