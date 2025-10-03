import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ta'),
    Locale('te')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Nutrition App'**
  String get appTitle;

  /// Title for the daily tracking screen
  ///
  /// In en, this message translates to:
  /// **'Daily Tracker'**
  String get dailyTracker;

  /// Title for the profile screen
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Title for the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Title for the add food screen
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get addFood;

  /// Label for calories
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// Label for protein
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// Label for carbohydrates
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// Label for fat
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// Label for today's progress section
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todaysProgress;

  /// Title for language settings
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Name of English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Name of Hindi language
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// Name of Tamil language
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get tamil;

  /// Name of Telugu language
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get telugu;

  /// Header for meal types
  ///
  /// In en, this message translates to:
  /// **'Meal Types'**
  String get mealTypes;

  /// Breakfast meal type
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// Lunch meal type
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// Dinner meal type
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// Snacks meal type
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacks;

  /// Title for nutrition goals section
  ///
  /// In en, this message translates to:
  /// **'Nutrition Goals'**
  String get nutritionGoals;

  /// Label for daily calorie goal setting
  ///
  /// In en, this message translates to:
  /// **'Daily Calorie Goal'**
  String get dailyCalorieGoal;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Generic success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Label for state selection
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// Label for region selection
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// Label for local cuisine section
  ///
  /// In en, this message translates to:
  /// **'Local Cuisine'**
  String get localCuisine;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'ta': return AppLocalizationsTa();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
