import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/features/times/presentation/bloc/create_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Minutes input field for the create-time form.
///
/// Wraps [CustomCreateField] with BLoC integration. Dispatches
/// [CreateTimeMinutesChanged] events to [CreateTimeBloc] on value
/// change and clears the field when the BLoC resets to its initial state.
class CreateMinutesField extends StatefulWidget {
  /// Creates a [CreateMinutesField].
  const CreateMinutesField({super.key});

  @override
  State<CreateMinutesField> createState() => _CreateMinutesFieldState();
}

class _CreateMinutesFieldState extends State<CreateMinutesField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTimeBloc, CreateTimeState>(
      listenWhen: (previous, current) =>
          current is CreateTimeInitial &&
          current.hour == 0 &&
          current.minutes == 0 &&
          previous is! CreateTimeInitial,
      listener: (context, state) => _controller.clear(),
      child: CustomCreateField(
        title: context.l10n.minutesTitle,
        controller: _controller,
        onChanged: (value) => context.read<CreateTimeBloc>().add(
          CreateTimeMinutesChanged(value: value),
        ),
      ),
    );
  }
}
