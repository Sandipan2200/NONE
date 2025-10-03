from rest_framework import serializers
from .models import (
    Disease, FoodCategory, FoodItem, Meal,
    MealFood, DietPlanTemplate, WeeklyDietPlan, DailyMealPlan
)

class DiseaseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Disease
        fields = '__all__'

class FoodCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodCategory
        fields = '__all__'

class FoodItemSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = FoodItem
        fields = '__all__'

class MealFoodSerializer(serializers.ModelSerializer):
    food_name = serializers.CharField(source='food_item.name', read_only=True)
    food_details = FoodItemSerializer(source='food_item', read_only=True)

    class Meta:
        model = MealFood
        fields = ('id', 'food_item', 'food_name', 'food_details', 'quantity_grams')

class MealSerializer(serializers.ModelSerializer):
    foods = MealFoodSerializer(many=True, read_only=True)
    total_calories = serializers.SerializerMethodField()
    total_protein = serializers.SerializerMethodField()
    total_carbs = serializers.SerializerMethodField()
    total_fat = serializers.SerializerMethodField()

    class Meta:
        model = Meal
        fields = '__all__'

    def get_total_calories(self, obj):
        return sum(
            (food.food_item.calories_per_100g * food.quantity_grams / 100)
            for food in obj.foods.all()
        )

    def get_total_protein(self, obj):
        return sum(
            (food.food_item.protein_per_100g * food.quantity_grams / 100)
            for food in obj.foods.all()
        )

    def get_total_carbs(self, obj):
        return sum(
            (food.food_item.carbohydrates_per_100g * food.quantity_grams / 100)
            for food in obj.foods.all()
        )

    def get_total_fat(self, obj):
        return sum(
            (food.food_item.fat_per_100g * food.quantity_grams / 100)
            for food in obj.foods.all()
        )

class DietPlanTemplateSerializer(serializers.ModelSerializer):
    class Meta:
        model = DietPlanTemplate
        fields = '__all__'
        read_only_fields = ('created_by',)

    def create(self, validated_data):
        validated_data['created_by'] = self.context['request'].user
        return super().create(validated_data)

class DailyMealPlanSerializer(serializers.ModelSerializer):
    breakfast_details = MealSerializer(source='breakfast', read_only=True)
    lunch_details = MealSerializer(source='lunch', read_only=True)
    dinner_details = MealSerializer(source='dinner', read_only=True)
    snacks_details = MealSerializer(source='snacks', many=True, read_only=True)

    class Meta:
        model = DailyMealPlan
        fields = '__all__'

class WeeklyDietPlanSerializer(serializers.ModelSerializer):
    daily_plans = DailyMealPlanSerializer(many=True, read_only=True)

    class Meta:
        model = WeeklyDietPlan
        fields = '__all__'
        read_only_fields = ('user',)