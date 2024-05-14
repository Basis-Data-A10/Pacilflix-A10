from django.db import connection

def execute_query(query):
  with connection.cursor() as cursor:
    cursor.execute(query)
    if query.lower().startswith('select'):
      result = cursor.fetchall()
      return result
  connection.close()