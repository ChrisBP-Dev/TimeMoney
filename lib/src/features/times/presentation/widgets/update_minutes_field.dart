import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/custom_update_field.dart';

/// Minutes input field for the update-time form.
///
/// Wraps [CustomUpdateField] with BLoC integration. Pre-populates
/// the field with the current minutes value from [UpdateTimeBloc]
/// and dispatches [UpdateTimeMinutesChanged] events on value change.
class UpdateMinutesField extends StatefulWidget {
  /// Creates an [UpdateMinutesField].
  const UpdateMinutesField({super.key});

  @override
  State<UpdateMinutesField> createState() => _UpdateMinutesFieldState();
}

class _UpdateMinutesFieldState extends State<UpdateMinutesField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<UpdateTimeBloc>().state.time?.minutes.toString(),
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
          title: context.l10n.minutesTitle,
          controller: _controller,
          onChanged: (value) => context.read<UpdateTimeBloc>().add(
                UpdateTimeMinutesChanged(value: value),
              ),
        );
      },
    );
  }
}
