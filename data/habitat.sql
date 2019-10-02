SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS ref_habitat;

SET search_path = ref_habitat, pg_catalog, public;

SET default_with_oids = false;

----------
--TABLES--
----------
-- init référentiel HABREF 4.0, table TYPOREF
CREATE TABLE typoref (
    cd_typo serial NOT NULL,
    cd_table character varying(255),
    lb_nom_typo character varying(100),
    nom_jeu_donnees character varying(255),
    date_creation character varying(255),
    date_mise_jour_table character varying(255),
    date_mise_jour_metadonnees character varying(255),
    auteur_typo character varying(4000),
    auteur_table character varying(4000),
    territoire character varying(4000),
    organisme character varying(255),
    langue character varying(255),
    presentation character varying(4000),
    description character varying(4000),
    origine character varying(4000),
    ref_biblio character varying(4000),
    mots_cles character varying(255),
    referencement character varying(4000),
    diffusion character varying(4000), -- pas de doc
    derniere_modif character varying(4000),
    type_table character varying(6),
    cd_typo_entre integer,
    cd_typo_sortie integer,
    niveau_inpn character varying(255) -- pas de doc
);
COMMENT ON TABLE ref_habitat.typoref IS 'typoref, table TYPOREF du référentiel HABREF 4.0';

-- init référentiel HABREF 4.0, table HABREF
CREATE TABLE habref (
    cd_hab integer NOT NULL,
    fg_validite character varying(20) NOT NULL,
    cd_typo integer NOT NULL,
    lb_code character varying(50),
    lb_hab_fr character varying(500),
    lb_hab_fr_complet character varying(500),
    lb_hab_en character varying(500),
    lb_auteur character varying(500),
    niveau integer,
    lb_niveau character varying(100),
    cd_hab_sup integer,
    path_cd_hab character varying(2000),
    france character varying(5),
    lb_description character varying(4000)
);
COMMENT ON TABLE ref_habitat.habref IS 'habref, table HABREF référentiel HABREF 4.0 INPN';


CREATE TABLE import_habref_corresp_hab(
    cd_corresp_hab integer NOT NULL,
    cd_hab_entre integer NOT NULL,
    cd_hab_sortie integer,
    cd_type_relation integer,
    lb_condition character varying(1000),
    lb_remarques character varying(4000),
    validite boolean,
    cd_typo_entre integer,
    cd_typo_sortie integer,
    date_crea text,
    date_modif text,
    diffusion boolean
);
COMMENT ON TABLE ref_habitat.habref_corresp_hab IS 'Table de corespondances entres les habitats de differentes typologie';

CREATE TABLE habref_corresp_hab(
    cd_corresp_hab integer NOT NULL,
    cd_hab_entre integer NOT NULL,
    cd_hab_sortie integer,
    cd_type_relation integer,
    lb_condition character varying(1000),
    lb_remarques character varying(4000),
    validite boolean,
    cd_typo_entre integer,
    cd_typo_sortie integer,
    date_crea timestamp without time zone,
    date_modif timestamp without time zone,
    diffusion boolean

);
COMMENT ON TABLE ref_habitat.habref_corresp_hab IS 'Table de corespondances entres les habitats de differentes typologie';

CREATE TABLE import_habref_corresp_taxon(
    cd_corresp_tax integer NOT NULL,
    cd_hab_entre integer NOT NULL,
    cd_nom integer,
    cd_type_relation integer,
    lb_condition character varying(1000),
    lb_remarques character varying(4000),
    nom_cite character varying(500),
    validite boolean,
    date_crea text,
    date_modif text
);
COMMENT ON TABLE ref_habitat.habref_corresp_taxon IS 'Table de corespondances entres les habitats les taxon (table taxref)';

CREATE TABLE habref_corresp_taxon(
    cd_corresp_tax integer NOT NULL,
    cd_hab_entre integer NOT NULL,
    cd_nom integer,
    cd_type_relation integer,
    lb_condition character varying(1000),
    lb_remarques character varying(4000),
    nom_cite character varying(500),
    validite boolean,
    date_crea timestamp without time zone,
    date_modif timestamp without time zone
);
COMMENT ON TABLE ref_habitat.habref_corresp_taxon IS 'Table de corespondances entres les habitats les taxon (table taxref)';

CREATE TABLE habref_typo_rel(
    cd_type_rel integer,
    lb_type_rel character varying(50),
    lb_rel character varying(100),
    corresp_hab boolean,
    corresp_esp boolean,
    date_crea timestamp without time zone,
    date_modif timestamp without time zone
);
COMMENT ON TABLE ref_habitat.habref_typo_rel IS 'Bibliothèque des type de relations entre habitats';


CREATE TABLE bib_list_habitat (
    id_list serial NOT NULL,
    list_name character varying(255) NOT NULL
);
COMMENT ON TABLE ref_habitat.bib_list_habitat IS 'Table des listes des habitats';

CREATE TABLE cor_list_habitat (
    id_cor_list serial NOT NULL,
    id_list integer NOT NULL,
    cd_hab integer NOT NULL
);
COMMENT ON TABLE ref_habitat.cor_list_habitat IS 'Habitat de chaque liste';


---------------
--PRIMARY KEY--
---------------

ALTER TABLE ONLY typoref
    ADD CONSTRAINT pk_typoref PRIMARY KEY (cd_typo);

ALTER TABLE ONLY habref 
    ADD CONSTRAINT pk_habref PRIMARY KEY (cd_hab);

ALTER TABLE ONLY habref_corresp_taxon 
    ADD CONSTRAINT pk_habref_corresp_taxon PRIMARY KEY (cd_corresp_tax);

ALTER TABLE ONLY habref_typo_rel 
    ADD CONSTRAINT pk_habref_typo_rel PRIMARY KEY (cd_type_rel);

ALTER TABLE ONLY habref_corresp_hab 
    ADD CONSTRAINT pk_habref_corresp_hab PRIMARY KEY (cd_corresp_hab);

ALTER TABLE ONLY bib_list_habitat 
    ADD CONSTRAINT pk_bib_list_habitat PRIMARY KEY (id_list);

ALTER TABLE ONLY cor_list_habitat 
    ADD CONSTRAINT pk_cor_list_habitat PRIMARY KEY (id_cor_list);
---------------
--FOREIGN KEY--
---------------

ALTER TABLE ONLY habref 
    ADD CONSTRAINT fk_typoref FOREIGN KEY (cd_typo) REFERENCES ref_habitat.typoref (cd_typo) ON UPDATE CASCADE;


ALTER TABLE ONLY cor_list_habitat
    ADD CONSTRAINT fk_cor_list_habitat_cd_hab FOREIGN KEY (cd_hab) REFERENCES ref_habitat.habref (cd_hab) ON UPDATE CASCADE;


ALTER TABLE ONLY habref 
    ADD CONSTRAINT fk_typoref FOREIGN KEY (cd_typo) REFERENCES ref_habitat.typoref (cd_typo) ON UPDATE CASCADE;


ALTER TABLE ONLY habref_corresp_hab
    ADD CONSTRAINT fk_habref_corresp_hab_cd_type_rel FOREIGN KEY (cd_type_relation) REFERENCES ref_habitat.habref_typo_rel (cd_type_rel) ON UPDATE CASCADE;

ALTER TABLE ONLY habref_corresp_hab
    ADD CONSTRAINT fk_habref_corresp_hab_cd_hab_entre FOREIGN KEY (cd_hab_entre) REFERENCES ref_habitat.habref (cd_hab) ON UPDATE CASCADE;

ALTER TABLE ONLY habref_corresp_hab
    ADD CONSTRAINT fk_habref_corresp_hab_cd_hab_sortie FOREIGN KEY (cd_hab_sortie) REFERENCES ref_habitat.habref (cd_hab) ON UPDATE CASCADE;

ALTER TABLE ONLY habref_corresp_taxon
    ADD CONSTRAINT fk_habref_corresp_tax_cd_typ_rel FOREIGN KEY (cd_type_relation) REFERENCES ref_habitat.habref_typo_rel (cd_type_rel) ON UPDATE CASCADE;

ALTER TABLE ONLY habref_corresp_taxon
    ADD CONSTRAINT fk_habref_corresp_tax_cd_hab_entre FOREIGN KEY (cd_hab_entre) REFERENCES ref_habitat.habref (cd_hab) ON UPDATE CASCADE;

ALTER TABLE ONLY habref_corresp_taxon
    ADD CONSTRAINT fk_habref_corresp_tax_cd_nom FOREIGN KEY (cd_nom) REFERENCES taxonomie.taxref (cd_nom) ON UPDATE CASCADE;
----------
--UNIQUE--
----------

ALTER TABLE ONLY cor_list_habitat
    ADD CONSTRAINT unique_cor_list_habitat UNIQUE ( id_list, cd_hab );