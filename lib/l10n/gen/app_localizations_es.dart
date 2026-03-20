// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get homeTitle => 'Controlador de Pago Laboral';

  @override
  String get addTime => 'Agregar Tiempo';

  @override
  String get calculatePayment => 'Calcular Pago';

  @override
  String get createTimeTitle => 'Crear Tiempo:';

  @override
  String get updateOrDeleteTitle => 'Actualizar o Eliminar:';

  @override
  String get error => 'Error';

  @override
  String fieldLabel(String label) {
    return '$label:';
  }

  @override
  String get hourTitle => 'Hora';

  @override
  String get minutesTitle => 'Minutos';

  @override
  String get create => 'Crear';

  @override
  String get success => 'Éxito';

  @override
  String get update => 'Actualizar';

  @override
  String get delete => 'Eliminar';

  @override
  String get emptyTimesMessage =>
      'Lista vacía...\nNo hay tiempos para calcular';

  @override
  String get updateHourlyPayTitle => 'Actualizar Pago por Hora:';

  @override
  String get hourlyLabel => 'Por hora:';

  @override
  String get change => 'Cambiar';

  @override
  String get resultInfoTitle => 'Información del Resultado:';

  @override
  String get hoursLabel => 'Horas:';

  @override
  String get minutesLabel => 'Minutos:';

  @override
  String get dollarsLabel => 'Dólares';

  @override
  String get workedDaysLabel => 'Días trabajados:';

  @override
  String get currencyPrefix => '\$/. ';

  @override
  String get save => 'Guardar';
}
