import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/delete_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';

/// Card widget representing a single time entry in the list.
///
/// Displays the time entry's hour and minutes via [InfoTime],
/// an [EditButton] to open the update dialog, and a delete
/// [IconButton] that shows a [DeleteTimeConfirmationDialog].
class TimeCard extends StatelessWidget {
  /// Creates a [TimeCard] for the given [time] entry.
  const TimeCard({
    required this.time,
    super.key,
  });

  /// The time entry to display in this card.
  final TimeEntry time;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(child: InfoTime(time: time)),
            EditButton(time: time),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                final deleteBloc = context.read<DeleteTimeBloc>();
                unawaited(
                  showDialog<void>(
                    context: context,
                    builder: (_) => BlocProvider<DeleteTimeBloc>.value(
                      value: deleteBloc,
                      child: DeleteTimeConfirmationDialog(time: time),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
