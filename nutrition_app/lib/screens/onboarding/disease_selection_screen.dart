import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../widgets/common/custom_button.dart';

class DiseaseSelectionScreen extends ConsumerStatefulWidget {
  const DiseaseSelectionScreen({super.key});

  @override
  ConsumerState<DiseaseSelectionScreen> createState() => _DiseaseSelectionScreenState();
}

class _DiseaseSelectionScreenState extends ConsumerState<DiseaseSelectionScreen> {
  Set<String> selectedDiseases = {};
  
  final diseases = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Kidney Disease',
    'None of the above'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Conditions'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select any health conditions you have:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us customize your nutrition plan.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: diseases.length,
                  itemBuilder: (context, index) {
                    final disease = diseases[index];
                    final isSelected = selectedDiseases.contains(disease);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected 
                            ? Theme.of(context).primaryColor 
                            : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          disease,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              if (disease == 'None of the above') {
                                selectedDiseases.clear();
                              } else {
                                selectedDiseases.remove('None of the above');
                              }
                              selectedDiseases.add(disease);
                            } else {
                              selectedDiseases.remove(disease);
                            }
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: selectedDiseases.isNotEmpty ? _continueToProfile : null,
                label: 'Continue',
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _continueToProfile() {
    // Save selected diseases and navigate to profile setup
    ref.read(profileProvider.notifier).updateDiseases(selectedDiseases.toList());
    Navigator.pushNamed(context, '/profile-setup');
  }
}
