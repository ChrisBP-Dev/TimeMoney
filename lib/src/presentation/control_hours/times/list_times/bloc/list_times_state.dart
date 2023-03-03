part of 'list_times_bloc.dart';

@freezed
class ListTimesState with _$ListTimesState {
  const factory ListTimesState.initial() = _Initial;
  const factory ListTimesState.loading() = _Loading;
  const factory ListTimesState.empty() = _Empty;
  const factory ListTimesState.error(GlobalDefaultFailure err) = _Error;
  const factory ListTimesState.hasDataStream(
    Stream<List<ModelTime>> data,
  ) = _HasDataStream;
}

extension DataListTime on ListTimesState {
  Future<List<ModelTime>?> list() async => when(
        initial: () => null,
        loading: () => null,
        empty: () => null,
        error: (_) => null,
        hasDataStream: (list) async {
          final dataList = await list.toList();
          if (dataList.isEmpty) {
            return [];
          } else {
            final length = dataList.last.length;
            return length == 0 ? [] : dataList.last;
          }
        },
      );
}
