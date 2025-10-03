from typing import List, Dict
from ..models import FoodItem, Disease, DietPlan
from accounts.models import UserProfile, UserPreferences

class DietGenerator:
    def __init__(self, user_profile: UserProfile):
        self.user_profile = user_profile
        self.user_preferences = UserPreferences.objects.get(user=user_profile.user)
        self.diseases = Disease.objects.filter(user=user_profile)
    
    def generate_weekly_plan(self) -> Dict:
        """Generate a weekly diet plan based on user profile and preferences"""
        weekly_plan = {}
        for day in range(7):
            daily_meals = self._generate_daily_meals()
            weekly_plan[f'day_{day + 1}'] = daily_meals
        return weekly_plan
    
    def _generate_daily_meals(self) -> Dict:
        """Generate meals for a single day"""
        daily_calories = self._calculate_daily_calories()
        meals_per_day = self.user_preferences.meal_count_per_day
        calories_per_meal = daily_calories / meals_per_day
        
        daily_meals = {}
        for meal_num in range(meals_per_day):
            meal = self._generate_meal(calories_per_meal)
            daily_meals[f'meal_{meal_num + 1}'] = meal
            
        return daily_meals
    
    def _generate_meal(self, target_calories: float) -> Dict:
        """Generate a single meal with target calories"""
        # Implementation would include logic for:
        # - Selecting appropriate foods based on preferences
        # - Checking against dietary restrictions
        # - Balancing macronutrients
        # - Avoiding restricted foods from diseases
        pass
    
    def _calculate_daily_calories(self) -> float:
        """Calculate daily calorie needs based on BMR and activity level"""
        bmr = self.user_profile.calculate_bmr()
        if not bmr:
            return 2000  # Default value
            
        activity_multipliers = {
            'sedentary': 1.2,
            'light': 1.375,
            'moderate': 1.55,
            'very': 1.725,
            'extra': 1.9
        }
        
        return bmr * activity_multipliers.get(self.user_profile.activity_level, 1.55)