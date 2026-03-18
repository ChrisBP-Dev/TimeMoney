import 'package:freezed_annotation/freezed_annotation.dart';
part 'time_entry.freezed.dart';
part 'time_entry.g.dart';

@freezed
abstract class TimeEntry with _$TimeEntry {
  const factory TimeEntry({
    required int hour,
    required int minutes,
    @Default(0) int id,
  }) = _TimeEntry;

  factory TimeEntry.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$TimeEntryFromJson(json);

  const TimeEntry._();

  Duration get toDuration => Duration(hours: hour, minutes: minutes);
}

extension CalculatePay on List<TimeEntry> {
  double calculatePayment(double wageHourly) {
    final hourPayment = totalHours * wageHourly;
    final minutesPayment = totalMinutes * (wageHourly / 60);

    return hourPayment + minutesPayment;
  }

  int get totalMinutes {
    final list = List<Duration>.from(map((e) => e.toDuration));
    final d = list.fold(Duration.zero, (prev, e) => prev + e);
    return d.inMinutes - (totalHours * 60);
  }

  int get totalHours {
    final list = List<Duration>.from(map((e) => e.toDuration));
    final d = list.fold(Duration.zero, (prev, e) => prev + e);
    return d.inHours;
  }
}
