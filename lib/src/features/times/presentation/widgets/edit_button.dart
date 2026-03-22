import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/pages/update_time_page.dart';

/// Button that opens the [UpdateTimePage] dialog for a time entry.
///
/// Initialises the [UpdateTimeBloc] with the selected [time] and
/// presents the update dialog via [showDialog].
class EditButton extends StatelessWidget {
  /// Creates an [EditButton] for the given [time] entry.
  const EditButton({
    required this.time,
    super.key,
  });

  /// The time entry to edit when the button is pressed.
  final TimeEntry time;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: () async {
        context.read<UpdateTimeBloc>().add(
              UpdateTimeInit(time: time),
            );
        await showDialog<void>(
          context: context,
          builder: (context) {
            return UpdateTimePage(time: time);
          },
        );
      },
      child: const Icon(Icons.edit_note_outlined),
    );
  }
}
