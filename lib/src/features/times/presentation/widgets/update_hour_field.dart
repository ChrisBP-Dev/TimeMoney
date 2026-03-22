import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Hour input field for the update-time form.
///
/// Wraps [CustomUpdateField] with BLoC integration. Pre-populates
/// the field with the current hour value from [UpdateTimeBloc] and
/// dispatches [UpdateTimeHourChanged] events on value change.
class UpdateHourField extends StatefulWidget {
  /// Creates an [UpdateHourField].
  const UpdateHourField({super.key});

  @override
  State<UpdateHourField> createState() => _UpdateHourFieldState();
}

class _UpdateHourFieldState extends State<UpdateHourField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<UpdateTimeBloc>().state.time?.hour.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateTimeBloc, UpdateTimeState>(
      builder: (context, state) {
        return CustomUpdateField(
          title: context.l10n.hourTitle,
          controller: _controller,
          onChanged: (value) => context.read<UpdateTimeBloc>().add(
            UpdateTimeHourChanged(value: value),
          ),
        );
      },
    );
  }
}
