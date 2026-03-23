# Project Overview - TimeMoney

> Generated: 2026-03-23 | Scan Level: Exhaustive | Mode: Full Rescan

## Executive Summary

TimeMoney is a cross-platform Flutter application for hourly workers to track work hours and calculate payments. It supports iOS, Android, Web, and Windows through a feature-first Clean Architecture with dual datasource persistence (ObjectBox for native platforms, Drift/SQLite for web).

The project represents a real brownfield modernization of a 3-year-old codebase, upgraded from Dart 2.x to 3.11+ with professional-grade standards including BLoC 9.x with sealed classes, Freezed 3.x for domain entities, fpdart for functional error handling, and comprehensive testing (373 tests, 92.3% coverage).

The modernization was AI-assisted using the BMad Method + Claude Code, following a structured 6-epic migration (25 stories, 138 commits) with retrospectives after each epic.

## Technology Stack

| Category | Technology | Version |
|---|---|---|
| Framework | Flutter | 3.41+ |
| Language | Dart | >=3.11.0 <4.0.0 |
| State Management | BLoC / Cubit | ^9.2.0 / ^9.1.1 |
| Domain Entities | Freezed | ^3.2.5 |
| Error Handling | fpdart | ^1.2.0 |
| Persistence (native) | ObjectBox | ^5.2.0 |
| Persistence (web) | Drift + drift_flutter | ^2.32.0 |
| Linting | very_good_analysis | ^10.2.0 |
| Testing | bloc_test / mocktail | ^10.0.0 / ^1.0.0 |
| i18n | intl | ^0.20.0 |
| App Icons | flutter_launcher_icons | ^0.14.3 |
| CI/CD | GitHub Actions | 8-job pipeline |

## Architecture Classification

- **Repository Type:** Monolith (single cohesive codebase)
- **Architecture Pattern:** Feature-First Clean Architecture + BLoC Pattern
- **Datasource Strategy:** Dual datasource — ObjectBox (native: iOS/Android/Windows) + Drift (web: SQLite via WASM + OPFS)
- **DI Strategy:** Platform-aware compile-time conditional imports
- **State Pattern:** Sealed classes for BLoC states/events, Freezed for domain entities only
- **License:** MIT (2023-2026)

## Features

| Feature | Description | BLoCs/Cubits | Use Cases |
|---|---|---|---|
| Times | Time entry CRUD with reactive streams | 4 BLoCs | 4 |
| Wage | Hourly wage management | 2 BLoCs | 3 |
| Payment | Payment calculation from times + wage | 1 Cubit | 1 |
| Home | Main app screen integrating all features | — | — |

## Project Metrics

| Metric | Value |
|---|---|
| Dart source files (lib/src/) | 131 (non-generated) |
| Total Dart files (lib/src/) | 136 (including .g.dart / .freezed.dart) |
| Features | 4 |
| BLoCs + Cubits | 6 + 2 (includes LocaleCubit) |
| Use Cases | 8 |
| Domain Entities | 3 (TimeEntry, WageHourly, PaymentResult) |
| Repository Implementations | 4 (2 ObjectBox + 2 Drift) |
| Datasources | 4 (2 ObjectBox + 2 Drift) |
| Pages | 7 |
| Widgets | 37+ |
| Test Files | 70 |
| Total Tests | 373 |
| Coverage | 92.3% |
| Platforms | 4 (iOS, Android, Web, Windows) |
| Locales | 2 (English, Spanish) |
| CI/CD Jobs | 8 |
| App Icon Source | Custom `time-money-logo.png` (3 per-flavor configs) |

## Repository Structure

- [Architecture](./architecture.md) — Layer details, data flow, DI, error handling
- [Source Tree Analysis](./source-tree-analysis.md) — Annotated directory structure
- [Data Models](./data-models.md) — Entities, ObjectBox boxes, Drift tables
- [Component Inventory](./component-inventory.md) — All BLoCs, Cubits, widgets, and UI patterns
- [Development Guide](./development-guide.md) — Setup, build, test, CI/CD, conventions
