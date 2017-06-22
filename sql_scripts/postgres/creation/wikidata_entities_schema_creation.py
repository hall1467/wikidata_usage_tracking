import psycopg2

osm_db_connection = psycopg2.connect(dbname = "openstreetmap", user="hall")
osm_db_connection_cursor = osm_db_connection.cursor()
osm_db_connection_cursor.execute("CREATE SCHEMA wikidata_entities;")
osm_db_connection.commit()
osm_db_connection.close()