# Source Tree Analysis - TimeMoney

> Generated: 2026-03-16 | Scan Level: Exhaustive

## Annotated Directory Tree

```
TimeMoney/
├── lib/                              # Main Dart source code
│   ├── main_development.dart         # 🚀 Entry point: Development (ObjectBox db: test-1)
│   ├── main_staging.dart             # 🚀 Entry point: Staging (ObjectBox db: stg-1)
│   ├── main_production.dart          # 🚀 Entry point: Production (ObjectBox db: prod-1)
│   ├── bootstrap.dart                # App initialization, error handling, BlocObserver
│   ├── objectbox.g.dart              # ⚙️ Generated: ObjectBox model definitions
│   ├── app/                          # Application root module
│   │   ├── app.dart                  # Barrel export
│   │   └── view/
│   │       ├── app.dart              # MaterialApp with Material3, theme, localization
│   │       └── app_bloc.dart         # DI setup: MultiRepositoryProvider + MultiBlocProvider
│   ├── l10n/                         # Localization
│   │   ├── l10n.dart                 # Extension: context.l10n convenience accessor
│   │   └── arb/
│   │       ├── app_en.arb            # English strings
│   │       └── app_es.arb            # Spanish strings
│   └── src/                          # Feature source code
│       ├── core/                     # Shared core utilities
│       │   ├── break_points.dart     # Responsive breakpoints (mobile/tablet/desktop)
│       │   ├── screen_type.dart      # ScreenType enum + extensions
│       │   ├── extensions/
│       │   │   ├── declarative_bool.dart  # when()/whenOrNull() on bool
│       │   │   └── screen_size.dart       # Context extensions: isMobile, getWidth, etc.
│       │   ├── failures/
│       │   │   ├── failures.dart          # Freezed: ValueFailure, GlobalFailure unions
│       │   │   └── failures.freezed.dart  # ⚙️ Generated
│       │   ├── services/
│       │   │   └── objectbox.dart         # ObjectBox wrapper: Store, Boxes, Streams
│       │   └── unions/
│       │       ├── action_state.dart      # Freezed: ActionState<T> (initial/loading/success/error)
│       │       └── action_state.freezed.dart  # ⚙️ Generated
│       ├── features/                 # Business features (Clean Architecture)
│       │   ├── times/                # ── FEATURE: Time Entry Management ──
│       │   │   ├── domain/
│       │   │   │   ├── model_time.dart        # ModelTime entity + CalculatePay extension
│       │   │   │   ├── model_time.freezed.dart # ⚙️ Generated
│       │   │   │   ├── model_time.g.dart       # ⚙️ Generated (JSON)
│       │   │   │   └── times_repository.dart   # Abstract TimesRepository interface
│       │   │   ├── aplication/
│       │   │   │   ├── aplications.dart              # Barrel export
│       │   │   │   ├── create_time_use_case.dart     # CreateTimeUseCase
│       │   │   │   ├── delete_time_use_case.dart     # DeleteTimeUseCase
│       │   │   │   ├── list_times_use_case.dart      # ListTimesUseCase (stream)
│       │   │   │   ├── update_time_use_case.dart     # UpdateTimeUseCase
│       │   │   │   └── times_use_cases_injection.dart # DI: RepositoryProvider list
│       │   │   └── infraestructure/
│       │   │       ├── i_times_objectbox_repository.dart  # ObjectBox implementation
│       │   │       └── timebox.dart                       # TimeBox entity + converters
│       │   └── wage_hourly/          # ── FEATURE: Hourly Wage Management ──
│       │       ├── domain/
│       │       │   ├── wage_hourly.dart            # WageHourly entity (default: 15.0)
│       │       │   ├── wage_hourly.freezed.dart    # ⚙️ Generated
│       │       │   ├── wage_hourly.g.dart          # ⚙️ Generated (JSON)
│       │       │   └── wage_hourly_repository.dart # Abstract WageHourlyRepository
│       │       ├── aplication/
│       │       │   ├── fetch_wage_hourly_use_case.dart       # FetchWageHourlyUseCase (stream)
│       │       │   ├── set_wage_hourly_use_case.dart         # SetWageHourlyUseCase (init)
│       │       │   ├── update_wage_hourly_use_case.dart      # UpdateWageHourlyUseCase
│       │       │   └── wage_hourly_use_cases_injections.dart # DI: RepositoryProvider list
│       │       └── infraestructure/
│       │           ├── i_wage_hourly_objectbox_repository.dart # ObjectBox implementation
│       │           └── wage_hourly_box.dart                    # WageHourlyBox entity + converters
│       ├── presentation/             # UI Layer
│       │   ├── control_hours/        # Main feature screen
│       │   │   ├── control_hours_page.dart       # 📱 Main page: Scaffold with wage, times, actions
│       │   │   ├── result_payment/               # Payment calculation feature
│       │   │   │   ├── calculate_payment_button.dart  # FAB: triggers payment dialog
│       │   │   │   ├── result_screen.dart             # AlertDialog: payment results
│       │   │   │   ├── result_payment_cubits.dart     # BlocProvider for ResultPaymentCubit
│       │   │   │   └── cubit/
│       │   │   │       ├── result_payment_cubit.dart       # Cubit: manages times + wage data
│       │   │   │       ├── result_payment_state.dart       # State: times list + wageHourly
│       │   │   │       └── result_payment_cubit.freezed.dart # ⚙️ Generated
│       │   │   ├── times/                        # Time entries CRUD UI
│       │   │   │   ├── times_blocs.dart          # BlocProvider aggregation for all time blocs
│       │   │   │   ├── create_time/              # Create time entry
│       │   │   │   │   ├── bloc/                 # CreateTimeBloc (event/state/bloc)
│       │   │   │   │   ├── create_time_view.dart # AlertDialog wrapper
│       │   │   │   │   └── widgets/              # Hour/Minutes fields, button, card
│       │   │   │   ├── delete_time/              # Delete time entry
│       │   │   │   │   ├── bloc/                 # DeleteTimeBloc (event/state/bloc)
│       │   │   │   │   └── widgets/              # DeleteTimeButton (red)
│       │   │   │   ├── list_times/               # List time entries
│       │   │   │   │   ├── bloc/                 # ListTimesBloc (event/state/bloc)
│       │   │   │   │   ├── list_times_page.dart   # State-based page rendering
│       │   │   │   │   ├── views/                # Data, error, shimmer, empty views
│       │   │   │   │   └── widgets/              # TimeCard, InfoTime, EditButton
│       │   │   │   └── update_time/              # Update time entry
│       │   │   │       ├── bloc/                 # UpdateTimeBloc (event/state/bloc)
│       │   │   │       ├── update_view.dart      # AlertDialog: update + delete actions
│       │   │   │       └── widgets/              # Hour/Minutes fields, button, card
│       │   │   └── wage_hourly/                  # Wage management UI
│       │   │       ├── wage_hourly_blocs.dart    # BlocProvider aggregation
│       │   │       ├── fetch_wage/               # Display current wage
│       │   │       │   ├── bloc/                 # FetchWageHourlyBloc
│       │   │       │   ├── fetch_wage_page.dart   # State-based page rendering
│       │   │       │   ├── views/                # Data, error, shimmer, empty views
│       │   │       │   └── widgets/              # WageHourlyCard, WageHourlyInfo, UpdateButton
│       │   │       └── update_wage/              # Update hourly wage
│       │   │           ├── bloc/                 # UpdateWageHourlyBloc
│       │   │           ├── wage_hourly_view.dart # AlertDialog wrapper
│       │   │           └── widgets/              # WageHourlyField, SetWageButton
│       │   └── widgets/              # Shared presentation widgets
│       │       ├── widgets.dart      # Barrel export
│       │       ├── catch_error_builder.dart  # Generic AsyncSnapshot error handler
│       │       ├── custom_card.dart          # Reusable card template (unused)
│       │       ├── info_section.dart         # ShowInfoSection + IconText
│       │       └── views/
│       │           └── error_view.dart       # Pattern-matched error display
│       └── shared/                   # Shared utilities
│           ├── consts/
│           │   └── consts.dart       # Consts.delayed (500ms Future)
│           └── injections/
│               ├── bloc_injections.dart          # Central BlocProvider aggregation
│               ├── injection_repositories.dart   # Repository DI container
│               └── use_cases_injection.dart      # UseCases DI orchestration
├── test/                             # Test suite
│   └── helpers/
│       ├── helpers.dart              # Barrel export
│       └── pump_app.dart             # pumpApp() extension with localization
├── android/                          # Android platform files
├── ios/                              # iOS platform files
├── web/                              # Web platform files
├── windows/                          # Windows platform files
├── pubspec.yaml                      # Dart/Flutter package manifest
├── pubspec.lock                      # Dependency lock file
├── analysis_options.yaml             # Linting: very_good_analysis v4
├── l10n.yaml                         # Localization configuration
├── coverage_badge.svg                # Coverage badge
├── README.md                         # Project documentation
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md      # PR template with checklist
│   ├── dependabot.yaml               # Daily dependency updates
│   ├── cspell.json                   # Spell-check configuration
│   └── workflows/
│       └── main.yaml                 # CI: build, semantic PR, spell-check
└── design-artifacts/                 # Design assets (empty/placeholder)
```

## Critical Folders

| Folder | Purpose | Key Files |
|--------|---------|-----------|
| `lib/` | All application source code | Entry points, bootstrap, features |
| `lib/src/core/` | Cross-cutting concerns | Failures, ObjectBox service, ActionState, responsive utils |
| `lib/src/features/times/` | Time entry management feature | CRUD operations with ObjectBox persistence |
| `lib/src/features/wage_hourly/` | Hourly wage management feature | Fetch/set/update wage with ObjectBox |
| `lib/src/presentation/` | UI layer with BLoC integration | Pages, views, widgets, blocs |
| `lib/src/shared/` | Dependency injection and constants | BlocInjections, UseCasesInjection |
| `test/` | Test suite | Helper utilities (minimal test coverage) |
| `.github/` | CI/CD and project configuration | Workflows, Dependabot, spell-check |

## Entry Points

| Entry Point | Environment | ObjectBox DB Name |
|-------------|-------------|-------------------|
| `lib/main_development.dart` | Development | `test-1` |
| `lib/main_staging.dart` | Staging | `stg-1` |
| `lib/main_production.dart` | Production | `prod-1` |
