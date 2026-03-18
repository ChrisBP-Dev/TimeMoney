part of 'fetch_wage_bloc.dart';

@freezed
abstract class FetchWageState with _$FetchWageState {
  const factory FetchWageState.initial() = _Initial;
  const factory FetchWageState.loading() = _Loading;
  const factory FetchWageState.empty() = _Empty;
  const factory FetchWageState.error(GlobalFailure err) = _Error;
  const factory FetchWageState.hasDataStream(
    Stream<WageHourly> data,
  ) = _HasDataStream;
}

extension DataWage on FetchWageState {
  Future<WageHourly?> wage() async => when(
        initial: () => null,
        loading: () => null,
        empty: () => null,
        error: (_) => null,
        hasDataStream: (list) => list.last,
      );
}
