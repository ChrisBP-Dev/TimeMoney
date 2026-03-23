# TimeMoney

[![CI][ci_badge]][ci_link]
[![coverage][coverage_badge]][ci_link]
[![Dart SDK][dart_badge]][dart_link]
[![Flutter][flutter_badge]][flutter_link]
[![License: MIT][license_badge]][license_link]
[![style: very good analysis][vga_badge]][vga_link]

A Flutter application for hourly workers to track work hours and calculate payments across iOS, Android, Web, and Windows.

## Demo

https://user-images.githubusercontent.com/80471939/222861291-6728b069-f92f-4be1-a707-a0ad9c2dda68.mp4

## Project Overview

TimeMoney is a cross-platform time and payment tracker built for hourly workers. Users can log work hours, configure hourly wages, and instantly calculate payments with bilingual support (English and Spanish).

This project represents a **real brownfield modernization** of a 3-year-old Flutter codebase, upgraded from Dart 2.x to 3.11+ with professional-grade standards. Unlike tutorial apps, TimeMoney demonstrates practical migration decisions: feature-first Clean Architecture, dual datasource persistence (ObjectBox for native + Drift for web), BLoC 9.x with sealed classes, and comprehensive testing with 373 tests at 92.3% coverage.

The modernization was AI-assisted using the [BMad Method][bmad_link] + Claude Code, following a structured 6-epic migration from SDK foundation through CI/CD pipeline and documentation polish. See [Modernization Methodology](#modernization-methodology) for the full process.

## Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter 3.41+ / Dart 3.11+ |
| State Management | BLoC 9.x (sealed classes) |
| Domain Entities | Freezed 3.x |
| Error Handling | fpdart (Either monad) |
| Persistence (native) | ObjectBox 5.x (iOS, Android, Windows) |
| Persistence (web) | Drift 2.32+ (SQLite via WASM + OPFS) |
| Linting | very_good_analysis ^10.2.0 (strict) |
| Testing | 373 tests / 92.3% coverage |
| i18n | intl (English, Spanish) |
| CI/CD | GitHub Actions (8-job pipeline) |

## Architecture

TimeMoney follows **feature-first Clean Architecture** with dual datasource support:

```
+---------------------------------------------------+
|              PRESENTATION LAYER                    |
|   BLoC/Cubit  |  Pages  |  Widgets                |
+---------------------------------------------------+
|               DOMAIN LAYER                         |
|   Entities (Freezed)  |  Repository Interfaces     |
|   Use Cases (single-responsibility)                |
+---------------------------------------------------+
|                DATA LAYER                          |
|   +--------------+  +------------------------+    |
|   |   ObjectBox   |  |       Drift            |    |
|   |  (iOS/Android |  |  (Web - SQLite via     |    |
|   |   /Windows)   |  |   WASM + OPFS)         |    |
|   +--------------+  +------------------------+    |
+---------------------------------------------------+
|                CORE LAYER                          |
|   Errors | Services | Extensions | Constants       |
+---------------------------------------------------+
```

### Project Structure

```
lib/src/
├── core/
│   ├── constants/       # AppDurations, app constants
│   ├── errors/          # GlobalFailure + ValueFailure sealed classes
│   ├── extensions/      # Context utilities (isMobile, getWidth)
│   ├── locale/          # i18n configuration
│   ├── services/        # ObjectBox Store + Drift Database init
│   └── ui/              # ActionState<T> reusable sealed class
├── features/
│   ├── home/            # Main app screen
│   ├── payment/         # Payment calculation (PaymentCubit)
│   ├── times/           # Time entry CRUD (BLoC + reactive streams)
│   └── wage/            # Hourly wage management (Cubit)
└── shared/              # Cross-feature shared widgets/utilities
```

Data-intensive features (times, wage) follow: `data/datasources/`, `data/repositories/`, `domain/entities/`, `domain/repositories/`, `domain/use_cases/`, `presentation/bloc/`, `presentation/pages/`, `presentation/widgets/`. Simpler features (home, payment) use only the layers they need.

## Features

- Time entry CRUD with reactive streams
- Wage management with persistent storage
- Automatic payment calculation
- Bilingual i18n (English / Spanish)
- 4-platform support (iOS, Android, Web, Windows)
- Platform-aware DI (ObjectBox native / Drift web)
- 3-environment configuration (development, staging, production)

## Getting Started

### Prerequisites

- Flutter 3.41+ / Dart SDK >=3.11.0
- Android: Java 17
- iOS: Xcode (latest stable)
- Web: Modern browser with OPFS support

### Setup

```bash
# Clone the repository
git clone https://github.com/ChrisBP-Dev/TimeMoney.git
cd TimeMoney

# Install dependencies
flutter pub get

# Generate code (Freezed, ObjectBox, Drift, JSON)
dart run build_runner build --delete-conflicting-outputs
```

### Run

The project uses flavor-specific entry points. There is no `lib/main.dart` — you must specify `--flavor` and `--target`:

```bash
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

> **Web/Windows:** Use `--target` only (no `--flavor` needed).

## Testing

```bash
# Run all tests with coverage and random ordering
flutter test --coverage --test-randomize-ordering-seed random

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

### Test Breakdown

| Layer | Scope | Approach |
|---|---|---|
| Unit | Use cases, repositories | Mocktail mocks, Either assertions |
| BLoC | State management | bloc_test with build/act/expect |
| Widget | Presentation layer | pumpApp helper, finder assertions |
| Golden | Visual regression | matchesGoldenFile on macOS |

## CI/CD

The [GitHub Actions pipeline](.github/workflows/main.yaml) runs 8 jobs on every push and PR:

1. **Semantic PR** — validates conventional commit PR titles
2. **Quality Gate** — format check + `flutter analyze --fatal-infos` + tests with coverage
3. **Golden Tests** — visual regression on macOS (font rendering consistency)
4. **Build Android** — APK build with debug signing (Java 17)
5. **Build iOS** — iOS build (no codesign)
6. **Build Web** — web release build
7. **Build Windows** — Windows release build
8. **Spell Check** — cspell scan on all markdown files

## Modernization Methodology

This project was modernized using the **[BMad Method][bmad_link]** — a structured methodology for AI-assisted software development — with **Claude Code** as the implementation engine.

### How It Works

The BMad Method orchestrates specialized AI agents through a phased workflow. Each phase produces artifacts that feed the next, with human approval gates at every transition:

```
Product Brief → PRD → Architecture → Test Design → Epics & Stories
  → Create Story → Validate → Implement (code + tests) → Code Review → Retrospective
```

Each phase has a dedicated AI agent role: **PM** (requirements discovery), **Architect** (solution design), **Scrum Master** (story creation and sprint planning), **Dev** (implementation), and **Code Reviewer** (adversarial multi-layer review). The human developer drives decisions and approvals at each gate.

Key principles enforced throughout:

- **Tests ship with implementation, never deferred** — every story includes its tests as part of the acceptance criteria. Test design happens at the architecture phase, and each story spec defines what must be tested before it can pass code review.
- **Story lifecycle is rigorous** — each story is created with full context (ACs, tasks, dev notes), validated against the spec before implementation begins, implemented with tests, then reviewed through an adversarial 3-layer code review (Blind Hunter + Edge Case Hunter + Acceptance Auditor).
- **Retrospectives close the loop** — after each epic, lessons learned feed back into subsequent planning, preventing repeated mistakes and refining the process.

### The 6-Epic Migration

The brownfield modernization followed a deliberate sequence — each epic building on the previous:

| Epic | Focus | Stories | Key Outcomes |
|---|---|---|---|
| 1 | SDK Foundation | 4 | Dart 2.x → 3.11+, dependency upgrades |
| 2 | Architecture | 5 | Feature-first restructure, Clean Architecture layers |
| 3 | State Management | 6 | BLoC 9.x sealed classes, Freezed entities, fpdart |
| 4 | Platform | 5 | Drift web datasource, platform-aware DI, multi-platform |
| 5 | Testing | 3 | 373 tests, 92.3% coverage, golden tests |
| 6 | Polish | 2 | CI/CD pipeline (8 jobs), README, docs |

Testing was not an afterthought confined to Epic 5 — unit and BLoC tests were written alongside every story from Epic 3 onward. Epic 5 added the remaining widget tests, golden tests, and coverage validation to reach 92.3%.

**25 stories** executed across 138 commits, with retrospectives after each epic to capture lessons and adjust course.

### Generated Artifacts

All planning and implementation artifacts are preserved in [`_bmad-output/`](_bmad-output/) for transparency:

- **Planning:** product brief, PRD, architecture decisions, epics breakdown
- **Implementation:** 25 story specs (with acceptance criteria, tasks, dev records), 5 epic retrospectives, 5 tech specs for cross-cutting concerns
- **Tracking:** sprint status, deferred work log, implementation readiness report

This structure means every design decision, scope change, and tradeoff is traceable — from the initial product brief through each story's code review record.

## Contributing

This is a solo portfolio project, but contributions are welcome. Follow these standards:

- **Commits:** conventional format (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`)
- **Linting:** `very_good_analysis` strict rules, zero warnings policy
- **Documentation:** `public_member_api_docs` enabled — all public APIs need `///` dartdoc comments
- **State Management:** sealed classes for BLoC states/events (not Freezed)
- **Domain Entities:** Freezed for domain data classes only
- **Tests:** ship with implementation, never deferred
- **Spelling:** new technical terms in `.md` files must be added to `.github/cspell.json` (alphabetical order)

### Verify Before Push

Run these commands locally to ensure CI will pass:

```bash
# Code quality (must produce zero issues)
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos

# Tests
flutter test --coverage --test-randomize-ordering-seed random

# Spell check on markdown files
npx cspell --config .github/cspell.json "**/*.md"
```

See the [PR template](.github/PULL_REQUEST_TEMPLATE.md) for the pull request checklist.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

Built with Flutter. Modernized with the [BMad Method][bmad_link] + Claude Code.

[ci_badge]: https://github.com/ChrisBP-Dev/TimeMoney/actions/workflows/main.yaml/badge.svg
[ci_link]: https://github.com/ChrisBP-Dev/TimeMoney/actions/workflows/main.yaml
[coverage_badge]: coverage_badge.svg
[dart_badge]: https://img.shields.io/badge/Dart-%E2%89%A53.11.0-blue
[dart_link]: https://dart.dev
[flutter_badge]: https://img.shields.io/badge/Flutter-3.41+-blue
[flutter_link]: https://flutter.dev
[license_badge]: https://img.shields.io/badge/license-MIT-green
[license_link]: LICENSE
[vga_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[vga_link]: https://pub.dev/packages/very_good_analysis
[bmad_link]: https://github.com/bmad-code-org/BMAD-METHOD
