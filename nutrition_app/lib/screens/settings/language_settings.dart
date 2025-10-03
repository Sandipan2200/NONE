import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

class LanguageSettings extends ConsumerWidget {
  const LanguageSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
      ),
      body: ListView(
        children: [
          _buildLanguageOption(
            context,
            ref,
            title: l10n.english,
            locale: const Locale('en', 'US'),
            currentLocale: currentLocale,
          ),
          _buildLanguageOption(
            context,
            ref,
            title: l10n.hindi,
            locale: const Locale('hi', 'IN'),
            currentLocale: currentLocale,
          ),
          _buildLanguageOption(
            context,
            ref,
            title: l10n.tamil,
            locale: const Locale('ta', 'IN'),
            currentLocale: currentLocale,
          ),
          _buildLanguageOption(
            context,
            ref,
            title: l10n.telugu,
            locale: const Locale('te', 'IN'),
            currentLocale: currentLocale,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required Locale locale,
    required Locale? currentLocale,
  }) {
    final isSelected = currentLocale?.languageCode == locale.languageCode;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(title),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () {
          ref.read(localeProvider.notifier).setLocale(locale);
        },
      ),
    );
  }
}