import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_app/services/providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _allergiesController;
  late TextEditingController _dietaryPreferencesController;
  String _selectedGender = 'M';
  String _selectedActivityLevel = 'moderately_active';
  String _selectedBudgetTier = 'medium';
  String _selectedState = 'DL';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final profile = ref.read(userProfileProvider).value;
    _ageController = TextEditingController(text: profile?['age']?.toString() ?? '');
    _weightController = TextEditingController(text: profile?['weight']?.toString() ?? '');
    _heightController = TextEditingController(text: profile?['height']?.toString() ?? '');
    _allergiesController = TextEditingController(text: profile?['allergies'] ?? '');
    _dietaryPreferencesController = TextEditingController(text: profile?['dietary_preferences'] ?? '');
    _selectedGender = profile?['gender'] ?? 'M';
    _selectedActivityLevel = profile?['activity_level'] ?? 'moderately_active';
    _selectedBudgetTier = profile?['budget_tier'] ?? 'medium';
    _selectedState = profile?['state'] ?? 'DL';
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _allergiesController.dispose();
    _dietaryPreferencesController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(userProfileProvider.notifier).updateProfile({
        'age': int.parse(_ageController.text),
        'weight': double.parse(_weightController.text),
        'height': double.parse(_heightController.text),
        'gender': _selectedGender,
        'activity_level': _selectedActivityLevel,
        'budget_tier': _selectedBudgetTier,
        'state': _selectedState,
        'allergies': _allergiesController.text,
        'dietary_preferences': _dietaryPreferencesController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: profileState.when(
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?['user']?['first_name'] ?? 'User',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                profile?['user']?['email'] ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 13 || age > 120) {
                      return 'Please enter a valid age between 13 and 120';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  enabled: _isEditing,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: 'M', child: Text('Male')),
                    DropdownMenuItem(value: 'F', child: Text('Female')),
                    DropdownMenuItem(value: 'O', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedGender = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 20 || weight > 500) {
                      return 'Please enter a valid weight between 20 and 500 kg';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _heightController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height < 100 || height > 250) {
                      return 'Please enter a valid height between 100 and 250 cm';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Lifestyle',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedActivityLevel,
                  enabled: _isEditing,
                  decoration: const InputDecoration(labelText: 'Activity Level'),
                  items: const [
                    DropdownMenuItem(value: 'sedentary', child: Text('Sedentary')),
                    DropdownMenuItem(value: 'lightly_active', child: Text('Lightly Active')),
                    DropdownMenuItem(value: 'moderately_active', child: Text('Moderately Active')),
                    DropdownMenuItem(value: 'very_active', child: Text('Very Active')),
                    DropdownMenuItem(value: 'extra_active', child: Text('Extra Active')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedActivityLevel = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedBudgetTier,
                  enabled: _isEditing,
                  decoration: const InputDecoration(labelText: 'Budget Tier'),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low (₹100-200/day)')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium (₹200-400/day)')),
                    DropdownMenuItem(value: 'high', child: Text('High (₹400+/day)')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedBudgetTier = value);
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Dietary Preferences',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _allergiesController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(
                    labelText: 'Allergies',
                    hintText: 'Enter allergies separated by commas',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dietaryPreferencesController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(
                    labelText: 'Dietary Preferences',
                    hintText: 'vegetarian, vegan, etc.',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}