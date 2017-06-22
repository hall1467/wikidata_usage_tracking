import psycopg2

osm_db_connection = psycopg2.connect(dbname = "openstreetmap", user="hall")
osm_db_connection_cursor = osm_db_connection.cursor()
# geometry_columns_results =\
# 	osm_db_connection_cursor.execute("select * from public.geometry_columns;")
geometry_columns_results =\
	osm_db_connection_cursor.execute("CREATE TABLE TEST();")

# for line in osm_db_connection_cursor.fetchall():
# 	print(line)

osm_db_connection.commit()
osm_db_connection.close()
print(osm_db_connection)
