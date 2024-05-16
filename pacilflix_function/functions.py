from django.contrib import messages
from django.db import connection
from django.shortcuts import redirect

def query_register(username, password, negara_asal, request):
  cursor = connection.cursor()
  try:
    cursor.execute("INSERT INTO PENGGUNA VALUES (%s, %s, %s)", [username, password, negara_asal])
    messages.success(request, 'Register success!')
  except:
    messages.error(request, 'Register failed! Please use another username.')
 
def query_login(username, password, request):
  cursor = connection.cursor()
  cursor.execute("SELECT username, password FROM PENGGUNA WHERE username = %s AND password = %s", [username, password])
  user = cursor.fetchone()
  if user is not None:
    request.session['username'] = username
    response = redirect('authentication: show_landing')
    response.set_cookie('username', username)
    return response
  else:
    print("Username atau password tidak ditemukan")
  
