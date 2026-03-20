---
title: 'Fix pre-existing UI/UX layout and state issues'
type: 'bugfix'
created: '2026-03-20'
status: 'done'
baseline_commit: '43f00bfd'
context:
  - '_bmad-output/implementation-artifacts/4-5-multi-platform-verification-localization-validation.md'
---

# Fix pre-existing UI/UX layout and state issues

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Four pre-existing UI/UX defects hurt cross-platform usability: (1) `CreateTimeCard` overflows on certain viewports due to rigid `FractionallySizedBox(heightFactor: .24)`, (2) no `maxWidth` constraint means content stretches absurdly on web/desktop, (3) `_ActionWidget` shows a non-functional "Error" button on both empty and error states — the empty state is not an error, and the error state has no retry, (4) `CalculatePaymentButton` stays visible (disabled) when there is no data to calculate.

**Approach:** Remove rigid height constraints in favor of intrinsic sizing, add a responsive `maxWidth` wrapper using the existing breakpoint infrastructure, replace placeholder `_ActionWidget` with contextually correct actions (nothing on empty, retry on error), and conditionally hide the calculate button when `PaymentCubit` is not ready. Add new `retry` ARB key for localization.

## Boundaries & Constraints

**Always:** Zero `flutter analyze` warnings. All existing 165 tests pass. New behavior covered by tests. Follow existing localization pattern (`context.l10n`). Use existing `BreakPoints`/`ScreenSize` infrastructure for responsive constraints.

**Ask First:** If the responsive `maxWidth` value needs to differ from `BreakPoints.maxMobile` (767px).

**Never:** Touch domain/data layers, BLoCs, or DI wiring. Modify existing test assertions (only add new ones). Introduce new dependencies. Redesign the visual theme or color scheme.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Empty times list | `ListTimesEmpty` | Show empty message + clock icon, NO action button | N/A |
| Error loading times | `ListTimesError(failure)` | Show error view + "Retry" button | Retry dispatches `ListTimesRequested` |
| Error fetching wage | `FetchWageError(failure)` | Show error view + "Retry" button | Retry dispatches `FetchWageRequested` |
| No data to calculate | `PaymentInitial` | Bottom bar shows only "Add Time" FAB, no calculate button | N/A |
| Data ready | `PaymentReady` | Bottom bar shows both calculate button and "Add Time" FAB | N/A |
| CreateTimeCard on small viewport | Dialog open, screen height ~667px | Card sizes to content, no overflow stripe | N/A |
| Web wide viewport (>767px) | Browser window 1200px+ wide | Body content constrained to max width, centered | N/A |
| Mobile viewport (<=767px) | Phone 375px wide | Body content fills width as before (no change) | N/A |

</frozen-after-approval>

## Code Map

- `lib/src/features/times/presentation/widgets/create_time_card.dart` -- overflow source: rigid `FractionallySizedBox(heightFactor: .24)`
- `lib/src/features/times/presentation/pages/list_times_page.dart` -- passes non-functional `_ActionWidget` to empty AND error states
- `lib/src/features/times/presentation/widgets/list_times_other_view.dart` -- `EmptyListTimesView` receives unnecessary `actionWidget`
- `lib/src/features/wage/presentation/pages/fetch_wage_page.dart` -- same `_ActionWidget` pattern for wage error state
- `lib/src/features/home/presentation/pages/home_page.dart` -- no maxWidth constraint, calculate button always visible
- `lib/src/features/home/presentation/widgets/calculate_payment_button.dart` -- no conditional visibility
- `lib/l10n/arb/app_en.arb` -- needs `retry` key
- `lib/l10n/arb/app_es.arb` -- needs `retry` key
- `lib/src/core/constants/break_points.dart` -- existing `maxMobile = 767.0` for responsive threshold

## Tasks & Acceptance

**Execution:**
- [ ] `lib/src/features/times/presentation/widgets/create_time_card.dart` -- remove `FractionallySizedBox`, let `Column(mainAxisSize: MainAxisSize.min)` + `Card` auto-size within dialog constraints
- [ ] `lib/src/features/home/presentation/pages/home_page.dart` -- wrap `Scaffold.body` Column children (except bottom bar) in `Center > ConstrainedBox(maxWidth: BreakPoints.maxMobile)` for responsive capping; conditionally render `CalculatePaymentButton` only when `PaymentCubit` state is `PaymentReady`
- [ ] `lib/src/features/home/presentation/widgets/calculate_payment_button.dart` -- wrap in `BlocBuilder` returning `SizedBox.shrink()` when `PaymentInitial`
- [ ] `lib/l10n/arb/app_en.arb` -- add `retry` key ("Retry")
- [ ] `lib/l10n/arb/app_es.arb` -- add `retry` key ("Reintentar")
- [ ] Run `flutter gen-l10n` to regenerate localization code
- [ ] `lib/src/features/times/presentation/pages/list_times_page.dart` -- remove `_ActionWidget` class; pass `null` for empty state, pass retry button (dispatches `ListTimesRequested`) for error state
- [ ] `lib/src/features/wage/presentation/pages/fetch_wage_page.dart` -- remove `_ActionWidget` class; pass retry button (dispatches `FetchWageRequested`) for error state
- [ ] Verify `flutter analyze` returns zero warnings
- [ ] Verify `flutter test` passes all 165 tests with zero failures

**Acceptance Criteria:**
- Given the app is opened on a browser with >767px width, when viewing any page, then content is constrained to a maximum width and centered
- Given the times list is empty, when viewing the list, then no action button is shown — only the empty message and icon
- Given the times list fails to load, when viewing the error, then a "Retry" button is shown that re-fetches the list
- Given no time entries and no wage are loaded, when viewing the bottom bar, then only the "Add Time" FAB is visible
- Given the CreateTimeCard dialog is opened on any viewport, then no yellow/black overflow stripe appears

## Verification

**Commands:**
- `flutter analyze` -- expected: zero issues
- `flutter test --test-randomize-ordering-seed random` -- expected: 165+ tests pass, zero failures
- `flutter build web --target lib/main_production.dart` -- expected: compiles with zero errors

**Manual checks:**
- Open web build at 1200px+ width: content is centered and constrained
- Open CreateTimeCard dialog on small viewport (~667px height): no overflow
- Verify empty list shows no error button
- Verify error state shows functional retry button
