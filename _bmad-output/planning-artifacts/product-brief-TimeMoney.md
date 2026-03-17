---
title: "Product Brief: TimeMoney"
status: "complete"
created: "2026-03-16"
updated: "2026-03-17"
inputs:
  - docs/project-overview.md
  - docs/architecture.md
  - docs/data-models.md
  - docs/component-inventory.md
  - docs/source-tree-analysis.md
  - _bmad-output/project-context.md
  - pubspec.yaml
---

# Product Brief: TimeMoney

## Executive Summary

TimeMoney is a Flutter mobile application that helps hourly workers track work hours and calculate payments — a simple, offline-first tool solving a real problem for real people. Originally built three years ago, the app is fully functional with production-grade foundations already in place: bilingual localization (EN/ES), three-environment configuration (dev/staging/prod), and multi-platform targeting (iOS, Android, Web, Windows). However, the codebase is technically outdated: Flutter 3.7.5, Dart 2.x, pre-sealed-classes architecture, zero test coverage, and dependencies trailing by multiple major versions.

This initiative is a comprehensive brownfield modernization — upgrading TimeMoney to production-grade engineering standards while preserving its existing functionality. The goal is not to add features but to transform the codebase into a professional-quality open-source reference implementation that demonstrates modern Flutter development: Clean Architecture with feature-first organization, BLoC 9.x with sealed classes, Dart 3.11 patterns, multi-datasource architecture, comprehensive testing, and SOLID principles applied throughout.

The modernized TimeMoney serves as a portfolio showcase and community resource — "The Missing Flutter Migration Guide." It proves the developer's ability to take a legacy Flutter project and systematically bring it to current professional standards using AI-assisted development (BMad Method). In a Flutter ecosystem where canonical architecture references are 3-5 years old and pre-Dart 3, a fully modernized, tested, working app fills a genuine gap.

## The Problem

The Flutter ecosystem lacks modern, production-quality reference implementations. The canonical architecture examples (ResoCoder's Clean Architecture series, FilledStacks tutorials, Very Good Ventures templates) were written in 2019-2022 and have not been updated for Dart 3's sealed classes, records, patterns, or modern BLoC 9.x conventions. Developers learning Flutter architecture and hiring managers evaluating Flutter engineers face the same problem: there are no up-to-date, real-world examples that demonstrate what professional Flutter code looks like in 2026.

Meanwhile, TimeMoney itself represents a common real-world scenario — a working legacy Flutter app that needs modernization. Thousands of Flutter projects built 2-4 years ago face this exact situation: outdated SDKs, missing tests, architectural debt, dependencies multiple major versions behind. There is no public, documented example of how to systematically modernize such a project.

## The Solution

A complete technical modernization of TimeMoney covering seven pillars:

1. **SDK & Dependency Modernization** — Upgrade from Flutter 3.7.5 / Dart 2.19 to Flutter 3.41+ / Dart 3.11+. Update all dependencies to current stable versions: BLoC 9.x, Freezed 3.x, ObjectBox 5.x, replace dartz with fpdart, upgrade very_good_analysis to latest. Remove flutter_hooks (replace with standard StatefulWidget patterns). Migration follows a deliberate sequence with compilation checkpoints between each step.

2. **Architecture Correction** — Restructure from presentation-outside-features to true feature-first organization. Every feature contains all layers internally: domain, application, infrastructure, presentation. Correct naming conventions (folder spelling: `aplication` → `application`, `infraestructure` → `infrastructure`). Define clear composition patterns for cross-feature pages.

3. **Multi-Datasource Architecture** — Add drift (SQLite) as a second data layer implementation alongside ObjectBox, enabling full web platform support. The Repository pattern's interchangeability is demonstrated in practice: ObjectBox for mobile/desktop, drift for web, selected via platform-aware dependency injection. This is not a new feature — it is the strongest possible proof that the Clean Architecture actually works.

4. **Modern Dart Patterns** — Dart 3 sealed classes for BLoC events and states (exhaustive pattern matching, no codegen needed). Freezed 3.x retained for domain data classes (copyWith, equality, JSON serialization). Adopt records, pattern matching, dot shorthands, class modifiers, and exhaustive switch expressions where they improve clarity.

5. **BLoC 9.x Best Practices** — Sealed events/states with `prefer-sealed-bloc-events` and `prefer-sealed-bloc-state`, proper `context.mounted` handling, optimized `BlocSelector` usage. DI via flutter_bloc's RepositoryProvider/BlocProvider (BLoC-native, appropriate for project scale).

6. **Comprehensive Testing** — Full test suite built from zero: unit tests for use cases and repositories, BLoC tests for all state management, widget tests for presentation. Concrete testing matrix defining which classes get which test type. Tests are meaningful — demonstrating testing best practices, not inflating coverage numbers.

7. **Code Quality & Cleanup** — Remove orphaned code, fix dependency placement (build_runner/freezed to dev_dependencies), correct naming conventions (I-prefix on implementations → correct convention), clean up unused dependencies. Every file justified, every pattern consistent.

## What Makes This Different

- **Real app, not a template.** TimeMoney solves a real problem (hourly pay calculation) with production-grade features: bilingual localization, three-environment configuration, and four-platform support. Unlike starter templates, it demonstrates how architecture patterns compose in a multi-feature application with actual business logic.

- **Brownfield, not greenfield.** Most architecture references start from scratch. TimeMoney shows the harder, more realistic skill: taking working legacy code and modernizing it systematically. The ability to improve existing code without breaking it is the rarest and most valued engineering discipline in senior hires.

- **Multi-datasource proof of architecture.** Two real data layer implementations (ObjectBox + drift) behind the same Repository interface, with platform-aware selection. This is not theoretical Clean Architecture — it is the pattern working in production, proving that the abstraction layers actually decouple.

- **Documented migration journey.** Meaningful commit history showing the step-by-step modernization process. This transparency proves analytical thinking and creates a reproducible migration playbook that other teams facing Dart 2→3 migrations can follow.

- **AI-assisted methodology.** Executed using the BMad Method — a documented case study of AI-augmented legacy modernization. In 2026, this positions the developer at the intersection of Flutter expertise and AI-augmented engineering workflows, a genuinely novel combination.

- **Current as of 2026.** Dart 3.11, BLoC 9.x, Flutter 3.41, drift 2.32+, ObjectBox 5.x. Fills the gap left by 3-5 year old canonical references that pre-date Dart 3.

## Who This Serves

**Primary: Hiring managers and tech leads** evaluating Flutter developers. They want to see evidence of architectural thinking, testing discipline, SOLID principles, and the ability to write production-grade code. A documented brownfield migration with clean commit history, proper testing, multi-datasource architecture, and clear decisions is exactly what differentiates senior from junior candidates.

**Secondary: Flutter developers** seeking a modern, real-world reference implementation. Developers learning Clean Architecture + BLoC in 2026 need examples that use current Dart 3 features, not pre-null-safety patterns.

**Tertiary: Teams with legacy Flutter codebases** looking for a documented example of how to modernize an older Flutter project to current standards — including the specific migration sequence and architectural decisions involved.

## Success Criteria

| Criterion | Measure |
|---|---|
| All existing features work identically | Zero functional regressions on iOS, Android, Web, and Windows |
| Full test suite | All tests pass — unit, BLoC, widget tests with concrete testing matrix |
| Current dependencies | Flutter 3.41+ / Dart 3.11+, all packages at latest stable |
| Feature-first architecture | Every feature self-contained with domain, application, infrastructure, presentation layers |
| Multi-datasource architecture | ObjectBox (mobile/desktop) + drift (web) behind shared Repository interfaces |
| Modern Dart patterns | Sealed classes for BLoC states/events, Freezed for data classes, pattern matching, records |
| BLoC 9.x best practices | Sealed events/states, mounted checks, proper selectors, BLoC-native DI |
| Clean code quality | No orphaned code, correct dependency placement, consistent naming, linter-clean |
| CI/CD pipeline | Updated workflows with linting, testing, coverage reporting, and build verification for all platforms |
| Professional README | Communicates project value, architecture, modernization approach, and setup within the first 30 seconds |
| Documented migration | Meaningful commit history, key decisions traceable, reproducible modernization journey |

## Scope

### In Scope
- Full SDK and dependency upgrade to latest stable versions (deliberate migration sequencing)
- Architecture restructure to feature-first organization
- Multi-datasource implementation (ObjectBox + drift) with platform-aware DI
- Dart 3 / BLoC 9.x pattern adoption (sealed classes, pattern matching, records)
- Comprehensive test suite implementation with defined testing matrix
- Code quality cleanup (naming, orphaned code, dependency placement, unused dependencies)
- Remove flutter_hooks dependency (replace with standard patterns)
- CI/CD pipeline update (workflow versions, checks, coverage reporting, multi-platform builds)
- README rewrite and documentation update
- Platform compatibility verification on all four targets

### Out of Scope
- New features or functionality changes
- UI/UX redesign or visual changes
- Backend/cloud integration
- Authentication or user accounts
- Analytics or monetization

## Vision

TimeMoney becomes the go-to reference for "what does a professional Flutter app look like in 2026?" — a living proof point that demonstrates Clean Architecture + BLoC done right with modern Dart, complete with testing, multi-datasource architecture, and documentation. The project stands as both a portfolio piece showcasing engineering excellence and a community resource — "The Missing Flutter Migration Guide" — filling a gap that the Flutter ecosystem's outdated canonical references have left open. The documented modernization journey itself becomes a second deliverable, demonstrating not just what good code looks like but how to get there from legacy.
