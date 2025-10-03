import 'package:nutrition_app/common.dart';
import 'package:nutrition_app/screens/auth/auth_choice_screen.dart';

class OnboardingQuestionsScreen extends ConsumerStatefulWidget {
  const OnboardingQuestionsScreen({super.key});

  @override
  ConsumerState<OnboardingQuestionsScreen> createState() => _OnboardingQuestionsScreenState();
}

class _OnboardingQuestionsScreenState extends ConsumerState<OnboardingQuestionsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<Widget> _questions = [
    const DiseaseQuestion(),
    const AgeQuestion(),
    const GenderQuestion(),
    const StateQuestion(),
    const BudgetQuestion(),
    const MeasurementsQuestion(),
    const ActivityQuestion(),
    const DietaryPreferenceQuestion(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentPage + 1} of ${_questions.length}'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentPage + 1) / _questions.length,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _questions,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Back'),
                  )
                else
                  const SizedBox.shrink(),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _questions.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Save all data and proceed to main app
                      _finishOnboarding();
                    }
                  },
                  child: Text(
                    _currentPage < _questions.length - 1 ? 'Next' : 'Finish',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _finishOnboarding() {
    // Get onboarding data
    final onboardingState = ref.read(onboardingProvider);
    final onboardingData = {
      'goalType': onboardingState.goalType,
      'hasDiabetes': onboardingState.hasDiabetes,
      'hasHypertension': onboardingState.hasHypertension,
      'hasHeartDisease': onboardingState.hasHeartDisease,
      'hasCeliacDisease': onboardingState.hasCeliacDisease,
      'hasFoodAllergies': onboardingState.hasFoodAllergies,
      'otherConditions': onboardingState.otherConditions,
      'age': onboardingState.age,
      'gender': onboardingState.gender,
      'state': onboardingState.state,
      'budgetTier': onboardingState.budgetTier,
      'weight': onboardingState.weight,
      'height': onboardingState.height,
      'activityLevel': onboardingState.activityLevel,
      'dietaryPreference': onboardingState.dietaryPreference,
    };
    
    // Save data before navigation
    ref.read(onboardingProvider.notifier).saveOnboardingData();
    
    // Navigate to auth choice screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => AuthChoiceScreen(onboardingData: onboardingData),
      ),
      (route) => false,
    );
  }
}

class DiseaseQuestion extends ConsumerWidget {
  const DiseaseQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDiabetes = ref.watch(onboardingProvider.select((s) => s.hasDiabetes));
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What brings you to our app?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select your primary goal',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: 'medical',
                child: Text('Managing Medical Conditions'),
              ),
              DropdownMenuItem(
                value: 'fitness',
                child: Text('Fitness and Wellness Goals'),
              ),
            ],
            onChanged: (value) {
              ref.read(onboardingProvider.notifier).updateGoalType(value ?? 'medical');
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Select any applicable medical conditions:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              FilterChip(
                label: const Text('Diabetes'),
                selected: hasDiabetes,
                onSelected: (value) {
                  ref.read(onboardingProvider.notifier).updateDiabetes(value);
                },
              ),
              FilterChip(
                label: const Text('Hypertension'),
                selected: ref.watch(onboardingProvider.select((s) => s.hasHypertension)),
                onSelected: (value) {
                  ref.read(onboardingProvider.notifier).updateHypertension(value);
                },
              ),
              FilterChip(
                label: const Text('Heart Disease'),
                selected: ref.watch(onboardingProvider.select((s) => s.hasHeartDisease)),
                onSelected: (value) {
                  ref.read(onboardingProvider.notifier).updateHeartDisease(value);
                },
              ),
              FilterChip(
                label: const Text('Celiac Disease'),
                selected: ref.watch(onboardingProvider.select((s) => s.hasCeliacDisease)),
                onSelected: (value) {
                  ref.read(onboardingProvider.notifier).updateCeliacDisease(value);
                },
              ),
              FilterChip(
                label: const Text('Food Allergies'),
                selected: ref.watch(onboardingProvider.select((s) => s.hasFoodAllergies)),
                onSelected: (value) {
                  ref.read(onboardingProvider.notifier).updateFoodAllergies(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Other medical conditions or allergies',
              border: OutlineInputBorder(),
              hintText: 'Enter any other conditions here',
            ),
            maxLines: 2,
            onChanged: (value) {
              ref.read(onboardingProvider.notifier).updateOtherConditions(value);
            },
          ),
        ],
      ),
    );
  }
}

// Implement other question widgets similarly
class AgeQuestion extends ConsumerWidget {
  const AgeQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final age = ref.watch(onboardingProvider.select((s) => s.age));
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is your age?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                ref.read(onboardingProvider.notifier).updateAge(int.parse(value));
              }
            },
            controller: TextEditingController(text: age?.toString() ?? ''),
          ),
        ],
      ),
    );
  }
}

class GenderQuestion extends ConsumerWidget {
  const GenderQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gender = ref.watch(onboardingProvider.select((s) => s.gender));
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is your gender?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          for (final option in ['M', 'F', 'O'])
            RadioListTile<String>(
              title: Text(
                option == 'M' ? 'Male' :
                option == 'F' ? 'Female' : 'Other'
              ),
              value: option,
              groupValue: gender,
              onChanged: (value) {
                if (value != null) {
                  ref.read(onboardingProvider.notifier).updateGender(value);
                }
              },
            ),
        ],
      ),
    );
  }
}

class StateQuestion extends ConsumerWidget {
  const StateQuestion({super.key});

  final List<String> indianStates = const [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 
    'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh',
    'Jharkhand', 'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra',
    'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
    'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedState = ref.watch(onboardingProvider.select((s) => s.state));
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select your state',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: selectedState,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'State',
            ),
            items: indianStates.map((state) => DropdownMenuItem(
              value: state,
              child: Text(state),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(onboardingProvider.notifier).updateState(value);
              }
            },
          ),
        ],
      ),
    );
  }
}

class BudgetQuestion extends ConsumerWidget {
  const BudgetQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(onboardingProvider.select((s) => s.budgetTier));
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is your daily food budget?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          for (final option in [
            ('low', 'Low (₹100-200/day)'),
            ('medium', 'Medium (₹200-400/day)'),
            ('high', 'High (₹400+/day)'),
          ])
            RadioListTile<String>(
              title: Text(option.$2),
              value: option.$1,
              groupValue: budget,
              onChanged: (value) {
                if (value != null) {
                  ref.read(onboardingProvider.notifier).updateBudgetTier(value);
                }
              },
            ),
        ],
      ),
    );
  }
}

class MeasurementsQuestion extends ConsumerWidget {
  const MeasurementsQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weight = ref.watch(onboardingProvider.select((s) => s.weight));
    final height = ref.watch(onboardingProvider.select((s) => s.height));
    final TextEditingController feetController = TextEditingController();
    final TextEditingController inchesController = TextEditingController();
    
    if (height != null) {
      // Convert cm to feet and inches
      final totalInches = height / 2.54;
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      feetController.text = feet.toString();
      inchesController.text = inches.toString();
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your measurements',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextFormField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: const Icon(Icons.monitor_weight_outlined),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                ref.read(onboardingProvider.notifier)
                   .updateWeight(double.parse(value));
              }
            },
            controller: TextEditingController(
              text: weight?.toString() ?? ''
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Height',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: feetController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    labelText: 'Feet',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    prefixIcon: const Icon(Icons.height),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
                  ),
                  onChanged: (feet) {
                    if (feet.isNotEmpty && inchesController.text.isNotEmpty) {
                      final totalCm = (int.parse(feet) * 30.48) + 
                                    (int.parse(inchesController.text) * 2.54);
                      ref.read(onboardingProvider.notifier).updateHeight(totalCm);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: inchesController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    labelText: 'Inches',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
                  ),
                  onChanged: (inches) {
                    if (inches.isNotEmpty && feetController.text.isNotEmpty) {
                      final totalCm = (int.parse(feetController.text) * 30.48) + 
                                    (int.parse(inches) * 2.54);
                      ref.read(onboardingProvider.notifier).updateHeight(totalCm);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityQuestion extends ConsumerWidget {
  const ActivityQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(onboardingProvider.select((s) => s.activityLevel));
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is your activity level?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          for (final option in [
            ('sedentary', 'Sedentary (little or no exercise)'),
            ('lightly_active', 'Lightly Active (light exercise 1-3 days/week)'),
            ('moderately_active', 'Moderately Active (moderate exercise 3-5 days/week)'),
            ('very_active', 'Very Active (hard exercise 6-7 days/week)'),
            ('extra_active', 'Extra Active (very hard exercise & physical job)'),
          ])
            RadioListTile<String>(
              title: Text(option.$2),
              value: option.$1,
              groupValue: activity,
              onChanged: (value) {
                if (value != null) {
                  ref.read(onboardingProvider.notifier).updateActivityLevel(value);
                }
              },
            ),
        ],
      ),
    );
  }
}

class DietaryPreferenceQuestion extends ConsumerWidget {
  const DietaryPreferenceQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preference = ref.watch(onboardingProvider.select((s) => s.dietaryPreference));
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What are your dietary preferences?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          for (final option in [
            ('vegetarian', 'Vegetarian'),
            ('vegan', 'Vegan'),
            ('non_vegetarian', 'Non-Vegetarian'),
          ])
            RadioListTile<String>(
              title: Text(option.$2),
              value: option.$1,
              groupValue: preference,
              onChanged: (value) {
                if (value != null) {
                  ref.read(onboardingProvider.notifier).updateDietaryPreference(value);
                }
              },
            ),
        ],
      ),
    );
  }
}