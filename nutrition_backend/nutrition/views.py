from rest_framework import generics, filters, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q
from .models import Disease, FoodItem, DietPlanTemplate, WeeklyDietPlan
from .serializers import (
    DiseaseSerializer, FoodItemSerializer,
    DietPlanTemplateSerializer, WeeklyDietPlanSerializer
)

class DiseaseListView(generics.ListAPIView):
    queryset = Disease.objects.all()
    serializer_class = DiseaseSerializer
    permission_classes = [IsAuthenticated]

class DiseaseDetailView(generics.RetrieveAPIView):
    queryset = Disease.objects.all()
    serializer_class = DiseaseSerializer
    permission_classes = [IsAuthenticated]

class FoodItemListView(generics.ListAPIView):
    queryset = FoodItem.objects.filter(is_active=True)
    serializer_class = FoodItemSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [filters.SearchFilter]
    search_fields = ['name', 'category__name', 'dietary_tags']

class FoodItemDetailView(generics.RetrieveAPIView):
    queryset = FoodItem.objects.filter(is_active=True)
    serializer_class = FoodItemSerializer
    permission_classes = [IsAuthenticated]

class FoodSearchView(generics.ListAPIView):
    serializer_class = FoodItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = FoodItem.objects.filter(is_active=True)
        state = self.request.query_params.get('state', None)
        budget = self.request.query_params.get('budget', None)
        diet = self.request.query_params.get('diet', None)

        if state:
            queryset = queryset.filter(available_states__icontains=state)
        if budget:
            queryset = queryset.filter(budget_tier=budget)
        if diet:
            queryset = queryset.filter(dietary_tags__icontains=diet)

        return queryset

class DietPlanListView(generics.ListCreateAPIView):
    serializer_class = DietPlanTemplateSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return DietPlanTemplate.objects.filter(is_active=True)

class DietPlanDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = DietPlanTemplate.objects.all()
    serializer_class = DietPlanTemplateSerializer
    permission_classes = [IsAuthenticated]

class GenerateDietPlanView(generics.CreateAPIView):
    serializer_class = WeeklyDietPlanSerializer
    permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        # This is a placeholder for the diet plan generation logic
        # You'll need to implement the actual algorithm here
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
