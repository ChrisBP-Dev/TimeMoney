---
title: 'Epic 5 Tech Debt & UX Fixes'
type: 'bugfix'
created: '2026-03-22'
status: 'done'
baseline_commit: '5e3eecf'
context: ['_bmad-output/project-context.md']
---

# Epic 5 Tech Debt & UX Fixes

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Five deferred issues from Epic 5 block Epic 6 readiness: (1) `PaymentInitial.operator==` missing identical guard, (2) `_LocaleToggle` unsupported-locale branch silently relies on modulo arithmetic, (3) `home_page.dart` opens bare `CreateTimeCard` in `showDialog` instead of `CreateTimePage`, causing unconstrained expansion, (4) delete action buried in Update dialog without confirmation — UX anti-pattern, (5) golden baselines stale after UI changes.

**Approach:** Fix all five production code issues, update affected tests, add missing test coverage, and regenerate golden baselines. CreateTimePage refactored to match UpdateTimePage's AlertDialog+Card+actions pattern. Delete button relocated from UpdateTimePage to TimeCard list with confirmation dialog.

## Boundaries & Constraints

**Always:** Dartdoc on all new/modified public APIs. Zero linter warnings. Use existing `DeleteTimeBloc` 4-state pattern — no BLoC changes. Localized strings via `context.l10n`. Tests ship with every fix.

**Ask First:** If CreateTimeCard refactor would break any external consumers beyond home_page.dart and CreateTimePage.

**Never:** Modify DeleteTimeBloc logic. Add new BLoC/Cubit. Skip golden regeneration. Use hardcoded strings.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Locale toggle — unsupported system locale (e.g. `fr`) | `LocaleSystem()` with system locale `fr` | `indexWhere` returns -1, fallback to index 0 (first supported locale) | Defensive clamp, no crash |
| Locale toggle — supported locale `en` | `LocaleSystem()` with `en` | Shows "ES" (next locale), cycles normally | N/A |
| Delete from TimeCard — confirm | Tap delete icon → confirmation dialog → confirm | `DeleteTimeRequested` dispatched, loading → success → dialog closes | `DeleteTimeError` shown in dialog |
| Delete from TimeCard — cancel | Tap delete icon → confirmation dialog → cancel | Dialog dismissed, no deletion | N/A |
| Delete — bloc error | `DeleteTimeError(failure)` emitted | Error label shown in confirmation dialog, button re-enables after feedback delay | Error state renders, resets to initial |

</frozen-after-approval>

## Code Map

- `lib/src/features/payment/presentation/cubit/payment_state.dart` -- PaymentInitial operator== fix
- `lib/src/features/home/presentation/pages/home_page.dart` -- _LocaleToggle fallback + CreateTimePage dialog reference
- `lib/src/features/times/presentation/pages/create_time_page.dart` -- Refactor to match UpdateTimePage pattern (Card+actions)
- `lib/src/features/times/presentation/widgets/create_time_card.dart` -- Strip title+button, match UpdateTimeCard structure
- `lib/src/features/times/presentation/pages/update_time_page.dart` -- Remove DeleteTimeButton from actions, update title
- `lib/src/features/times/presentation/widgets/time_card.dart` -- Add delete IconButton beside EditButton
- `lib/src/features/times/presentation/widgets/delete_time_button.dart` -- Adapt for confirmation dialog context (canPop guard still valid)
- `lib/src/features/times/presentation/widgets/widgets.dart` -- Export new confirmation dialog widget
- `test/src/features/payment/presentation/cubit/payment_state_test.dart` -- Add identical guard test
- `test/src/features/home/presentation/pages/home_page_test.dart` -- Add unsupported-locale test
- `test/src/features/times/presentation/pages/create_time_page_test.dart` -- Update for new structure
- `test/src/features/times/presentation/pages/update_time_page_test.dart` -- Remove DeleteTimeButton assertions
- `test/src/features/times/presentation/widgets/time_card_test.dart` -- Add delete button assertions
- `test/src/features/times/presentation/widgets/delete_time_button_test.dart` -- Adjust for confirmation dialog context
- `test/goldens/` -- Regenerate all baselines

## Tasks & Acceptance

**Execution:**
- [x] `payment_state.dart` -- Add `identical(this, other) ||` guard to `PaymentInitial.operator==` -- consistency with PaymentReady
- [x] `home_page.dart` -- In `_LocaleToggle`, clamp `currentIndex` to 0 when `indexWhere` returns -1 -- explicit defensive fallback
- [x] `home_page.dart` -- Change `showDialog` builder from `CreateTimeCard()` to `CreateTimePage()` -- fix unconstrained expansion
- [x] `create_time_card.dart` -- Remove title Text and CreateTimeButton from widget, match UpdateTimeCard layout (Card > Padding > Row with hour+minutes fields only) -- structural consistency
- [x] `create_time_page.dart` -- Add `CreateTimeButton` as action (like UpdateTimePage pattern), update dartdoc -- complete dialog structure
- [x] `update_time_page.dart` -- Remove `DeleteTimeButton` from actions, update title l10n key to update-only -- decouple delete from update dialog
- [x] `time_card.dart` -- Add delete `IconButton` beside `EditButton`, on tap show `DeleteTimeConfirmationDialog` -- relocate destructive action to list
- [x] New `delete_time_confirmation_dialog.dart` -- AlertDialog with confirm/cancel using `DeleteTimeBloc` state-driven UI (loading, success→pop, error display) -- confirmation UX for destructive action
- [x] `widgets.dart` -- Export `delete_time_confirmation_dialog.dart` -- barrel update
- [x] `payment_state_test.dart` -- Add test for identical instance equality -- verify fix 1
- [x] `home_page_test.dart` -- Add test for unsupported system locale fallback behavior -- verify fix 2
- [x] `create_time_page_test.dart` -- Update assertions for new AlertDialog+actions structure -- verify fix 3
- [x] `update_time_page_test.dart` -- Remove DeleteTimeButton assertion, update title assertion -- verify fix 4a
- [x] `time_card_test.dart` -- Add delete IconButton assertions + confirmation dialog launch -- verify fix 4b
- [x] New `delete_time_confirmation_dialog_test.dart` -- Test 4-state rendering, confirm dispatches event, cancel pops, success pops -- verify fix 4c
- [x] `test/goldens/` -- Regenerate all golden baselines via `--update-goldens`, then verify comparison -- fix 5

**Acceptance Criteria:**
- Given PaymentInitial instances, when comparing identical references, then `identical(this, other)` short-circuits to true
- Given a system locale not in supportedLocales, when _LocaleToggle builds, then it defaults to the first supported locale without error
- Given the user taps "Add Time", when the dialog opens, then CreateTimePage renders as a constrained AlertDialog (not bare Card)
- Given a TimeCard in the list, when user taps delete icon, then a confirmation dialog appears before any deletion occurs
- Given the confirmation dialog, when user confirms deletion, then DeleteTimeBloc processes the delete with loading/success/error feedback
- Given all UI changes are complete, when golden tests run in comparison mode, then all baselines match current rendering

## Design Notes

**CreateTimePage refactor pattern** — Mirror UpdateTimePage exactly:
```dart
// CreateTimePage.build
AlertDialog(
  title: Text(context.l10n.createTimeTitle),
  icon: /* close button */,
  content: Column(mainAxisSize: MainAxisSize.min, children: [CreateTimeCard()]),
  actionsAlignment: MainAxisAlignment.center,
  actions: [CreateTimeButton()],
)
```
CreateTimeCard becomes: `Card > Padding > Row(hour, spacer, minutes, spacer)` — no title, no button.

**DeleteTimeConfirmationDialog** — Minimal AlertDialog using existing DeleteTimeBloc:
```dart
AlertDialog(
  title: Text(l10n.deleteConfirmTitle),
  content: Text(l10n.deleteConfirmMessage),
  actions: [
    TextButton(onPressed: pop, child: Text(l10n.cancel)),
    DeleteTimeButton(time: time),  // reuse existing widget
  ],
)
```

## Verification

**Commands:**
- `flutter analyze` -- expected: zero warnings/errors
- `flutter test --test-randomize-ordering-seed random` -- expected: all tests pass
- `flutter test --update-goldens test/goldens/` -- expected: baselines regenerated
- `flutter test test/goldens/` -- expected: golden comparison passes
