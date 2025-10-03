import json
from django.core.management.base import BaseCommand
from nutrition.models import Disease, FoodCategory, FoodItem

class Command(BaseCommand):
    help = 'Initialize database with basic disease and food data'

    def handle(self, *args, **kwargs):
        # Create diseases
        self.create_diseases()
        
        # Create food categories
        self.create_food_categories()
        
        # Create food items
        self.create_food_items()
        
        self.stdout.write(self.style.SUCCESS('Successfully initialized database'))
    
    def create_diseases(self):
        diseases_data = [
            {
                'name': 'Diabetes',
                'description': 'A metabolic disease that causes high blood sugar',
                'dietary_restrictions': json.dumps({
                    'max_sugar_per_meal': 15,  # grams
                    'max_carbs_per_meal': 45,  # grams
                    'avoid_foods': ['sugary drinks', 'candies', 'white bread'],
                    'preferred_foods': ['whole grains', 'leafy greens', 'lean proteins']
                })
            }
        ]
        
        for data in diseases_data:
            Disease.objects.get_or_create(
                name=data['name'],
                defaults={
                    'description': data['description'],
                    'dietary_restrictions': data['dietary_restrictions']
                }
            )
    
    def create_food_categories(self):
        categories = [
            'Grains and Cereals',
            'Pulses and Legumes',
            'Vegetables',
            'Fruits',
            'Dairy Products',
            'Meat and Poultry',
            'Fish and Seafood',
            'Nuts and Seeds',
            'Oils and Fats',
            'Spices and Condiments'
        ]
        
        for category in categories:
            FoodCategory.objects.get_or_create(name=category)
    
    def create_food_items(self):
        # Sample food items data
        foods_data = [
            {
                'category': 'Grains and Cereals',
                'items': [
                    {
                        'name': 'Brown Rice',
                        'calories_per_100g': 111,
                        'protein_per_100g': 2.6,
                        'carbohydrates_per_100g': 23.0,
                        'fat_per_100g': 0.9,
                        'fiber_per_100g': 1.8,
                        'sugar_per_100g': 0.1,
                        'sodium_per_100g': 5,
                        'available_states': 'all',
                        'budget_tier': 'low',
                        'average_cost_per_100g': 5.0,
                        'dietary_tags': 'vegetarian,vegan,gluten-free'
                    }
                ]
            },
            {
                'category': 'Pulses and Legumes',
                'items': [
                    {
                        'name': 'Toor Dal',
                        'calories_per_100g': 343,
                        'protein_per_100g': 22.0,
                        'carbohydrates_per_100g': 57.2,
                        'fat_per_100g': 1.7,
                        'fiber_per_100g': 15.0,
                        'sugar_per_100g': 2.0,
                        'sodium_per_100g': 17,
                        'available_states': 'all',
                        'budget_tier': 'low',
                        'average_cost_per_100g': 12.0,
                        'dietary_tags': 'vegetarian,vegan,gluten-free'
                    }
                ]
            },
            # Add more categories and items as needed
        ]
        
        for food_data in foods_data:
            category = FoodCategory.objects.get(name=food_data['category'])
            for item in food_data['items']:
                FoodItem.objects.get_or_create(
                    name=item['name'],
                    category=category,
                    defaults={
                        'calories_per_100g': item['calories_per_100g'],
                        'protein_per_100g': item['protein_per_100g'],
                        'carbohydrates_per_100g': item['carbohydrates_per_100g'],
                        'fat_per_100g': item['fat_per_100g'],
                        'fiber_per_100g': item['fiber_per_100g'],
                        'sugar_per_100g': item['sugar_per_100g'],
                        'sodium_per_100g': item['sodium_per_100g'],
                        'available_states': item['available_states'],
                        'budget_tier': item['budget_tier'],
                        'average_cost_per_100g': item['average_cost_per_100g'],
                        'dietary_tags': item['dietary_tags']
                    }
                )