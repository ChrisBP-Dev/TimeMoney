import 'package:flutter/material.dart';
import 'package:time_money/src/core/errors/failures.dart';
import 'package:time_money/src/shared/widgets/widgets.dart';

/// Widget that renders an appropriate error message for a [GlobalFailure].
///
/// Maps each failure subtype to a localized [ShowInfoSection] with a
/// relevant icon and message text.
class ErrorView extends StatelessWidget {
  /// Creates an [ErrorView] for the given [failure].
  const ErrorView(
    this.failure, {
    required this.actionWidget,
    super.key,
  });

  /// The failure to display.
  final GlobalFailure failure;

  /// Optional action widget shown below the error message
  /// (e.g., a retry button).
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return switch (failure) {
      InternalError(:final error) => ShowInfoSection(
        infoImage: const IconText('⚠️'),
        infoMessage:
            '''
Hubo un error interno, por favor asegurese de tener la última versión de la App.
 $error
''',
        actionWidget: actionWidget,
      ),
      TimeOutExceeded() => ShowInfoSection(
        infoImage: const IconText('⏳'),
        infoMessage: 'Se agotó el tiempo de espera',
        actionWidget: actionWidget,
      ),
      ServerError() => ShowInfoSection(
        infoImage: const IconText('🚨'),
        infoMessage: 'Hubo un error en el servidor',
        actionWidget: actionWidget,
      ),
      NotConnection() => ShowInfoSection(
        infoImage: const IconText('📡'),
        infoMessage: 'Hubo un problema de conexión.',
        actionWidget: actionWidget,
      ),
    };
  }
}
