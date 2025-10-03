import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_app/services/providers.dart';
import 'package:nutrition_app/widgets/dashboard/nutrition_summary_card.dart';
import 'package:nutrition_app/widgets/dashboard/nutrition_calendar.dart';
import 'package:nutrition_app/widgets/dashboard/quick_add_food.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDailySummary();
  }

  void _loadDailySummary() {
    ref.read(dailyNutritionProvider.notifier).loadDailySummary(
      _selectedDate.toIso8601String().split('T')[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyNutrition = ref.watch(dailyNutritionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadDailySummary(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate.subtract(
                            const Duration(days: 1),
                          );
                          _loadDailySummary();
                        });
                      },
                    ),
                    Text(
                      _selectedDate.toIso8601String().split('T')[0],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate.add(
                            const Duration(days: 1),
                          );
                          _loadDailySummary();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Daily nutrition summary
            dailyNutrition.when(
              data: (data) => NutritionSummaryCard(data: data ?? {}),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),

            // Quick add food section
            const QuickAddFood(),
            const SizedBox(height: 16),

            // Calendar view
            const NutritionCalendar(),
          ],
        ),
      ),
    );
  }
}