import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/times_injection.dart';
import 'package:time_money/src/features/wage/wage_injection.dart';

/// Aggregates all feature-level use case [RepositoryProvider]s for DI.
///
/// Collects providers from Times and Wage features into a single list
/// consumed by the root [MultiRepositoryProvider].
class UseCasesInjection {
  /// Returns the combined list of all feature use case providers.
  static List<RepositoryProvider<Object>> list() => [
    ...TimesUseCasesInjections.list(),
    ...WageUseCasesInjections.list(),
  ];
}
