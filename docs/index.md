# TimeMoney - Project Documentation Index

> Generated: 2026-03-16 | Scan Level: Exhaustive | Mode: Initial Scan

## Project Overview

- **Type:** Monolith - Cross-platform Flutter mobile app
- **Primary Language:** Dart (>=2.19.2 <3.0.0)
- **Framework:** Flutter 3.7.5
- **Architecture:** Clean Architecture + BLoC Pattern
- **Database:** ObjectBox (local NoSQL)
- **Platforms:** iOS, Android, Web, Windows

## Quick Reference

- **Tech Stack:** Flutter 3.7.5 + BLoC + Freezed + ObjectBox + Dartz
- **Entry Points:** `lib/main_development.dart`, `lib/main_staging.dart`, `lib/main_production.dart`
- **Architecture Pattern:** Clean Architecture (Domain → Application → Infrastructure → Presentation)
- **Features:** Time Entry Management, Hourly Wage Configuration, Payment Calculation
- **Localization:** English, Spanish (ARB files)

## Generated Documentation

- [Project Overview](./project-overview.md) - Executive summary, tech stack, feature list
- [Architecture](./architecture.md) - Layer details, data flow, DI, error handling
- [Source Tree Analysis](./source-tree-analysis.md) - Annotated directory structure with critical folders
- [Data Models](./data-models.md) - ObjectBox entities, domain models, repositories
- [Component Inventory](./component-inventory.md) - All BLoCs, Cubits, widgets, and UI patterns
- [Development Guide](./development-guide.md) - Setup, build, test, CI/CD, conventions

## Existing Documentation

- [README.md](../README.md) - Project overview with demo video, getting started, translations guide
- [PR Template](../.github/PULL_REQUEST_TEMPLATE.md) - Pull request checklist and change types
- [CI/CD Pipeline](../.github/workflows/main.yaml) - GitHub Actions: build, semantic PR, spell-check
- [Dependabot Config](../.github/dependabot.yaml) - Daily dependency update automation

## Getting Started

```sh
# 1. Install dependencies
flutter pub get

# 2. Generate code (Freezed, ObjectBox, JSON)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run in development mode
flutter run --flavor development --target lib/main_development.dart

# 4. Run tests
flutter test --coverage --test-randomize-ordering-seed random
```
