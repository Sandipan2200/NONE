// providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  ProfileNotifier(this._apiService) : super(const AsyncValue.loading());
  
  final ApiService _apiService;
  
  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();
      final profile = await _apiService.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> updateDiseases(List<String> diseases) async {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(diseases: diseases);
      state = AsyncValue.data(updatedProfile);
      
      try {
        await _apiService.updateProfile(updatedProfile);
      } catch (error) {
        // Revert on error
        state = AsyncValue.data(currentProfile);
        rethrow;
      }
    }
  }
}

// Provider definitions
final apiServiceProvider = Provider((ref) => ApiService());

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  return ProfileNotifier(ref.watch(apiServiceProvider));
});