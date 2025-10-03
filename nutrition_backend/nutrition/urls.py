from django.urls import path
from . import views

urlpatterns = [
    # Disease endpoints
    path('diseases/', views.DiseaseListView.as_view(), name='disease-list'),
    path('diseases/<int:pk>/', views.DiseaseDetailView.as_view(), name='disease-detail'),
    
    # Food endpoints
    path('foods/', views.FoodItemListView.as_view(), name='food-list'),
    path('foods/<int:pk>/', views.FoodItemDetailView.as_view(), name='food-detail'),
    path('foods/search/', views.FoodSearchView.as_view(), name='food-search'),
    
    # Diet plan endpoints
    path('diet-plans/', views.DietPlanListView.as_view(), name='diet-plan-list'),
    path('diet-plans/<int:pk>/', views.DietPlanDetailView.as_view(), name='diet-plan-detail'),
    path('diet-plans/generate/', views.GenerateDietPlanView.as_view(), name='generate-diet-plan'),
]