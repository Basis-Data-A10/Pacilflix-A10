from django.urls import path
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='langganan.html'), name='langganan'),
    path('pembayaran/', TemplateView.as_view(template_name='belipaket.html'), name='pembayaran'),
]
    