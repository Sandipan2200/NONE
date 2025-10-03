from django.db import models
from accounts.models import CustomUser
from nutrition.models import FoodItem, Meal

class DailyFoodLog(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    date = models.DateField()
    food_item = models.ForeignKey(FoodItem, on_delete=models.CASCADE)
    quantity_grams = models.FloatField()
    meal_type = models.CharField(max_length=20, choices=Meal.MEAL_TYPES)
    
    # Calculated nutrition values
    calories = models.FloatField()
    protein = models.FloatField()
    carbs = models.FloatField()
    fat = models.FloatField()
    
    logged_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-date', '-logged_at']

class DailyNutritionSummary(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    date = models.DateField()
    
    total_calories = models.FloatField(default=0)
    total_protein = models.FloatField(default=0)
    total_carbs = models.FloatField(default=0)
    total_fat = models.FloatField(default=0)
    
    # Goal achievement percentages
    calorie_goal_percentage = models.FloatField(default=0)
    protein_goal_percentage = models.FloatField(default=0)
    carbs_goal_percentage = models.FloatField(default=0)
    fat_goal_percentage = models.FloatField(default=0)
    
    # Status for calendar coloring
    STATUS_CHOICES = [
        ('poor', 'Poor (<50% of goals)'),
        ('okay', 'Okay (50-80% of goals)'),
        ('good', 'Good (80%+ of goals)'),
    ]
    overall_status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='poor')
    
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['user', 'date']
