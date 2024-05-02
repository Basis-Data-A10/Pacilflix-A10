from django.urls import path
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='hal_ulasan.html'), name='hal_ulasan'),

]