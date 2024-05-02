from django.shortcuts import render


def review_list(request):
    # Generate range of numbers from 0 to 4
    review_count = range(5)
    return render(request, 'hal_ulasan.html', {'review_count': review_count})
