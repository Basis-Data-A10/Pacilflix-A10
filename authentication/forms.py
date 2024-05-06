from django.forms import ModelForm
from authentication.models import Auth

class AuthForm(ModelForm):
    class Meta:
        model = Auth
        fields = ["username", "password", "negara_asal"]