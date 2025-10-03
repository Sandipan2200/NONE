import 'package:flutter/material.dart';
import 'package:nutrition_app/screens/auth/auth_choice_screen.dart';
import 'package:nutrition_app/screens/onboarding/onboarding_questions_screen.dart';
import 'package:nutrition_app/screens/welcome_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingQuestionsScreen());
      case auth:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AuthChoiceScreen(onboardingData: args ?? {}),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}