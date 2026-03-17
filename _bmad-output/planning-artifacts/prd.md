---
stepsCompleted:
  - 'step-01-init'
  - 'step-02-discovery'
  - 'step-02b-vision'
  - 'step-02c-executive-summary'
  - 'step-03-success'
  - 'step-04-journeys'
  - 'step-05-domain-skipped'
  - 'step-06-innovation-skipped'
  - 'step-07-project-type'
  - 'step-08-scoping'
  - 'step-09-functional'
  - 'step-10-nonfunctional'
  - 'step-11-polish'
  - 'step-12-complete'
classification:
  projectType: 'mobile_app'
  domain: 'general'
  complexity: 'low'
  projectContext: 'brownfield'
inputDocuments:
  - 'planning-artifacts/product-brief-TimeMoney.md'
  - 'planning-artifacts/product-brief-TimeMoney-distillate.md'
  - 'project-context.md'
  - 'docs/index.md'
  - 'docs/project-overview.md'
  - 'docs/architecture.md'
  - 'docs/data-models.md'
  - 'docs/component-inventory.md'
  - 'docs/development-guide.md'
  - 'docs/source-tree-analysis.md'
documentCounts:
  briefs: 2
  research: 0
  brainstorming: 0
  projectDocs: 7
  projectContext: 1
workflowType: 'prd'
---

# Product Requirements Document - TimeMoney

**Author:** Christopher
**Date:** 2026-03-16

## Executive Summary

TimeMoney is a cross-platform Flutter application (iOS, Android, Web, Windows) that helps hourly workers track work hours and calculate payments. Originally built three years ago on Flutter 3.7.5 / Dart 2.19, the app is fully functional with production-grade foundations: bilingual localization (EN/ES), three-environment configuration, and Clean Architecture with BLoC state management.

This initiative is a comprehensive brownfield modernization — upgrading TimeMoney from a working but technically outdated codebase to current professional engineering standards. The goal is not to add features but to transform the existing code into a production-quality open-source reference implementation: Flutter 3.41+ / Dart 3.11+, Clean Architecture with true feature-first organization, BLoC 9.x with sealed classes, multi-datasource architecture (ObjectBox + drift), comprehensive testing, and SOLID principles applied throughout.

The modernized TimeMoney serves a dual purpose: a professional portfolio piece demonstrating senior-level Flutter engineering, and a community resource filling the gap left by outdated canonical references (ResoCoder, FilledStacks, VGV templates) that predate Dart 3. The project also documents AI-assisted legacy modernization using the BMad Method and Claude Code — demonstrating that AI tooling, applied with engineering judgment, produces professional-quality results.

### What Makes This Special

- **Demonstrated modernization skill.** Taking real legacy code from Dart 2.x to Dart 3.11+ with documented decisions and migration sequencing — a skill commonly required but rarely demonstrated with verifiable evidence.
- **Real project, not generic.** A functional app with actual business logic, multi-datasource architecture, reactive streams, and cross-feature composition — not another counter app or todo list.
- **AI-assisted engineering with judgment.** BMad Method + Claude Code executed with architectural intent, proving AI is a productivity multiplier when paired with genuine engineering knowledge — not vibe coding, not spaghetti code, but quality-driven development.
- **Current reflection of ability.** The existing 3-year-old codebase no longer represents the developer's current skill level. This modernization closes that gap with concrete, reviewable evidence of present-day engineering decisions and practices.

## Project Classification

| Attribute | Value |
|---|---|
| **Project Type** | Cross-platform mobile application (Flutter) |
| **Domain** | General / Productivity-Utility |
| **Complexity** | Low (simple domain, no regulatory requirements) |
| **Project Context** | Brownfield (modernization of existing functional system) |
| **Target Platforms** | iOS, Android, Web, Windows |
| **State Management** | BLoC pattern |
| **Architecture** | Clean Architecture, feature-first organization |

## Success Criteria

### User Success

- **Zero functional regressions.** Every existing feature works identically on all four platforms (iOS, Android, Web, Windows) — time entry CRUD, wage management, payment calculation, localization (EN/ES).
- **Web platform fully functional.** drift (SQLite) enables complete web support where ObjectBox cannot, delivering a working web experience as a direct result of the modernization.
- **Improved performance.** Modern SDK, optimized dependencies, and platform-appropriate data layers result in perceptible performance improvements, particularly on web.
- **Full test suite passing.** Comprehensive unit, BLoC, widget, and golden tests all pass — a quality guarantee that did not exist before.

### Business Success (Portfolio)

- **Recruiter engagement.** The repository is referenced in CV, LinkedIn posts, personal website, and GitHub profile. Success is measured by recruiter/interviewer comments acknowledging the project quality during hiring conversations.
- **Community recognition.** GitHub stars, forks, and mentions as a Flutter architecture reference indicate the project fills the ecosystem gap it targets.
- **LinkedIn content traction.** Posts documenting the modernization journey and BMad Method generate meaningful engagement and position Christopher as a Flutter engineer who builds with quality and modern AI tooling.
- **Interview differentiator.** The project serves as concrete evidence during technical discussions — not claims about skill, but reviewable code that speaks for itself.

### Technical Success

- **Current SDK and dependencies.** Flutter 3.41+ / Dart 3.11+, all packages at latest stable versions (BLoC 9.x, Freezed 3.x, ObjectBox 5.x, fpdart, drift 2.32+).
- **Feature-first architecture.** Every feature self-contained with domain, application, infrastructure, and presentation layers internally.
- **Multi-datasource architecture.** ObjectBox (mobile/desktop) + drift (web) behind shared Repository interfaces with platform-aware DI selection.
- **Modern Dart patterns.** Sealed classes for BLoC events/states, Freezed 3.x for data classes, pattern matching, records, exhaustive switch expressions.
- **BLoC 9.x best practices.** Sealed events/states, `context.mounted` handling, `BlocSelector` optimization, BLoC-native DI.
- **Comprehensive test suite.** Unit tests (use cases, repositories), BLoC tests (all state management), widget tests (presentation), golden tests (visual regression proof).
- **Clean code quality.** No orphaned code, correct dependency placement, consistent naming conventions, linter-clean, zero warnings.
- **CI/CD pipeline.** Updated GitHub Actions with linting, testing, coverage reporting, and build verification for all platforms.
- **Documented migration.** Meaningful commit history showing step-by-step modernization, traceable decisions, reproducible migration journey.

### Measurable Outcomes

| Outcome | Target |
|---|---|
| Functional regressions | Zero — all existing features work identically |
| Test suite | All tests pass (unit, BLoC, widget, golden) |
| Platform coverage | 4/4 platforms verified (iOS, Android, Web, Windows) |
| Dependency currency | All packages at latest stable as of 2026 |
| Linter warnings | Zero on non-generated code |
| Architecture compliance | 100% feature-first — no presentation code outside features |
| Migration documentation | Complete commit history with meaningful messages |

## Product Scope & Development Strategy

### Strategy

**Approach:** Complete Modernization — Single Phase

This is not a phased rollout or iterative product launch. TimeMoney is a fully functional existing application. The modernization is executed as a single, complete initiative where all nine scope items are delivered together. Anything less would leave the project in an inconsistent state (partially migrated SDK, mixed architecture patterns, incomplete test coverage) that would undermine both its portfolio value and its utility as a community reference.

**Resource Requirements:** Solo developer (Christopher) with AI-assisted development (BMad Method + Claude Code). The BMad Method provides structured workflow execution that compensates for single-developer bandwidth by ensuring systematic, high-quality output.

### Complete Scope

All four user journeys (María happy path, María edge case, Daniel hiring manager, Sofía Flutter dev) are fully supported. No features are deferred.

| # | Capability | Justification |
|---|---|---|
| 1 | SDK & Dependency Modernization | Foundation — everything else depends on current SDK |
| 2 | Architecture Restructure | Structural quality visible to Daniel and Sofía |
| 3 | Multi-Datasource Architecture | Strongest architectural differentiator; enables web for María |
| 4 | Modern Dart Patterns | Code quality signal for hiring managers |
| 5 | BLoC 9.x Migration | State management is the first thing reviewers inspect |
| 6 | Comprehensive Testing | Quality proof — without tests, the modernization lacks credibility |
| 7 | Code Quality Cleanup | Professional polish — no orphaned code, consistent naming |
| 8 | CI/CD Pipeline Update | Automation demonstrates engineering maturity |
| 9 | Professional README | First impression — Daniel's journey starts here |

**Dependency Chain:** SDK upgrade (1) must come first. Architecture restructure (2) and modern patterns (4, 5) follow. Multi-datasource (3) requires stable architecture. Testing (6) requires stable code. Cleanup (7), CI/CD (8), and README (9) are final polish.

**Post-Modernization:** No additional phases planned. Future evolution, if any, would be driven by community feedback or new Flutter/Dart major versions.

### Risk Mitigation

**Technical Risks:**

| Risk | Impact | Mitigation |
|---|---|---|
| ObjectBox 1.7→5.x schema incompatibility | Database migration failure, data loss in dev | Test migration on dev environment first; ObjectBox handles schema migrations automatically but verify with 3-major-version jump |
| Dart 2→3 breaking change cliff | Compilation failures across entire codebase | Deliberate migration sequencing with compilation checkpoints between each step; SDK constraint first, then dependencies one at a time |
| Freezed 2→3 codegen breaking changes | All generated files need regeneration | Regenerate all `.freezed.dart` and `.g.dart` files at intermediate steps; verify compilation after each regeneration |
| drift web (WASM + OPFS) browser compatibility | Web datasource may not work on all browsers | OPFS is supported in modern browsers (Chrome 86+, Firefox 111+, Safari 15.2+); acceptable for portfolio/reference purposes |

**Market Risks:**

| Risk | Impact | Mitigation |
|---|---|---|
| Flutter ecosystem moves past Dart 3.11 | Project becomes outdated again | The patterns and architecture are transferable across versions; README documents the specific versions targeted |
| Low community engagement | Portfolio value diminished | Primary audience is hiring managers (direct CV link), not organic discovery; LinkedIn content strategy supplements GitHub visibility |

**Resource Risks:**

| Risk | Impact | Mitigation |
|---|---|---|
| Solo developer bottleneck | Delayed completion | BMad Method provides structured execution that prevents scope creep and decision paralysis; AI-assisted development multiplies output |
| Migration sequence gets stuck | Blocked on a single dependency upgrade | Compilation checkpoints allow rolling back to last working state; each step is independently verifiable |

## User Journeys

### Journey 1: María — The Hourly Worker (App User, Happy Path)

María works as a house cleaner in Austin, TX, juggling three different clients per week. Each client pays a different hourly rate, and she needs to track her hours accurately to invoice them at the end of each week.

**Opening Scene:** María finishes a 3-hour cleaning job. She opens TimeMoney on her phone and taps "Add Time" — enters 3 hours, 0 minutes. Quick, simple, done before she drives to her next client.

**Rising Action:** Throughout the week, she logs each job as she finishes. She updates her hourly wage when a client agrees to a rate increase. The app shows her running list of entries in real time — no refresh needed, no waiting.

**Climax:** Friday evening. María taps "Calculate Payment." The app instantly shows her total hours, total minutes, and the exact dollar amount she earned that week. She takes a screenshot and sends the invoice to her clients.

**Resolution:** María gets paid accurately, on time, every week. No spreadsheets, no mental math, no forgotten hours. TimeMoney is the simplest tool in her phone — and the one she trusts most.

**Capabilities revealed:** Time entry CRUD, wage management, payment calculation, reactive real-time updates, offline-first reliability, bilingual support (María switches between EN/ES).

### Journey 2: María — Error Recovery (App User, Edge Case)

**Opening Scene:** María accidentally enters 30 hours instead of 3. She sees the entry in her list and taps the edit button immediately.

**Rising Action:** The update dialog opens pre-populated with 30 hours. She corrects it to 3, taps "Update." The green success feedback confirms the change. She also notices an old entry from last month that shouldn't be there — taps edit, then "Delete." Red confirmation, entry gone.

**Climax:** She recalculates payment. The number is correct now. No lingering bad data, no confusion.

**Resolution:** María trusts the app because mistakes are easy to fix. The visual feedback (green for success, red for delete) makes her confident each action worked.

**Capabilities revealed:** Update flow with pre-population, delete flow, ActionState feedback, data integrity through reactive streams.

### Journey 3: Daniel — The Hiring Manager (Repository User)

Daniel is a senior engineering manager at a fintech startup in Miami. He's reviewing Flutter candidates for a mid-senior role. He's seen 15 GitHub profiles this week — most have todo apps, counter tutorials, or repos untouched since 2023.

**Opening Scene:** Daniel opens Christopher's GitHub profile from a LinkedIn application. He sees TimeMoney pinned with a professional README. The description catches his eye: "Brownfield Flutter modernization — Clean Architecture, BLoC 9.x, multi-datasource, comprehensive testing."

**Rising Action:** He clicks through. The README explains the architecture in 30 seconds. He opens `lib/src/features/times/` — sees domain, application, infrastructure, presentation layers properly separated. He checks a BLoC file — sealed classes, exhaustive pattern matching, clean state management. He opens the test folder — unit tests, BLoC tests, widget tests, golden tests. Real coverage, not inflated numbers.

**Climax:** Daniel opens the commit history. He sees a deliberate migration sequence: SDK upgrade first, then ObjectBox, then BLoC, then architecture restructure. Each commit is meaningful, each decision is traceable. He thinks: "This person knows how to modernize legacy code systematically."

**Resolution:** Daniel moves Christopher to the technical interview shortlist. During the interview, he references specific architectural decisions from the repo. The conversation is peer-to-peer, not quiz-style — because the code already proved competence.

**Capabilities revealed:** Professional README, clean architecture structure, meaningful commit history, test coverage, documented migration sequence, code quality visible at every level.

### Journey 4: Sofía — The Flutter Developer (Community User)

Sofía is a junior-to-mid Flutter developer in Bogotá. She's been building apps with Provider and basic folder structures. Her team lead asked her to implement Clean Architecture with BLoC on their next project, but every tutorial she finds uses Dart 2 patterns and outdated packages.

**Opening Scene:** Sofía finds TimeMoney through a LinkedIn post about Flutter modernization. She clones the repo and opens it in VS Code.

**Rising Action:** She navigates the feature-first structure — each feature has its own domain, application, infrastructure, and presentation layers. She studies how sealed classes replace Freezed unions for BLoC events/states. She sees how ObjectBox and drift both implement the same Repository interface — and finally understands why dependency inversion matters in practice, not just theory.

**Climax:** Sofía copies the pattern for her own project's first feature. It compiles. The architecture actually works outside of TimeMoney. The patterns are transferable.

**Resolution:** Sofía uses TimeMoney as her architectural reference throughout her project. She stars the repo and shares it with her team. Six months later, she recommends it to another developer facing the same Dart 2→3 migration challenge.

**Capabilities revealed:** Clear, learnable architecture patterns, transferable code structure, modern Dart 3 examples, multi-datasource as teaching tool for dependency inversion.

### Journey Requirements Summary

| Journey | Key Capabilities Required |
|---|---|
| María (Happy Path) | Time CRUD, wage management, payment calculation, reactive streams, offline-first, bilingual i18n |
| María (Edge Case) | Update with pre-population, delete flow, ActionState feedback, data integrity |
| Daniel (Hiring Manager) | Professional README, clean architecture, meaningful commits, test coverage, code quality |
| Sofía (Flutter Dev) | Learnable patterns, transferable structure, modern Dart 3 examples, documented decisions |

All four journeys are served by the same modernization scope — no additional features required. The technical excellence that makes the app reliable for María is the same quality that impresses Daniel and teaches Sofía.

## Mobile App Specific Requirements

### Project-Type Overview

TimeMoney is a Flutter cross-platform application targeting four platforms: iOS, Android, Web, and Windows. The modernization preserves all existing platform targets while adding full web functionality through drift (SQLite). No new platform capabilities, device features, or distribution channels are introduced.

### Technical Architecture Considerations

**Platform Requirements:**

| Platform | Data Layer | Status |
|---|---|---|
| iOS | ObjectBox | Existing — modernize to ObjectBox 5.x |
| Android | ObjectBox | Existing — modernize to ObjectBox 5.x |
| Windows | ObjectBox | Existing — modernize to ObjectBox 5.x |
| Web | drift (SQLite via WASM + OPFS) | New — enables full web support |

**Platform-Aware Dependency Injection:**
- Runtime platform detection selects the appropriate datasource implementation
- ObjectBox for platforms with native filesystem access (iOS, Android, Windows)
- drift for web platform (WebAssembly + Origin Private File System)
- Both implementations conform to the same Repository interfaces (TimesRepository, WageHourlyRepository)

**Offline Mode:**
- All platforms operate fully offline — no network dependency, no backend
- Data persistence is local-only via ObjectBox or drift depending on platform
- Reactive streams (ObjectBox `watch()` / drift equivalent) provide real-time UI updates from local data changes
- No sync, no cloud backup — data lives on-device

### Device Permissions & Features

- **No special device permissions required.** TimeMoney does not use camera, GPS, biometrics, contacts, or any platform-specific hardware features.
- **No push notifications.** The app is entirely user-initiated — no background processing, no remote triggers.
- **Keyboard type only:** Numeric keyboard for hour/minute/wage input fields — standard Flutter `TextInputType.number`.

### Implementation Considerations

- **Flutter 3.41+ / Dart 3.11+** as minimum SDK — all platform-specific configurations (Xcode project, Gradle, web index.html, Windows CMake) must be updated to match.
- **Three-environment configuration preserved:** Development (test-1), Staging (stg-1), Production (prod-1) — each with separate database instances.
- **No app store distribution planned.** The app is built and run locally or via CI for verification purposes.
- **Web deployment:** Not specified — web build primarily serves as architectural proof that drift enables full platform coverage.

## Functional Requirements

### Time Entry Management

- **FR1:** User can create a new time entry by specifying hours and minutes
- **FR2:** User can view a real-time list of all recorded time entries
- **FR3:** User can edit an existing time entry with pre-populated current values
- **FR4:** User can delete an existing time entry
- **FR5:** User can see visual feedback (loading, success, error) for every create, update, and delete action
- **FR6:** User can see the time entry list update automatically when data changes without manual refresh

### Wage Management

- **FR7:** User can view the current hourly wage rate
- **FR8:** User can set an initial hourly wage rate (default: $15.00)
- **FR9:** User can update the hourly wage rate
- **FR10:** User can see the wage value update in real time without manual refresh
- **FR11:** User can see visual feedback (loading, success, error) for wage update actions

### Payment Calculation

- **FR12:** User can calculate total payment based on all recorded time entries and the current hourly wage
- **FR13:** User can view a payment summary showing total hours, total minutes, hourly rate, and total payment amount
- **FR14:** System computes payment using the formula: (total duration in minutes / 60) * hourly wage

### Localization

- **FR15:** User can use the app in English
- **FR16:** User can use the app in Spanish
- **FR17:** All user-facing strings are localized — no hardcoded text

### Multi-Platform Support

- **FR18:** User can run the app on iOS with full functionality
- **FR19:** User can run the app on Android with full functionality
- **FR20:** User can run the app on Web with full functionality via drift datasource
- **FR21:** User can run the app on Windows with full functionality
- **FR22:** System selects the appropriate datasource implementation (ObjectBox or drift) based on the target platform automatically

### Multi-Environment Support

- **FR23:** Developer can run the app in Development environment with isolated database (test-1)
- **FR24:** Developer can run the app in Staging environment with isolated database (stg-1)
- **FR25:** Developer can run the app in Production environment with isolated database (prod-1)

### Data Persistence

- **FR26:** System persists all time entries and wage data locally on-device
- **FR27:** System provides reactive data streams for both ObjectBox and drift implementations
- **FR28:** ObjectBox implementation supports iOS, Android, and Windows platforms
- **FR29:** drift implementation supports Web platform via WebAssembly and OPFS
- **FR30:** Both datasource implementations conform to the same Repository interfaces (TimesRepository, WageHourlyRepository)

### Architecture & Code Organization

- **FR31:** Codebase follows feature-first organization where each feature contains all layers (domain, application, infrastructure, presentation)
- **FR32:** Domain layer has zero external dependencies — entities and repository interfaces only
- **FR33:** Application layer contains use cases implementing single-responsibility operations
- **FR34:** Infrastructure layer contains concrete repository implementations and database entities
- **FR35:** Presentation layer contains BLoCs, views, and widgets scoped to their feature
- **FR36:** Shared cross-cutting concerns (failures, services, extensions) reside in a core module
- **FR37:** Dependency injection follows three-tier pattern: Repositories → Use Cases → BLoCs via flutter_bloc providers

### State Management

- **FR38:** All BLoCs use sealed classes for events and states with exhaustive pattern matching
- **FR39:** Freezed 3.x is used for domain data classes (copyWith, equality, JSON serialization)
- **FR40:** All BLoCs follow the standard state pattern: initial, loading, error, success/data
- **FR41:** BLoCs with stream data provide a hasDataStream state for reactive UI rendering
- **FR42:** ResultPaymentCubit derives computed state from times list and wage without events

### Testing

- **FR43:** Unit tests cover all use cases and repository implementations
- **FR44:** BLoC tests cover all state management logic using bloc_test
- **FR45:** Widget tests cover presentation layer components
- **FR46:** Golden tests verify zero visual regression across the modernization
- **FR47:** All tests are runnable via `flutter test` with coverage reporting

### CI/CD & Developer Experience

- **FR48:** CI pipeline runs linting, testing, and coverage reporting on every PR
- **FR49:** CI pipeline verifies builds for all four target platforms
- **FR50:** README communicates project value, architecture, and setup within 30 seconds
- **FR51:** Commit history documents the migration journey with meaningful, traceable messages

## Non-Functional Requirements

### Performance

- **NFR1:** All user actions (create, update, delete time entry; update wage) must complete and reflect in the UI within 500ms, excluding the intentional ActionState feedback delay.
- **NFR2:** Reactive data streams must propagate changes to the UI within 100ms of the underlying data mutation.
- **NFR3:** App cold start (from launch to interactive ControlHoursPage) must complete within 2 seconds on target platforms.
- **NFR4:** Payment calculation must execute instantaneously (< 50ms) regardless of the number of time entries.
- **NFR5:** drift (web) datasource must achieve comparable performance to ObjectBox (mobile/desktop) for all CRUD operations at the expected data scale (< 1000 entries).

### Code Quality

- **NFR6:** Zero linter warnings on all non-generated Dart code under very_good_analysis latest rules.
- **NFR7:** Zero unused imports, unused variables, or dead code in the final codebase.
- **NFR8:** All public API surfaces follow consistent naming conventions: snake_case files, PascalCase classes, correct layer suffixes (_bloc, _cubit, _use_case, _repository, _view).
- **NFR9:** No dependency placed in the wrong section — build_runner, freezed, json_serializable, and objectbox_generator must be in dev_dependencies.
- **NFR10:** All barrel export files are clean — no circular exports, no re-exports of private APIs.
- **NFR11:** Generated files (*.freezed.dart, *.g.dart, objectbox.g.dart) are excluded from analysis and never manually edited.

### Compatibility

- **NFR12:** iOS deployment target supports iOS 13+ (or minimum required by Flutter 3.41+).
- **NFR13:** Android minimum SDK supports API 21+ (or minimum required by Flutter 3.41+).
- **NFR14:** Web build functions correctly on modern browsers: Chrome 86+, Firefox 111+, Safari 15.2+ (OPFS requirement for drift).
- **NFR15:** Windows build targets Windows 10+ with MSVC toolchain.
- **NFR16:** All dependencies are at their latest stable versions as of 2026 with no deprecated API usage.

### Reliability

- **NFR17:** Zero data loss — all CRUD operations must persist reliably across app restarts on every platform.
- **NFR18:** ObjectBox 1.7→5.x database migration must preserve all existing dev/staging/production data without manual intervention.
- **NFR19:** Error handling must catch all exceptions at the infrastructure layer and return typed failures — no unhandled exceptions propagate to the UI.
- **NFR20:** All four platforms must pass identical functional test suites with zero platform-specific failures.
- **NFR21:** CI pipeline must complete successfully (lint + test + build for all platforms) before any code is merged to main.
