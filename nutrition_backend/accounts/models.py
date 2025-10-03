from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=15, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class UserProfile(models.Model):
    GENDER_CHOICES = [
        ('M', 'Male'),
        ('F', 'Female'),
        ('O', 'Other'),
    ]
    
    ACTIVITY_LEVELS = [
        ('sedentary', 'Sedentary'),
        ('lightly_active', 'Lightly Active'),
        ('moderately_active', 'Moderately Active'),
        ('very_active', 'Very Active'),
        ('extra_active', 'Extra Active'),
    ]
    
    BUDGET_TIERS = [
        ('low', 'Low (₹100-200/day)'),
        ('medium', 'Medium (₹200-400/day)'),
        ('high', 'High (₹400+/day)'),
    ]
    
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
    age = models.IntegerField()
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES)
    weight = models.FloatField(help_text="Weight in kg")
    height = models.FloatField(help_text="Height in cm")
    activity_level = models.CharField(max_length=20, choices=ACTIVITY_LEVELS)
    budget_tier = models.CharField(max_length=10, choices=BUDGET_TIERS)
    state = models.CharField(max_length=50)
    allergies = models.TextField(blank=True)
    dietary_preferences = models.TextField(blank=True, help_text="vegetarian, vegan, etc.")
    
    # Calculated fields
    daily_calorie_goal = models.IntegerField(null=True, blank=True)
    daily_protein_goal = models.FloatField(null=True, blank=True)
    daily_carbs_goal = models.FloatField(null=True, blank=True)
    daily_fat_goal = models.FloatField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
