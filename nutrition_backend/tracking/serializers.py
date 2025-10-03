from rest_framework import serializers
from .models import DailyFoodLog, DailyNutritionSummary
from nutrition.serializers import FoodItemSerializer

class DailyFoodLogSerializer(serializers.ModelSerializer):
    food_details = FoodItemSerializer(source='food_item', read_only=True)
    
    class Meta:
        model = DailyFoodLog
        fields = '__all__'
        read_only_fields = ('user', 'calories', 'protein', 'carbs', 'fat')
    
    def create(self, validated_data):
        food_item = validated_data['food_item']
        quantity = validated_data['quantity_grams']
        
        # Calculate nutrition values based on quantity
        validated_data['calories'] = (food_item.calories_per_100g * quantity) / 100
        validated_data['protein'] = (food_item.protein_per_100g * quantity) / 100
        validated_data['carbs'] = (food_item.carbohydrates_per_100g * quantity) / 100
        validated_data['fat'] = (food_item.fat_per_100g * quantity) / 100
        
        return super().create(validated_data)

class DailyNutritionSummarySerializer(serializers.ModelSerializer):
    class Meta:
        model = DailyNutritionSummary
        fields = '__all__'
        read_only_fields = ('user',)