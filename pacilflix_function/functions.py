from django.contrib import messages
from django.db import InternalError, connection
from django.http import HttpResponseRedirect
from django.shortcuts import redirect, render
from django.urls import reverse
from authentication.views import *

def query_register(username, password, negara_asal, request):
  cursor = connection.cursor()
  context = {}

  try:
    cursor.execute("INSERT INTO PENGGUNA VALUES (%s, %s, %s)", [username, password, negara_asal])
    # messages.success(request, f'Register success! Hello, {username}!')
    print(f'Register account {username} from {negara_asal} succeeded!')
    # response = HttpResponseRedirect(reverse("authentication:login"))    
    # return response
    return redirect('authentication:login')  
  except InternalError as e:
    print(e)
    messages.error(request, 'Register failed! Please use another username.')
 
def query_login(username, password, request):
  cursor = connection.cursor()
  cursor.execute("SELECT username, password FROM PENGGUNA WHERE username = %s AND password = %s", [username, password])
  user = cursor.fetchone()

  if user is not None:
    # request.session['username'] = username
    # messages.success(request, f'Login success! Welcome to PacilFlix, {username}!')
    print(f'Login to {username} succeeded!')
    # response = HttpResponseRedirect(reverse("authentication:show_landing"))  # NANTI JADI TAYANGAN!!!
    response = redirect('authentication:show_landing')
    response.set_cookie('username', username)
    response.set_cookie('password', password)
    response.set_cookie('authenticated', 'True')
    return response
  else:
    print('Login failed! Please try again.')
    messages.error(request, 'Login failed! Please try again.')

def query_logout(request):
  response = HttpResponseRedirect(reverse("authentication:show_landing"))
  response.delete_cookie('username')
  response.delete_cookie('password')
  response.delete_cookie('authenticated')
  return response