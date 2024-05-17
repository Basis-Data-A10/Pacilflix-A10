from django.contrib import messages
from django.db import InternalError, connection
from django.shortcuts import redirect

def query_register(username, password, negara_asal, request):
  cursor = connection.cursor()

  try:
    cursor.execute("INSERT INTO PENGGUNA VALUES (%s, %s, %s)", [username, password, negara_asal])
    messages.success(request, f'Register success! Hello, {username}!')
    print(f'Register to {username} from {negara_asal} succeeded!')

  except InternalError as e:
    print(e)
    messages.error(request, 'Register failed! Please use another username.')
 
def query_login(username, password, request):
  cursor = connection.cursor()
  cursor.execute("SELECT username, password FROM PENGGUNA WHERE username = %s AND password = %s", [username, password])
  user = cursor.fetchone()

  if user is not None:
    request.session['username'] = username
    messages.success(request, f'Login success! Welcome to PacilFlix, {username}!')
    print(f'Login to {username} succeeded!')
    
  else:
    print('Login failed! Please try again.')
    messages.error(request, 'Login failed! Please try again.')