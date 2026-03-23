# Development Guide - TimeMoney

> Generated: 2026-03-23 | Scan Level: Exhaustive | Mode: Full Rescan

## Prerequisites

| Requirement | Version |
|---|---|
| Flutter | 3.41+ |
| Dart SDK | >=3.11.0 <4.0.0 |
| Java (Android) | 17 |
| Xcode (iOS) | Latest stable |
| Browser (Web) | Modern with OPFS support |

## Setup

```bash
# Clone the repository
git clone https://github.com/ChrisBP-Dev/TimeMoney.git
cd TimeMoney

# Install dependencies
flutter pub get

# Generate code (Freezed, ObjectBox, Drift, JSON)
dart run build_runner build --delete-conflicting-outputs
```

## Running the App

The project uses flavor-specific entry points. There is no `lib/main.dart`.

```bash
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

### Platform-Specific Notes

- **Web/Windows:** Use `--target` only (no `--flavor` needed)
- **Android:** Requires Java 17 (`actions/setup-java` with `temurin` distribution in CI)
- **iOS:** Requires Xcode, builds with `--no-codesign` in CI

### Environment-Isolated Databases

Each flavor uses a separate database name to prevent data conflicts:

| Flavor | Database Name |
|---|---|
| Development | `test-1` |
| Staging | `stg-1` |
| Production | `prod-1` |

## Testing

```bash
# Run all tests with coverage and random ordering
flutter test --coverage --test-randomize-ordering-seed random

# Run only golden tests
flutter test --tags golden

# Run excluding golden tests (CI on non-macOS)
flutter test --test-randomize-ordering-seed random --exclude-tags golden

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/
open coverage/index.html

# Update golden test baselines
flutter test --update-goldens test/goldens/
```

### Test Structure

| Category | Count | Framework | Location |
|---|---|---|---|
| Unit (use cases, repositories) | ~80 | flutter_test + mocktail | `test/src/**/domain/`, `test/src/**/data/` |
| BLoC | ~50 | bloc_test | `test/src/**/presentation/bloc/` |
| Widget | ~230 | flutter_test | `test/src/**/presentation/` |
| Golden | 8 (4 files) | flutter_test (matchesGoldenFile) | `test/goldens/` |
| **Total** | **373** | | |

### Test Helpers

- **`pumpApp(widget)`** — Wraps widget with localization and required providers
- **`pumpGoldenApp(widget, size)`** — Sets devicePixelRatio=1.0, fixed viewport, M3 theme
- **`buildSubject()`** — Centralized widget composition convention
- **Centralized mocks** — All mocks in `test/helpers/mocks.dart`

### Test Conventions

- Mirror source path: `lib/src/.../file.dart` → `test/src/.../file_test.dart`
- `group('ClassName', () { ... })` wrapping related tests
- `late` variables initialized in `setUp()`
- `const` test fixtures at top-level
- `verify(() => mock.method(args)).called(1)` after assertions
- Drift tests use `NativeDatabase.memory()` for fast isolated testing

## Code Generation

Run after modifying Freezed, ObjectBox, or Drift entities:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run after modifying `.arb` localization files:

```bash
flutter gen-l10n
```

## Code Quality

### Linting

```bash
# Static analysis (zero warnings policy)
flutter analyze --fatal-infos

# Format check
dart format --output=none --set-exit-if-changed .

# Auto-format
dart format .
```

### Rules

- **Linter:** `very_good_analysis` ^10.2.0 (strict)
- **Dartdoc:** `public_member_api_docs` enabled — all public APIs require `///` comments
- **Generated files excluded:** `*.g.dart`, `*.freezed.dart`, `generated_plugin_registrant.dart`
- **Zero warnings policy:** `flutter analyze --fatal-infos` must pass clean

### Spell Check

```bash
# Check all markdown files (uses .github/cspell.json config)
npx cspell --config .github/cspell.json **/*.md
```

## CI/CD Pipeline

GitHub Actions pipeline (`.github/workflows/main.yaml`) runs on push to `main` and PRs:

| Job | Runner | Purpose |
|---|---|---|
| semantic-pull-request | (PR only) | Validates conventional commit PR titles |
| quality | ubuntu-latest | Format + analyze + tests + coverage |
| test-goldens | macos-latest | Golden tests (font rendering consistency) |
| build-android | ubuntu-latest | APK build (Java 17, debug signing) |
| build-ios | macos-latest | iOS build (no codesign) |
| build-web | ubuntu-latest | Web release build |
| build-windows | windows-latest | Windows release build |
| spell-check | (VGV workflow) | cspell on all .md files |

## Coding Standards

### Naming Conventions

| Element | Pattern | Example |
|---|---|---|
| Files | snake_case with type suffix | `create_time_bloc.dart` |
| Classes | PascalCase | `CreateTimeBloc` |
| BLoCs | `{Action}{Feature}Bloc` | `DeleteTimeBloc` |
| Cubits | `{Feature}Cubit` | `PaymentCubit` |
| Use Cases | `{Action}{Feature}UseCase` | `ListTimesUseCase` |
| Repositories (interface) | `{Feature}Repository` | `TimesRepository` |
| Repositories (ObjectBox) | `ObjectBox{Feature}Repository` | `ObjectBoxTimesRepository` |
| Repositories (Drift) | `Drift{Feature}Repository` | `DriftTimesRepository` |
| Datasources | `{Feature}{Platform}Datasource` | `TimesDriftDatasource` |
| ObjectBox models | `{Feature}Box` | `TimeBox` |
| Drift tables | `{Feature}Table` | `TimesTable` |
| Barrel files | Named after folder content | `entities.dart`, `use_cases.dart` |

### Import Order

1. `dart:` (core libraries)
2. `package:` (external packages)
3. `package:time_money/` (project imports)

Always use absolute imports (`package:time_money/...`), never relative imports.

### Commit Conventions

| Prefix | Usage |
|---|---|
| `feat:` | New features |
| `fix:` | Bug fixes |
| `refactor:` | Code improvements |
| `docs:` | Documentation |
| `chore:` | Admin/reviews |

### Architecture Rules

- **BLoC for complex flows, Cubit for simple state**
- **Sealed classes for BLoC states/events** (not Freezed)
- **Freezed for domain entities only** (TimeEntry, WageHourly)
- **Either<GlobalFailure, T> for all repository returns** (fpdart)
- **Never throw from repositories** — catch with `on Object catch (e)` and wrap
- **Tests ship with implementation** — never deferred
- **Conditional imports for platform DI** — never runtime `kIsWeb` checks
