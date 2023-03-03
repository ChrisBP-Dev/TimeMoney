import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/model_time.dart';
import 'package:time_money/src/presentation/control_hours/times/update_time/bloc/update_time_bloc.dart';
import 'package:time_money/src/presentation/control_hours/times/update_time/update_view.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    required this.time,
    super.key,
  });

  final ModelTime time;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: () async {
        context.read<UpdateTimeBloc>().add(
              UpdateTimeEvent.init(time: time),
            );
        await showDialog<void>(
          context: context,
          builder: (context) {
            return UpdateTimeView(time: time);
          },
        );
      },
      child: const Icon(Icons.edit_note_outlined),
    );
  }
}
