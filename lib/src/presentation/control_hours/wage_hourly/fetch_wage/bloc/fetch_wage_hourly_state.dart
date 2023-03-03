part of 'fetch_wage_hourly_bloc.dart';

@freezed
class FetchWageHourlyState with _$FetchWageHourlyState {
  const factory FetchWageHourlyState.initial() = _Initial;
  const factory FetchWageHourlyState.loading() = _Loading;
  const factory FetchWageHourlyState.empty() = _Empty;
  const factory FetchWageHourlyState.error(GlobalDefaultFailure err) = _Error;
  const factory FetchWageHourlyState.hasDataStream(
    Stream<WageHourly> data,
  ) = _HasDataStream;
}

extension DataWage on FetchWageHourlyState {
  Future<WageHourly?> wage() async => when(
        initial: () => null,
        loading: () => null,
        empty: () => null,
        error: (_) => null,
        hasDataStream: (list) => list.last,
      );
}
