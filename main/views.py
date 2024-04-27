from django.shortcuts import render

def show_main(request):
    context = {
        'name': 'A10',
        'class': 'BASIS DATA A', 
    }

    return render(request, "main.html", context)