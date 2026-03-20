// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Work Payment Controller';

  @override
  String get addTime => 'Add Time';

  @override
  String get calculatePayment => 'Calculate Payment';

  @override
  String get createTimeTitle => 'Create Time:';

  @override
  String get updateOrDeleteTitle => 'Update or Delete:';

  @override
  String get error => 'Error';

  @override
  String fieldLabel(String label) {
    return '$label:';
  }

  @override
  String get hourTitle => 'Hour';

  @override
  String get minutesTitle => 'Minutes';

  @override
  String get create => 'Create';

  @override
  String get success => 'Success';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get emptyTimesMessage =>
      'Empty List...\nThere are no times to calculate';

  @override
  String get updateHourlyPayTitle => 'Update Hourly Pay:';

  @override
  String get hourlyLabel => 'Hourly:';

  @override
  String get change => 'Change';

  @override
  String get resultInfoTitle => 'Result Info:';

  @override
  String get hoursLabel => 'Hours:';

  @override
  String get minutesLabel => 'Minutes:';

  @override
  String get dollarsLabel => 'Dollars';

  @override
  String get workedDaysLabel => 'Worked days:';

  @override
  String get currencyPrefix => '\$/. ';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Retry';
}
