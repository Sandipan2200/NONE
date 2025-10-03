from django.db import models
from accounts.models import CustomUser, UserProfile

class Disease(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)
    dietary_restrictions = models.TextField(blank=True, help_text="JSON format restrictions")
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.name

class UserDisease(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='diseases')
    disease = models.ForeignKey(Disease, on_delete=models.CASCADE)
    diagnosed_date = models.DateField(null=True, blank=True)
    severity = models.CharField(max_length=20, blank=True)
    
    class Meta:
        unique_together = ['user', 'disease']

class FoodCategory(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    
    def __str__(self):
        return self.name

class FoodItem(models.Model):
    name = models.CharField(max_length=200)
    category = models.ForeignKey(FoodCategory, on_delete=models.CASCADE)
    
    # Nutritional values per 100g
    calories_per_100g = models.FloatField()
    protein_per_100g = models.FloatField()
    carbohydrates_per_100g = models.FloatField()
    fat_per_100g = models.FloatField()
    fiber_per_100g = models.FloatField(default=0)
    sugar_per_100g = models.FloatField(default=0)
    sodium_per_100g = models.FloatField(default=0)  # mg
    
    # Regional and budget info
    available_states = models.TextField(help_text="Comma-separated state codes")
    budget_tier = models.CharField(max_length=10, choices=UserProfile.BUDGET_TIERS)
    average_cost_per_100g = models.FloatField(help_text="Cost in rupees")
    
    # Restrictions
    allergens = models.TextField(blank=True, help_text="Comma-separated allergens")
    dietary_tags = models.TextField(blank=True, help_text="vegetarian,vegan,gluten-free,etc")
    
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.name

class Meal(models.Model):
    MEAL_TYPES = [
        ('breakfast', 'Breakfast'),
        ('lunch', 'Lunch'),
        ('dinner', 'Dinner'),
        ('snack', 'Snack'),
    ]
    
    name = models.CharField(max_length=200)
    meal_type = models.CharField(max_length=20, choices=MEAL_TYPES)
    description = models.TextField(blank=True)
    preparation_time = models.IntegerField(help_text="Time in minutes")
    
    # Regional and dietary filters
    suitable_for_states = models.TextField(blank=True)
    suitable_for_diseases = models.ManyToManyField(Disease, blank=True)
    dietary_tags = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.name} ({self.meal_type})"

class MealFood(models.Model):
    meal = models.ForeignKey(Meal, on_delete=models.CASCADE, related_name='foods')
    food_item = models.ForeignKey(FoodItem, on_delete=models.CASCADE)
    quantity_grams = models.FloatField()
    
    class Meta:
        unique_together = ['meal', 'food_item']

class DietPlanTemplate(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    
    # Target criteria
    target_diseases = models.ManyToManyField(Disease, blank=True)
    target_calorie_range_min = models.IntegerField()
    target_calorie_range_max = models.IntegerField()
    suitable_for_states = models.TextField(blank=True)
    budget_tier = models.CharField(max_length=10, choices=UserProfile.BUDGET_TIERS)
    
    created_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.name

class WeeklyDietPlan(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    template = models.ForeignKey(DietPlanTemplate, on_delete=models.CASCADE, null=True, blank=True)
    week_start_date = models.DateField()
    
    # Nutritional targets for the week
    daily_calorie_target = models.IntegerField()
    daily_protein_target = models.FloatField()
    daily_carbs_target = models.FloatField()
    daily_fat_target = models.FloatField()
    
    generated_at = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)
    
    class Meta:
        unique_together = ['user', 'week_start_date']

class DailyMealPlan(models.Model):
    weekly_plan = models.ForeignKey(WeeklyDietPlan, on_delete=models.CASCADE, related_name='daily_plans')
    date = models.DateField()
    
    breakfast = models.ForeignKey(Meal, on_delete=models.CASCADE, related_name='breakfast_plans', null=True)
    lunch = models.ForeignKey(Meal, on_delete=models.CASCADE, related_name='lunch_plans', null=True)
    dinner = models.ForeignKey(Meal, on_delete=models.CASCADE, related_name='dinner_plans', null=True)
    snacks = models.ManyToManyField(Meal, related_name='snack_plans', blank=True)
    
    total_calories = models.FloatField()
    total_protein = models.FloatField()
    total_carbs = models.FloatField()
    total_fat = models.FloatField()
    
    class Meta:
        unique_together = ['weekly_plan', 'date']
