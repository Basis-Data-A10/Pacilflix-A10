import psycopg2, os
from psycopg2 import Error

try:
    connection = psycopg2.connect(user=os.getenv('DATABASE_USER'),
                                  password=os.getenv('DATABASE_PASSWORD'),
                                  host=os.getenv('DATABASE_HOST'),
                                  port=os.getenv('DATABASE_PORT'),
                                  database=os.getenv('DATABASE_NAME'))

    cursor = connection.cursor()
    print("PostgreSQL server information")
    print(connection.get_dsn_parameters(), "\n")
    cursor.execute("SELECT version();")

    record = cursor.fetchall()
    print("You are connected to - ", record, "\n")

    cursor.execute("SET search_path TO A10")
  
except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL", error)

# Tutup connection
# finally:
#     if 'cursor' in locals():
#         cursor.close()
#     if 'connection' in locals():
#         connection.close()
#         print("PostgreSQL connection is closed")