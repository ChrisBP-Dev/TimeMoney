# Source Tree Analysis - TimeMoney

> Generated: 2026-03-23 | Scan Level: Exhaustive | Mode: Full Rescan

## Project Root

```
TimeMoney/
├── .github/
│   ├── workflows/
│   │   └── main.yaml                # CI/CD pipeline (8 jobs)
│   ├── cspell.json                   # Spell check configuration (200+ terms)
│   ├── dependabot.yaml               # Daily dependency updates (github-actions + pub)
│   └── PULL_REQUEST_TEMPLATE.md      # PR checklist template
├── android/                          # Android platform config
├── ios/                              # iOS platform config
├── web/                              # Web platform config (WASM/OPFS)
├── windows/                          # Windows platform config
├── lib/                              # Application source code
├── test/                             # Test suite (373 tests across 70 files)
├── docs/                             # Project documentation (AI context)
├── coverage/                         # Test coverage reports
├── design-artifacts/                 # UX/design deliverables (Product Brief, PRD, etc.)
├── _bmad/                            # BMad method framework
├── _bmad-output/                     # BMad planning & implementation artifacts
├── analysis_options.yaml             # Linting (very_good_analysis ^10.2.0)
├── build.yaml                        # Freezed code generation options (when/map enabled)
├── dart_test.yaml                    # Test tag definitions (golden tag)
├── pubspec.yaml                      # Dependencies & project config
├── objectbox-model.json              # ObjectBox schema definition
├── l10n.yaml                         # Localization configuration
├── time-money-logo.png               # Custom app icon source image
├── flutter_launcher_icons-development.yaml  # Icon config: development flavor (iOS + Android)
├── flutter_launcher_icons-staging.yaml      # Icon config: staging flavor (iOS + Android)
├── flutter_launcher_icons-production.yaml   # Icon config: production flavor (all platforms)
├── coverage_badge.svg                # Coverage badge for README
├── LICENSE                           # MIT License (2023-2026)
└── README.md                         # Professional project overview
```

## lib/ Directory (Application Source)

```
lib/
├── main_development.dart             # Entry point: development flavor
├── main_staging.dart                 # Entry point: staging flavor
├── main_production.dart              # Entry point: production flavor
├── bootstrap.dart                    # Core bootstrap logic
│                                     #   - AppBlocObserver
│                                     #   - _AppLifecycleObserver (DB cleanup)
│                                     #   - bootstrap() function
│                                     #   - _BootstrapErrorApp (fallback UI)
├── bootstrap_repositories_native.dart # ObjectBox repository factory
├── bootstrap_repositories_web.dart    # Drift repository factory
├── objectbox.g.dart                  # ObjectBox generated model binding
├── app/
│   ├── app.dart                      # App barrel export
│   └── view/
│       ├── app.dart                  # MaterialApp configuration
│       └── app_bloc.dart             # Top-level DI wiring
│                                     #   - LocaleCubit
│                                     #   - MultiRepositoryProvider
│                                     #   - MultiBlocProvider
├── l10n/
│   ├── l10n.dart                     # Localization barrel
│   ├── arb/
│   │   ├── app_en.arb                # English strings
│   │   └── app_es.arb                # Spanish strings
│   └── gen/                          # Generated localization code
│       ├── app_localizations.dart
│       ├── app_localizations_en.dart
│       └── app_localizations_es.dart
└── src/                              # Feature-first source tree
    ├── core/                         # Cross-cutting concerns (17 files)
    ├── features/                     # Feature modules (107 files)
    └── shared/                       # Cross-feature utilities (7 files)
```

## lib/src/core/ — Cross-Cutting Concerns

```
core/
├── constants/
│   ├── app_durations.dart            # Animation timing (actionFeedback: 400ms)
│   ├── break_points.dart             # Responsive design breakpoints
│   └── constants.dart                # Barrel export
├── errors/
│   ├── failures.dart                 # GlobalFailure + ValueFailure sealed classes
│   │                                 #   GlobalFailure: ServerError, NotConnection,
│   │                                 #     TimeOutExceeded, InternalError
│   │                                 #   ValueFailure: CharacterLimitExceeded,
│   │                                 #     ShortOrNullCharacters, InvalidFormat
│   └── errors.dart                   # Barrel export
├── extensions/
│   ├── declarative_bool.dart         # Boolean UI helpers
│   ├── screen_size.dart              # Device dimension utilities
│   ├── screen_type.dart              # Platform type detection (isMobile, getWidth)
│   └── extensions.dart               # Barrel export
├── locale/
│   ├── locale_cubit.dart             # Runtime locale switching Cubit
│   ├── locale_state.dart             # Locale state definition
│   └── locale.dart                   # Barrel export
├── services/
│   ├── objectbox_service.dart        # ObjectBox store initialization (async factory)
│   ├── app_database.dart             # Drift database (AppDatabase with all tables)
│   │                                 #   @DriftDatabase(tables: [TimesTable, WageHourlyTable])
│   └── services.dart                 # Barrel export
└── ui/
    ├── action_state.dart             # ActionState<T> sealed class
    │                                 #   ActionInitial, ActionLoading,
    │                                 #   ActionSuccess(data), ActionError(failure)
    │                                 #   Boolean getters: isInitial, isLoading, etc.
    └── ui.dart                       # Barrel export
```

## lib/src/features/ — Feature Modules

### Times Feature (51 files — largest feature)

```
times/
├── data/
│   ├── datasources/
│   │   ├── times_objectbox_datasource.dart  # ObjectBox CRUD operations
│   │   ├── times_drift_datasource.dart      # Drift CRUD operations
│   │   └── datasources.dart
│   ├── models/
│   │   ├── time_box.dart                    # ObjectBox entity (@Entity)
│   │   ├── times_table.dart                 # Drift table definition
│   │   └── models.dart
│   └── repositories/
│       ├── objectbox_times_repository.dart   # ObjectBox → TimesRepository
│       ├── drift_times_repository.dart       # Drift → TimesRepository
│       └── repositories.dart
├── domain/
│   ├── entities/
│   │   ├── time_entry.dart                  # Freezed entity + CalculatePay ext
│   │   └── entities.dart
│   ├── repositories/
│   │   ├── times_repository.dart            # Abstract interface
│   │   └── repositories.dart
│   └── use_cases/
│       ├── create_time_use_case.dart
│       ├── list_times_use_case.dart
│       ├── update_time_use_case.dart
│       ├── delete_time_use_case.dart
│       └── use_cases.dart
├── presentation/
│   ├── bloc/                                # 14 files (4 BLoCs x 3 + 2 barrels)
│   │   ├── create_time_bloc.dart
│   │   ├── create_time_event.dart
│   │   ├── create_time_state.dart
│   │   ├── list_times_bloc.dart
│   │   ├── list_times_event.dart
│   │   ├── list_times_state.dart
│   │   ├── update_time_bloc.dart
│   │   ├── update_time_event.dart
│   │   ├── update_time_state.dart
│   │   ├── delete_time_bloc.dart
│   │   ├── delete_time_event.dart
│   │   ├── delete_time_state.dart
│   │   ├── times_blocs.dart                 # Static list() injection helper
│   │   └── bloc.dart
│   ├── pages/
│   │   ├── create_time_page.dart            # Dialog for creating time entry
│   │   ├── list_times_page.dart             # Main time list view
│   │   ├── update_time_page.dart            # Dialog for updating time entry
│   │   └── pages.dart
│   └── widgets/                             # 21 widget files
│       ├── create_hour_field.dart
│       ├── create_minutes_field.dart
│       ├── create_time_button.dart
│       ├── create_time_card.dart
│       ├── custom_create_field.dart
│       ├── custom_info.dart
│       ├── custom_update_field.dart
│       ├── delete_time_button.dart
│       ├── delete_time_confirmation_dialog.dart
│       ├── edit_button.dart
│       ├── error_list_times_view.dart
│       ├── info_time.dart
│       ├── list_times_data_view.dart
│       ├── list_times_other_view.dart
│       ├── time_card.dart
│       ├── update_hour_field.dart
│       ├── update_minutes_field.dart
│       ├── update_time_button.dart
│       ├── update_time_card.dart
│       └── widgets.dart
└── times_injection.dart                     # Use case provider registration
```

### Wage Feature (35 files)

```
wage/
├── data/
│   ├── datasources/
│   │   ├── wage_objectbox_datasource.dart
│   │   ├── wage_drift_datasource.dart
│   │   └── datasources.dart
│   ├── models/
│   │   ├── wage_hourly_box.dart             # ObjectBox entity
│   │   ├── wage_hourly_table.dart           # Drift table
│   │   └── models.dart
│   └── repositories/
│       ├── objectbox_wage_repository.dart
│       ├── drift_wage_repository.dart
│       └── repositories.dart
├── domain/
│   ├── entities/
│   │   ├── wage_hourly.dart                 # Freezed entity
│   │   └── entities.dart
│   ├── repositories/
│   │   ├── wage_repository.dart             # Abstract interface
│   │   └── repositories.dart
│   └── use_cases/
│       ├── fetch_wage_use_case.dart
│       ├── set_wage_use_case.dart
│       ├── update_wage_use_case.dart
│       └── use_cases.dart
├── presentation/
│   ├── bloc/
│   │   ├── fetch_wage_bloc.dart
│   │   ├── fetch_wage_event.dart
│   │   ├── fetch_wage_state.dart
│   │   ├── update_wage_bloc.dart
│   │   ├── update_wage_event.dart
│   │   ├── update_wage_state.dart
│   │   ├── wage_blocs.dart
│   │   └── bloc.dart
│   ├── pages/
│   │   ├── fetch_wage_page.dart
│   │   ├── update_wage_page.dart
│   │   └── pages.dart
│   └── widgets/
│       ├── error_fetch_wage_hourly_view.dart
│       ├── set_wage_button.dart
│       ├── update_wage_button.dart
│       ├── wage_hourly_card.dart
│       ├── wage_hourly_field.dart
│       ├── wage_hourly_info.dart
│       ├── wage_hourly_other_view.dart
│       └── widgets.dart
└── wage_injection.dart
```

### Payment Feature (9 files)

```
payment/
├── domain/
│   ├── entities/
│   │   └── payment_result.dart              # Immutable result class
│   └── use_cases/
│       ├── calculate_payment_use_case.dart
│       └── use_cases.dart
└── presentation/
    ├── cubit/
    │   ├── payment_cubit.dart               # Cross-feature Cubit
    │   ├── payment_state.dart
    │   ├── payment_cubits.dart
    │   └── cubit.dart
    └── pages/
        ├── payment_result_page.dart
        └── pages.dart
```

### Home Feature (6 files)

```
home/
└── presentation/
    ├── pages/
    │   ├── home_page.dart                   # Main app screen
    │   └── pages.dart
    └── widgets/
        ├── calculate_payment_button.dart
        └── widgets.dart
```

## lib/src/shared/ — Cross-Feature Utilities

```
shared/
├── injections/
│   ├── bloc_injections.dart                 # MultiBlocProvider aggregation
│   └── use_cases_injection.dart             # MultiRepositoryProvider aggregation
└── widgets/
    ├── catch_error_builder.dart             # Error catching wrapper
    ├── error_view.dart                      # GlobalFailure display
    ├── icon_text.dart                       # Icon + text widget
    ├── info_section.dart                    # Info layout with spacers
    └── widgets.dart                         # Barrel export
```

## test/ Directory

```
test/
├── helpers/
│   ├── mocks.dart                           # Centralized mocks (MockBloc, Mock)
│   ├── pump_app.dart                        # pumpApp() extension for widget tests
│   └── helpers.dart                         # Test helpers barrel
├── goldens/                                 # Golden test baselines + tests (4)
│   ├── create_time_dialog_golden_test.dart
│   ├── home_page_golden_test.dart
│   ├── payment_result_page_golden_test.dart
│   ├── update_time_dialog_golden_test.dart
│   └── *.png                               # Baseline images
└── src/                                     # Mirrors lib/src/ structure
    ├── core/                                # Core tests (errors, locale, services, ui)
    ├── features/
    │   ├── home/                            # Home tests (2)
    │   ├── payment/                         # Payment tests (4)
    │   ├── times/                           # Times tests (34)
    │   └── wage/                            # Wage tests (24)
    └── shared/                              # Shared widget tests (4)
```

## Critical Files

| File | Purpose |
|---|---|
| `pubspec.yaml` | Dependencies, SDK constraints, flavor config |
| `analysis_options.yaml` | Linting rules (very_good_analysis, public_member_api_docs) |
| `build.yaml` | Freezed code generation options (when/map methods enabled) |
| `dart_test.yaml` | Test tag definitions (golden tag for golden tests) |
| `objectbox-model.json` | ObjectBox schema (auto-generated, committed) |
| `l10n.yaml` | Localization configuration (ARB source, output dir) |
| `time-money-logo.png` | Custom app icon source image for flutter_launcher_icons |
| `flutter_launcher_icons-*.yaml` | Per-flavor icon generation configs (3 files) |
| `.github/workflows/main.yaml` | CI/CD pipeline definition (8 jobs) |
| `.github/cspell.json` | Spell check dictionary (200+ terms) |
| `lib/bootstrap.dart` | Application initialization and lifecycle |
