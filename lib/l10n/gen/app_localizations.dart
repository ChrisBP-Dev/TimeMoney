import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// App bar title on the home page
  ///
  /// In en, this message translates to:
  /// **'Work Payment Controller'**
  String get homeTitle;

  /// Button label to add a new time entry
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get addTime;

  /// Button label to calculate payment
  ///
  /// In en, this message translates to:
  /// **'Calculate Payment'**
  String get calculatePayment;

  /// Title for the create time dialog and card
  ///
  /// In en, this message translates to:
  /// **'Create Time:'**
  String get createTimeTitle;

  /// Title for the update/delete time dialog
  ///
  /// In en, this message translates to:
  /// **'Update or Delete:'**
  String get updateOrDeleteTitle;

  /// Generic error label for buttons and states
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Label with colon suffix for form fields and info displays
  ///
  /// In en, this message translates to:
  /// **'{label}:'**
  String fieldLabel(String label);

  /// Label for the hour field
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hourTitle;

  /// Label for the minutes field
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutesTitle;

  /// Button label for create action
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Generic success label for button states
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Button label for update action
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Button label for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Message shown when the time entries list is empty
  ///
  /// In en, this message translates to:
  /// **'Empty List...\nThere are no times to calculate'**
  String get emptyTimesMessage;

  /// Title for the update wage dialog
  ///
  /// In en, this message translates to:
  /// **'Update Hourly Pay:'**
  String get updateHourlyPayTitle;

  /// Label for hourly wage display
  ///
  /// In en, this message translates to:
  /// **'Hourly:'**
  String get hourlyLabel;

  /// Button label to open wage update dialog
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Title for the payment result dialog
  ///
  /// In en, this message translates to:
  /// **'Result Info:'**
  String get resultInfoTitle;

  /// Label for total hours in payment result
  ///
  /// In en, this message translates to:
  /// **'Hours:'**
  String get hoursLabel;

  /// Label for total minutes in payment result
  ///
  /// In en, this message translates to:
  /// **'Minutes:'**
  String get minutesLabel;

  /// Currency name label
  ///
  /// In en, this message translates to:
  /// **'Dollars'**
  String get dollarsLabel;

  /// Label for worked days in payment result
  ///
  /// In en, this message translates to:
  /// **'Worked days:'**
  String get workedDaysLabel;

  /// Currency prefix displayed before payment amount
  ///
  /// In en, this message translates to:
  /// **'\$/. '**
  String get currencyPrefix;

  /// Button label for save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
