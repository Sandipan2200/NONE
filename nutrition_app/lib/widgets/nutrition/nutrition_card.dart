import 'package:flutter/material.dart';

class NutritionCard extends StatelessWidget {
  final String title;
  final double current;
  final double target;
  final String unit;

  const NutritionCard({
    super.key,
    required this.title,
    required this.current,
    required this.target,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (current / target).clamp(0.0, 1.0);
    final percentageText = (percentage * 100).toInt();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$percentageText%',
                  style: TextStyle(
                    color: _getProgressColor(percentage),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(percentage)),
              borderRadius: BorderRadius.circular(2),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Text(
              '${current.toInt()}/${target.toInt()} $unit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
