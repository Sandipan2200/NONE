import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

// Providers
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main.dart');
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return ApiService(prefs);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(apiServiceProvider));
});

// State classes
class AuthState {
  final bool isAuthenticated;
  final Map<String, dynamic>? user;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    Map<String, dynamic>? user,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
    );
  }
}

// Notifiers
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthNotifier(this._apiService) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = _apiService.authToken;
    if (token != null) {
      try {
        final userData = await _apiService.getUserProfile();
        state = state.copyWith(
          isAuthenticated: true,
          user: userData,
          error: null,
        );
      } catch (e) {
        await _apiService.clearTokens();
        state = state.copyWith(
          isAuthenticated: false,
          user: null,
          error: null,
        );
      }
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      state = state.copyWith(
        isAuthenticated: true,
        user: response['user'],
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.register(userData);
      state = state.copyWith(
        isAuthenticated: true,
        user: response['user'],
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await _apiService.clearTokens();
    state = AuthState();
  }
}

// Profile state and notifier
final userProfileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return ProfileNotifier(ref.watch(apiServiceProvider));
});

class ProfileNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ApiService _apiService;

  ProfileNotifier(this._apiService) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();
      final profile = await _apiService.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    try {
      state = const AsyncValue.loading();
      final updatedProfile = await _apiService.updateProfile(profileData);
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Food tracking state and notifier
final dailyNutritionProvider = StateNotifierProvider<NutritionNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return NutritionNotifier(ref.watch(apiServiceProvider));
});

class NutritionNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ApiService _apiService;

  NutritionNotifier(this._apiService) : super(const AsyncValue.loading());

  Future<void> loadDailySummary(String date) async {
    try {
      state = const AsyncValue.loading();
      final summary = await _apiService.getDailyNutritionSummary(date);
      state = AsyncValue.data(summary);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logFood(Map<String, dynamic> foodLog) async {
    try {
      await _apiService.logFood(foodLog);
      loadDailySummary(foodLog['date']);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Diet plan state and notifier
final dietPlanProvider = StateNotifierProvider<DietPlanNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return DietPlanNotifier(ref.watch(apiServiceProvider));
});

class DietPlanNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ApiService _apiService;

  DietPlanNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> generatePlan() async {
    try {
      state = const AsyncValue.loading();
      final plan = await _apiService.generateDietPlan();
      state = AsyncValue.data(plan);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}