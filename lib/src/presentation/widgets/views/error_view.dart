import 'package:flutter/material.dart';
import 'package:time_money/src/core/failures/failures.dart';
import 'package:time_money/src/presentation/widgets/info_section.dart';

class ErrorView extends StatelessWidget {
  const ErrorView(
    this.failure, {
    required this.actionWidget,
    super.key,
  });

  final GlobalDefaultFailure failure;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return failure.when(
      internalError: (_, __) => ShowInfoSection(
        infoImage: const IconText('⚠️'),
        infoMessage: '''
Hubo un error interno, por favor asegurese de tener la última versión de la App.
 $_
''',
        actionWidget: actionWidget,
      ),
      timeOutExceeded: () => ShowInfoSection(
        infoImage: const IconText('⏳'),
        infoMessage: 'Se agotó el tiempo de espera',
        actionWidget: actionWidget,
      ),
      serverError: (failure) => ShowInfoSection(
        infoImage: const IconText('🚨'),
        infoMessage: 'Hubor un error en el servidor',
        actionWidget: actionWidget,
      ),
      notConnection: () => ShowInfoSection(
        infoImage: const IconText('📡'),
        infoMessage: 'Hubo un problema de conexión.',
        actionWidget: actionWidget,
      ),
    );
  }
}
