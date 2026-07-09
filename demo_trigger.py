import os

import psycopg2

DB_URL = (
    "dbname=megabase0 "
    "user=postgres "
    "password=Mkilo1990 "
    "host=localhost "
    "port=5432"
)
conn = psycopg2.connect(os.environ.get("DATABASE_URL", DB_URL))
conn.autocommit = True
cur = conn.cursor()

cur.execute("DROP SCHEMA IF EXISTS demo_trigger CASCADE")
cur.execute("CREATE SCHEMA demo_trigger")

cur.execute("""
    CREATE TABLE demo_trigger.emp (
    nom_employe          text,
    salaire              integer,
    date_dermodif        timestamp,
    utilisateur_dermodif text
    );

    CREATE OR REPLACE FUNCTION toto_stamp() RETURNS trigger AS $toto_stamp$
    BEGIN
        -- Verifie que nom_employe et salary sont donnés
        IF NEW.nom_employe IS NULL THEN
            RAISE EXCEPTION 'nom_employe ne peut pas être NULL';
        END IF;
        IF NEW.salaire IS NULL THEN
            RAISE EXCEPTION '% ne peut pas avoir un salaire', NEW.nom_employe;
        END IF;

        -- Qui travaille pour nous si la personne doit payer pour cela ?
        IF NEW.salaire < 0 THEN
            RAISE EXCEPTION '% ne peut pas avoir un salaire négatif', NEW.nom_employe;
        END IF;

        -- Rappelons-nous qui a changé le salaire et quand
        NEW.date_dermodif := current_timestamp;
        NEW.utilisateur_dermodif := current_user;
        RETURN NEW;
    END;
    $toto_stamp$ LANGUAGE plpgsql;

    CREATE OR REPLACE TRIGGER toto_stamp BEFORE INSERT OR UPDATE ON demo_trigger.emp
    FOR EACH ROW EXECUTE FUNCTION toto_stamp();  
            
""")

cur.execute("""
    INSERT INTO demo_trigger.emp (nom_employe, salaire) VALUES
    ('John Doe', 50000);
""")

cur.execute(""" 
SELECT * from demo_trigger.emp;
""")
print(cur.fetchall())