import 'package:freezed_annotation/freezed_annotation.dart';
part 'time_entry.freezed.dart';
part 'time_entry.g.dart';

/// Domain entity representing a single tracked time entry.
///
/// Each entry stores [hour] and [minutes] worked. The optional [id]
/// defaults to `0` (unsaved) and is assigned by the persistence layer.
@freezed
abstract class TimeEntry with _$TimeEntry {
  /// Creates a [TimeEntry] with the given [hour], [minutes], and optional [id].
  const factory TimeEntry({
    /// Number of full hours tracked.
    required int hour,

    /// Additional minutes beyond full hours.
    required int minutes,

    /// Persistence identifier; `0` means the entry has not been saved yet.
    @Default(0) int id,
  }) = _TimeEntry;

  /// Deserializes a [TimeEntry] from a JSON map.
  factory TimeEntry.fromJson(
    Map<String, dynamic> json,
  ) => _$TimeEntryFromJson(json);

  const TimeEntry._();

  /// Converts this entry into a [Duration] for arithmetic operations.
  Duration get toDuration => Duration(hours: hour, minutes: minutes);
}

/// Payment and aggregation helpers on a list of [TimeEntry] instances.
extension CalculatePay on List<TimeEntry> {
  /// Computes total payment by multiplying accumulated hours and minutes
  /// against the given [wageHourly] rate.
  double calculatePayment(double wageHourly) {
    final hourPayment = totalHours * wageHourly;
    final minutesPayment = totalMinutes * (wageHourly / 60);

    return hourPayment + minutesPayment;
  }

  /// Returns the remaining minutes after full hours are extracted.
  int get totalMinutes {
    final list = List<Duration>.from(map((e) => e.toDuration));
    final d = list.fold(Duration.zero, (prev, e) => prev + e);
    return d.inMinutes - (totalHours * 60);
  }

  /// Returns the total number of full hours across all entries.
  int get totalHours {
    final list = List<Duration>.from(map((e) => e.toDuration));
    final d = list.fold(Duration.zero, (prev, e) => prev + e);
    return d.inHours;
  }
}
