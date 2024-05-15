def is_authenticated(request):
    if request.COOKIES.get('authenticated') == "True":
        return True
    return False