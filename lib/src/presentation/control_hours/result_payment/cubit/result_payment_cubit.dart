import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';

part 'result_payment_state.dart';
part 'result_payment_cubit.freezed.dart';

class ResultPaymentCubit extends Cubit<ResultPaymentState> {
  ResultPaymentCubit() : super(ResultPaymentState.initial());

  void setList(List<TimeEntry> list) {
    emit(state.copyWith(times: list));
  }

  void setWage(double wageHourly) {
    emit(state.copyWith(wageHourly: wageHourly));
  }
}
