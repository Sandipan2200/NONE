from django.urls import path
from . import views

urlpatterns = [
    # Daily log endpoints
    path('logs/', views.DailyLogListView.as_view(), name='daily-log-list'),
    path('logs/<int:pk>/', views.DailyLogDetailView.as_view(), name='daily-log-detail'),
    path('logs/date/<str:date>/', views.DailyLogByDateView.as_view(), name='daily-log-by-date'),
    
    # Meal log endpoints
    path('meals/', views.MealLogListView.as_view(), name='meal-log-list'),
    path('meals/<int:pk>/', views.MealLogDetailView.as_view(), name='meal-log-detail'),
    
    # Food log endpoints
    path('food-logs/', views.FoodLogListView.as_view(), name='food-log-list'),
    path('food-logs/<int:pk>/', views.FoodLogDetailView.as_view(), name='food-log-detail'),
    
    # Statistics endpoints
    path('stats/weekly/', views.WeeklyStatsView.as_view(), name='weekly-stats'),
    path('stats/monthly/', views.MonthlyStatsView.as_view(), name='monthly-stats'),
]