import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/core/locale/locale.dart';
import 'package:time_money/src/features/home/presentation/pages/home_page.dart';

/// Root [MaterialApp] widget that configures theming, localization,
/// and the initial route ([HomePage]).
///
/// Listens to [LocaleCubit] to dynamically switch the app locale
/// when the user selects a language. When the cubit is in
/// [LocaleSystem], the app follows the device / browser locale.
class App extends StatelessWidget {
  /// Creates the root [App] widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color.fromARGB(255, 6, 16, 31),
          ),
          locale: switch (state) {
            LocaleSystem() => null,
            LocaleSelected(:final locale) => locale,
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
        );
      },
    );
  }
}
