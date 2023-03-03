import 'package:freezed_annotation/freezed_annotation.dart';
part 'model_time.freezed.dart';
part 'model_time.g.dart';

@freezed
class ModelTime with _$ModelTime {
  const factory ModelTime({
    required int hour,
    required int minutes,
    @Default(0) int id,
  }) = _ModelTime;

  factory ModelTime.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ModelTimeFromJson(json);

  const ModelTime._();

  Duration get toDuration => Duration(hours: hour, minutes: minutes);
}

extension CalculatePay on List<ModelTime> {
  double calculatePayment(double wageHourly) {
    final hourPayment = totalHours * wageHourly;
    final minutesPayment = totalMinutes * (wageHourly / 60);

    return hourPayment + minutesPayment;
  }
  // double get calculateHours {
  //   final horasTrabajadas = List<Duration>.from(map((e) => e.toDuration));

  //   var totalHorasTrabajadas = 0.0;

  //   for (final horaTrabajada in horasTrabajadas) {
  //     final horasTrabajadasDia = horaTrabajada.inMinutes / 60.0;
  //     totalHorasTrabajadas += horasTrabajadasDia;
  //   }

  //   return totalHorasTrabajadas;
  // }

  int get totalMinutes {
    final list = List<Duration>.from(map((e) => e.toDuration));
    final d = list.fold(Duration.zero, (prev, e) => prev + e);
    return d.inMinutes - (totalHours * 60);
  }

  int get totalHours {
    final list = List<Duration>.from(map((e) => e.toDuration));
    final d = list.fold(Duration.zero, (prev, e) => prev + e);
    return d.inHours;
    // return fold(0, (prev, e) => prev + e.hour);
  }
  // int get totalMinutes => fold(0, (prev, e) => prev + e.minutes);
  // int get totalHours => fold(0, (prev, e) => prev + e.hour);
}
