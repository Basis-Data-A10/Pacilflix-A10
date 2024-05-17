from django.shortcuts import render

# Create your views here.

def trailer(request):
    return render(request, 'hal_trailer.html')

def trailer_guest(request):
    return render(request, 'hal_trailer_guest.html')