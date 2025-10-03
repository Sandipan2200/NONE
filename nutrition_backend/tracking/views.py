from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from datetime import datetime, timedelta
from django.db.models import Sum
from .models import DailyFoodLog, DailyNutritionSummary
from .serializers import DailyFoodLogSerializer, DailyNutritionSummarySerializer

class DailyLogListView(generics.ListCreateAPIView):
    serializer_class = DailyFoodLogSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return DailyFoodLog.objects.filter(user=user).order_by('-date', '-logged_at')

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class DailyLogDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = DailyFoodLogSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return DailyFoodLog.objects.filter(user=self.request.user)

class DailyLogByDateView(generics.ListAPIView):
    serializer_class = DailyFoodLogSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        date = self.kwargs['date']
        return DailyFoodLog.objects.filter(
            user=self.request.user,
            date=datetime.strptime(date, '%Y-%m-%d').date()
        )

class MealLogListView(generics.ListAPIView):
    serializer_class = DailyFoodLogSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        meal_type = self.request.query_params.get('meal_type', None)
        queryset = DailyFoodLog.objects.filter(user=self.request.user)
        if meal_type:
            queryset = queryset.filter(meal_type=meal_type)
        return queryset

class MealLogDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = DailyFoodLogSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return DailyFoodLog.objects.filter(user=self.request.user)

class FoodLogListView(generics.ListCreateAPIView):
    serializer_class = DailyFoodLogSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return DailyFoodLog.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class FoodLogDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = DailyFoodLogSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return DailyFoodLog.objects.filter(user=self.request.user)

class WeeklyStatsView(generics.ListAPIView):
    serializer_class = DailyNutritionSummarySerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        today = datetime.now().date()
        week_ago = today - timedelta(days=7)
        return DailyNutritionSummary.objects.filter(
            user=self.request.user,
            date__gte=week_ago,
            date__lte=today
        ).order_by('date')

class MonthlyStatsView(generics.ListAPIView):
    serializer_class = DailyNutritionSummarySerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        today = datetime.now().date()
        month_ago = today - timedelta(days=30)
        return DailyNutritionSummary.objects.filter(
            user=self.request.user,
            date__gte=month_ago,
            date__lte=today
        ).order_by('date')
