import psycopg2

osm_db_connection = psycopg2.connect(dbname = "openstreetmap", user="hall")
osm_db_connection_cursor = osm_db_connection.cursor()
# osm_db_connection_cursor.execute("set search_path to wikidata_entities;")
osm_db_connection_cursor.execute(
	"CREATE TABLE wikidata_entities.entity_proj_aspect_page_views(\
		project    VARCHAR(255),\
		aspect     VARCHAR(255),\
		entity_id  VARCHAR(255),\
		page_id    BIGINT,\
		page_views BIGINT);")

osm_db_connection.commit()
osm_db_connection.close()