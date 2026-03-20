import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_money/l10n/l10n.dart';
import 'package:time_money/src/core/extensions/screen_size.dart';
import 'package:time_money/src/core/locale/locale.dart';
import 'package:time_money/src/features/home/presentation/widgets/widgets.dart';
import 'package:time_money/src/features/times/presentation/pages/list_times_page.dart';
import 'package:time_money/src/features/times/presentation/widgets/widgets.dart';
import 'package:time_money/src/features/wage/presentation/pages/fetch_wage_page.dart';

/// Main landing page of the application.
///
/// Composes the wage input section, the time entries list, and the
/// bottom action bar with calculate-payment and add-time buttons.
class HomePage extends StatelessWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          context.l10n.homeTitle,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: const [_LocaleToggle()],
      ),
      body: Column(
        children: [
          const FetchWagePage(),
          const Expanded(child: ListTimesPage()),
          SafeArea(
            child: Container(
              color: Theme.of(context)
                  .colorScheme
                  .surface
                  .withValues(alpha: .2),
              height: context.getHeight * .13,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CalculatePaymentButton(),
                  FloatingActionButton.extended(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      unawaited(showDialog<void>(
                        context: context,
                        builder: (context) => const CreateTimeCard(),
                      ));
                    },
                    label: Text(
                      context.l10n.addTime,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _LocaleToggle extends StatelessWidget {
  const _LocaleToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final currentCode = switch (state) {
          LocaleSystem() =>
            Localizations.localeOf(context).languageCode,
          LocaleSelected(:final locale) => locale.languageCode,
        };
        final isSpanish = currentCode == 'es';

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white70),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 32),
            ),
            onPressed: () => context.read<LocaleCubit>().setLocale(
                  isSpanish
                      ? const Locale('en')
                      : const Locale('es'),
                ),
            child: Text(
              isSpanish ? 'EN' : 'ES',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        );
      },
    );
  }
}
