/// Tests for [EditButton] widget.
///
/// Verifies that [EditButton] dispatches [UpdateTimeInit] on tap.
/// Dialog content is NOT tested here due to provider scope limitations —
/// dialog internals are tested in update_time_page_test.dart.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_money/src/features/times/domain/entities/time_entry.dart';
import 'package:time_money/src/features/times/presentation/bloc/update_time_bloc.dart';
import 'package:time_money/src/features/times/presentation/widgets/edit_button.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  group('EditButton', () {
    const testTime = TimeEntry(id: 1, hour: 2, minutes: 30);
    late MockUpdateTimeBloc mockBloc;

    setUpAll(() {
      registerFallbackValue(const UpdateTimeInit(time: testTime));
    });

    setUp(() {
      mockBloc = MockUpdateTimeBloc();
      when(() => mockBloc.state).thenReturn(const UpdateTimeInitial());
    });

    testWidgets('renders a FilledButton with edit icon', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const EditButton(time: testTime),
        ),
      );
      await tester.pump();

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byIcon(Icons.edit_note_outlined), findsOneWidget);
    });

    testWidgets('dispatches UpdateTimeInit on tap', (tester) async {
      await tester.pumpApp(
        BlocProvider<UpdateTimeBloc>.value(
          value: mockBloc,
          child: const EditButton(time: testTime),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(FilledButton));

      verify(() => mockBloc.add(any(that: isA<UpdateTimeInit>())))
          .called(1);
    });
  });
}
