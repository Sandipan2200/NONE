import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  final SharedPreferences _prefs;
  static const _localeKey = 'app_locale';

  LocaleNotifier(this._prefs) : super(null) {
    // Load saved locale on initialization
    final savedLocale = _prefs.getString(_localeKey);
    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      if (parts.length == 2) {
        state = Locale(parts[0], parts[1]);
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_localeKey, '${locale.languageCode}_${locale.countryCode}');
    state = locale;
  }

  void resetLocale() {
    _prefs.remove(_localeKey);
    state = null;
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this provider in your main.dart');
});

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});