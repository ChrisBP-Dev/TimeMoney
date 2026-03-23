# TimeMoney - Project Documentation Index

> Generated: 2026-03-23 | Scan Level: Exhaustive | Mode: Full Rescan

## Project Overview

- **Type:** Monolith - Cross-platform Flutter application
- **Primary Language:** Dart (>=3.11.0 <4.0.0)
- **Framework:** Flutter 3.41+
- **Architecture:** Feature-first Clean Architecture + BLoC 9.x Pattern
- **Database:** ObjectBox 5.x (native: iOS, Android, Windows) + Drift 2.32+ (web: SQLite via WASM + OPFS)
- **Platforms:** iOS, Android, Web, Windows

## Quick Reference

- **Tech Stack:** Flutter 3.41+ / Dart 3.11+ + BLoC 9.x + Freezed 3.x + fpdart + ObjectBox 5.x + Drift 2.32+
- **Entry Points:** `lib/main_development.dart`, `lib/main_staging.dart`, `lib/main_production.dart`
- **Architecture Pattern:** Feature-first Clean Architecture (Domain + Data + Presentation per feature)
- **Features:** Time Entry Management, Hourly Wage Configuration, Payment Calculation
- **Localization:** English, Spanish (ARB files)
- **Testing:** 373 tests, 92.3% coverage (unit, BLoC, widget, golden)
- **CI/CD:** GitHub Actions — 8-job pipeline (quality gate, platform builds, golden tests, spell-check)

## Generated Documentation

- [Project Overview](./project-overview.md) - Executive summary, tech stack, metrics, feature list
- [Architecture](./architecture.md) - Layer details, data flow, DI, error handling, feature template
- [Source Tree Analysis](./source-tree-analysis.md) - Complete annotated directory structure
- [Data Models](./data-models.md) - Domain entities, ObjectBox models, Drift tables, repository layer
- [Component Inventory](./component-inventory.md) - All BLoCs, Cubits, use cases, widgets, and design patterns
- [Development Guide](./development-guide.md) - Setup, build, test, CI/CD, coding standards

## Existing Documentation

- [README.md](../README.md) - Professional project overview, architecture, getting started, CI/CD
- [PR Template](../.github/PULL_REQUEST_TEMPLATE.md) - Pull request checklist and change types
- [CI/CD Pipeline](../.github/workflows/main.yaml) - GitHub Actions: quality gate, platform builds, golden tests, spell-check
- [Dependabot Config](../.github/dependabot.yaml) - Daily dependency update automation
- [LICENSE](../LICENSE) - MIT License (2023-2026)

## Getting Started

```sh
# 1. Install dependencies
flutter pub get

# 2. Generate code (Freezed, ObjectBox, Drift, JSON)
dart run build_runner build --delete-conflicting-outputs

# 3. Run in development mode
flutter run --flavor development --target lib/main_development.dart

# 4. Run tests
flutter test --coverage --test-randomize-ordering-seed random
```
