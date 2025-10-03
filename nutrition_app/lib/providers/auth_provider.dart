import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final Map<String, dynamic>? userData;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.userData,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    Map<String, dynamic>? userData,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userData: userData ?? this.userData,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement login API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userData: {'email': email},
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement registration API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userData: userData,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
