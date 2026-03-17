# Development Guide - TimeMoney

> Generated: 2026-03-16 | Scan Level: Exhaustive

## Prerequisites

| Requirement | Version | Notes |
|-------------|---------|-------|
| Dart SDK | >=2.19.2 <3.0.0 | |
| Flutter | 3.7.5 | Stable channel |
| IDE | VS Code or Android Studio | Launch configurations included |
| Xcode | Latest | For iOS development |
| Android Studio | Latest | For Android development |

## Installation

```sh
# Clone the repository
git clone <repository-url>
cd TimeMoney

# Install dependencies
flutter pub get

# Generate code (Freezed, JSON serializable, ObjectBox)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Running the App

The project has three flavors with separate database instances:

```sh
# Development (ObjectBox db: test-1)
flutter run --flavor development --target lib/main_development.dart

# Staging (ObjectBox db: stg-1)
flutter run --flavor staging --target lib/main_staging.dart

# Production (ObjectBox db: prod-1)
flutter run --flavor production --target lib/main_production.dart
```

## Supported Platforms

- iOS
- Android
- Web
- Windows

## Running Tests

```sh
# Run all tests with coverage
flutter test --coverage --test-randomize-ordering-seed random

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/

# Open coverage report
open coverage/index.html
```

## Code Generation

The project uses `build_runner` for code generation:

```sh
# One-time build
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (regenerates on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

**Generated files** (do not edit manually):
- `*.freezed.dart` - Freezed immutable classes and union types
- `*.g.dart` - JSON serialization code
- `lib/objectbox.g.dart` - ObjectBox model definitions

## Linting

```sh
# Run analyzer
flutter analyze

# Linting configuration
# Uses very_good_analysis v4 (strict rules)
# See analysis_options.yaml for overrides
```

**Analyzer Exclusions**:
- `**/**.g.dart` - Generated code
- `**/generated_plugin_registrant.dart` - Flutter generated
- `**/**.freezed.dart` - Freezed generated
- `**.yaml` - YAML files

## Localization

**Configuration**: `l10n.yaml`
- ARB directory: `lib/l10n/arb/`
- Template: `app_en.arb`
- Output: `app_localizations.dart`

**Supported Locales**: English (en), Spanish (es)

### Adding New Strings

1. Add key/value to `lib/l10n/arb/app_en.arb`:
```json
{
    "newKey": "English value",
    "@newKey": {
        "description": "Description of the string"
    }
}
```

2. Add translation to `lib/l10n/arb/app_es.arb`:
```json
{
    "newKey": "Spanish value"
}
```

3. Use in code:
```dart
import 'package:time_money/l10n/l10n.dart';

final l10n = context.l10n;
Text(l10n.newKey);
```

### Adding New Locales

1. Create new ARB file: `lib/l10n/arb/app_<locale>.arb`
2. Update iOS `Info.plist` `CFBundleLocalizations` array

## Project Structure Conventions

### Feature Organization

Each feature follows Clean Architecture:
```
lib/src/features/<feature_name>/
├── domain/           # Entities + Repository interfaces
├── aplication/       # Use cases + DI injection
└── infraestructure/  # Repository implementations + DB entities
```

### Presentation Organization

Each UI feature follows:
```
lib/src/presentation/<feature>/
├── bloc/             # BLoC (event + state + bloc)
├── views/            # State-specific views (data, error, loading, empty)
└── widgets/          # Reusable UI components
```

### Naming Conventions

- **BLoC files**: `<name>_bloc.dart`, `<name>_event.dart`, `<name>_state.dart`
- **Use cases**: `<action>_<entity>_use_case.dart`
- **Repositories**: `<entity>_repository.dart` (interface), `i_<entity>_objectbox_repository.dart` (implementation)
- **ObjectBox entities**: `<name>box.dart`
- **Barrel exports**: `widgets.dart`, `views.dart`, `aplications.dart`

## CI/CD

**Platform**: GitHub Actions (`.github/workflows/main.yaml`)

**Jobs**:
1. `semantic-pull-request` - Validates PR titles follow conventional commits
2. `build` - Runs Flutter build and tests via VGV reusable workflow
3. `spell-check` - Checks spelling in all `.md` files

**Triggers**: Push to `main`, PRs targeting `main`

**Dependency Management**: Dependabot configured for daily updates on:
- GitHub Actions workflows
- Pub (Dart) dependencies

## Common Development Tasks

### Adding a New Feature

1. Create domain layer:
   - Entity (Freezed model) in `domain/`
   - Repository interface in `domain/`
2. Create application layer:
   - Use cases in `aplication/`
   - DI injection class in `aplication/`
3. Create infrastructure layer:
   - ObjectBox entity in `infraestructure/`
   - Repository implementation in `infraestructure/`
4. Create presentation layer:
   - BLoC (event, state, bloc) in `presentation/<feature>/bloc/`
   - Views (data, error, loading) in `views/`
   - Widgets in `widgets/`
5. Register in DI:
   - Add use cases to `UseCasesInjection`
   - Add blocs to `BlocInjections`
   - Add repository to `InjectionRepositories`
6. Run code generation: `flutter pub run build_runner build`

### Adding a New ObjectBox Entity

1. Create entity class with `@Entity()` annotation and `@Id()` field
2. Create converter extensions (toFreezed... / to...Box)
3. Run code generation to update `objectbox.g.dart`
4. Add Box to `ObjectBox` service class
