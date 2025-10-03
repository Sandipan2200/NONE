from django.contrib.auth import get_user_model
from rest_framework import generics, permissions
from rest_framework.response import Response
from .models import UserProfile
from .serializers import UserRegistrationSerializer, UserProfileSerializer

User = get_user_model()

class UserRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (permissions.AllowAny,)
    serializer_class = UserRegistrationSerializer

class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = UserProfileSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_object(self):
        return UserProfile.objects.get(user=self.request.user)

class UserProfileCreateView(generics.CreateAPIView):
    serializer_class = UserProfileSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
