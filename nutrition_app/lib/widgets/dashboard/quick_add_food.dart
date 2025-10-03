import 'package:flutter/material.dart';
import 'package:nutrition_app/screens/food/add_food_screen.dart';

class QuickAddFood extends StatelessWidget {
  const QuickAddFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Add',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMealButton(
                    context,
                    'Breakfast',
                    Icons.wb_sunny_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMealButton(
                    context,
                    'Lunch',
                    Icons.restaurant_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMealButton(
                    context,
                    'Dinner',
                    Icons.nightlight_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMealButton(
                    context,
                    'Snack',
                    Icons.cake_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealButton(BuildContext context, String meal, IconData icon) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddFoodScreen(
              selectedMealType: meal.toLowerCase(),
            ),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(meal),
        ],
      ),
    );
  }
}