import psycopg2

osm_db_connection = psycopg2.connect(database = "openstreetmap")
print(osm_db_connection)
