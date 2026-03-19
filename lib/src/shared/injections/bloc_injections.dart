import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/payment/presentation/cubit/payment_cubits.dart';
import 'package:time_money/src/features/times/presentation/bloc/times_blocs.dart';
import 'package:time_money/src/features/wage/presentation/bloc/wage_blocs.dart';

/// Aggregates all feature-level [BlocProvider]s for dependency injection.
///
/// Collects providers from Times, Wage, and Payment features into a
/// single list consumed by the root [MultiBlocProvider].
class BlocInjections {
  /// Returns the combined list of all feature bloc providers.
  static List<BlocProvider> list() => [
        ...TimesBlocs.list(),
        ...WageBlocs.list(),
        ...PaymentCubits.list(),
      ];
}
