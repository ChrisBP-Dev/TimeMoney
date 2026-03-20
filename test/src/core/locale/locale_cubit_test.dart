import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_money/src/core/locale/locale.dart';

void main() {
  group('LocaleCubit', () {
    test('initial state is LocaleSystem', () {
      expect(LocaleCubit().state, isA<LocaleSystem>());
    });

    blocTest<LocaleCubit, LocaleState>(
      'setLocale emits LocaleSelected with the given locale',
      build: LocaleCubit.new,
      act: (cubit) => cubit.setLocale(const Locale('es')),
      expect: () => [const LocaleSelected(Locale('es'))],
    );

    blocTest<LocaleCubit, LocaleState>(
      'setLocale can switch between locales',
      build: LocaleCubit.new,
      act: (cubit) => cubit
        ..setLocale(const Locale('es'))
        ..setLocale(const Locale('en')),
      expect: () => [
        const LocaleSelected(Locale('es')),
        const LocaleSelected(Locale('en')),
      ],
    );

    blocTest<LocaleCubit, LocaleState>(
      'resetToSystem emits LocaleSystem',
      build: LocaleCubit.new,
      seed: () => const LocaleSelected(Locale('es')),
      act: (cubit) => cubit.resetToSystem(),
      expect: () => [const LocaleSystem()],
    );
  });

  group('LocaleState', () {
    test('LocaleSystem instances are equal', () {
      expect(const LocaleSystem(), equals(const LocaleSystem()));
    });

    test('LocaleSelected with same locale are equal', () {
      expect(
        const LocaleSelected(Locale('es')),
        equals(const LocaleSelected(Locale('es'))),
      );
    });

    test('LocaleSelected with different locales are not equal', () {
      expect(
        const LocaleSelected(Locale('en')),
        isNot(equals(const LocaleSelected(Locale('es')))),
      );
    });
  });
}
