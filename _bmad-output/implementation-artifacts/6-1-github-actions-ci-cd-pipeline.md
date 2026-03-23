# Story 6.1: GitHub Actions CI/CD Pipeline

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a developer,
I want an automated CI/CD pipeline that validates code quality and builds on every PR,
so that no code is merged without passing lint, test, and build verification for all platforms (FR50, FR51, NFR21).

## Acceptance Criteria

1. **Pipeline triggers on every PR to main** — `.github/workflows/main.yaml` runs on `push: main` and `pull_request: main` with concurrency group that cancels in-progress runs.
2. **Linting verification (FR50)** — pipeline executes `flutter analyze --fatal-infos` and `dart format --output=none --set-exit-if-changed .`; fails on any warning or formatting issue.
3. **Test execution with coverage (FR50)** — pipeline executes `flutter test --coverage --test-randomize-ordering-seed random`; coverage artifact uploaded for reference.
4. **Multi-platform build verification (FR51)** — pipeline verifies builds for iOS (`flutter build ios --release --no-codesign`), Android (`flutter build appbundle --release`), Web (`flutter build web --release`), and Windows (`flutter build windows --release`).
5. **Pipeline fails on errors (NFR21)** — any step failure blocks merge; build jobs gated behind quality job via `needs: [quality]`.
6. **Dependabot configured** — `.github/dependabot.yaml` with daily checks for `github-actions` and `pub` ecosystems.
7. **PR template with testing verification** — `.github/PULL_REQUEST_TEMPLATE.md` includes sections for summary, changes, and testing verification checklist.
8. **Spell-check with project terms** — `.github/cspell.json` includes comprehensive project-specific terms (TimeMoney, ObjectBox, BLoC, Cubit, Drift, fpdart, Freezed, etc.) with zero false positives on domain terminology.
9. **Pipeline end-to-end verification** — a test PR triggers the pipeline, all steps complete successfully with all checks passing.

## Tasks / Subtasks

### Task 1: Replace VGV Reusable Workflow with Custom Multi-Platform Pipeline (AC: 1, 2, 3, 4, 5)

- [x] 1.1 Rewrite `.github/workflows/main.yaml` — replace VGV `flutter_package.yml` with custom `quality` job on `ubuntu-latest`: checkout → `subosito/flutter-action@v2` (channel stable, cache enabled — do NOT pin flutter-version, use latest stable) → `flutter pub get` → `dart format --output=none --set-exit-if-changed .` → `flutter analyze --fatal-infos` → `flutter test --coverage --test-randomize-ordering-seed random` → upload coverage artifact
- [x] 1.2 Keep `semantic-pull-request` job using VGV `semantic_pull_request.yml@v1`
- [x] 1.3 Keep `spell-check` job using VGV `spell_check.yml@v1` with `includes: "**/*.md"` and `modified_files_only: false`
- [x] 1.4 Add `build-android` job (`needs: [quality]`, `ubuntu-latest`): `actions/setup-java@v4` (distribution: temurin, java-version: '17') → flutter-action → `flutter build appbundle --release`
- [x] 1.5 Add `build-ios` job (`needs: [quality]`, `macos-latest`): flutter-action → `flutter build ios --release --no-codesign`
- [x] 1.6 Add `build-web` job (`needs: [quality]`, `ubuntu-latest`): flutter-action → `flutter build web --release`
- [x] 1.7 Add `build-windows` job (`needs: [quality]`, `windows-latest`): flutter-action → `flutter build windows --release`
- [x] 1.8 Set workflow-level `permissions: contents: read` for least privilege
- [x] 1.9 Maintain concurrency group: `${{ github.workflow }}-${{ github.head_ref || github.ref }}` with `cancel-in-progress: true`
- [x] 1.10 Add `actions/upload-artifact@v4` step after `flutter test` in `quality` job — upload `coverage/lcov.info` as artifact named `coverage-report` (required by AC3: "coverage artifact uploaded for reference")

### Task 2: Update cspell.json with Project-Specific Terms (AC: 8)

- [x] 2.1 **FIRST** run `npx cspell "**/*.md"` on current codebase to discover ALL failing terms — the baseline list in Dev Notes is a minimum, not exhaustive. `_bmad-output/` and `docs/` contain many technical terms (BDD, ATDD, brownfield, monolith, json_serializable, flutter_bloc, bloc_test, very_good_analysis, intl, Impeller, pumpApp, setUp, genhtml, etc.)
- [x] 2.2 Add ALL discovered terms + the baseline list to `.github/cspell.json` `words` array
- [x] 2.3 Verify `useGitignore: true` excludes generated files (*.g.dart, *.freezed.dart)
- [x] 2.4 Re-run `npx cspell "**/*.md"` — must produce **zero** failures before proceeding

### Task 3: Update PR Template with Testing Verification (AC: 7)

- [x] 3.1 Update `.github/PULL_REQUEST_TEMPLATE.md` — add "Testing" section with checklist: `flutter analyze` clean, `flutter test` passes, coverage maintained, platforms verified if applicable

### Task 4: Verify Dependabot Configuration (AC: 6)

- [x] 4.1 Verify `.github/dependabot.yaml` has both `github-actions` and `pub` ecosystems with daily schedule — file already exists, confirm no changes needed

### Task 5: Pipeline End-to-End Verification (AC: 9)

- [x] 5.1 Run `flutter analyze --fatal-infos` locally — confirm zero issues
- [x] 5.2 Run `dart format --output=none --set-exit-if-changed .` locally — confirm zero formatting issues
- [x] 5.3 Run `flutter test --coverage --test-randomize-ordering-seed random` locally — confirm all 373 tests pass
- [x] 5.4 **Golden test CI compatibility check** — golden baselines were generated on macOS but CI `quality` runs on ubuntu. If golden tests fail on the CI ubuntu runner: (A) preferred: regenerate baselines on ubuntu and commit updated PNGs, or (B) last resort: tag golden tests with `@Tags(['golden'])` and add `--exclude-tags golden` to the CI test command. Verify this BEFORE merging.
- [x] 5.5 Verify `flutter build web --release` succeeds locally (web is the easiest to test locally)
- [x] 5.6 Commit changes, create test PR to main → verify pipeline triggers and all jobs complete

### Task 6: Final Validation (AC: all)

- [x] 6.1 Verify workflow file YAML is valid (no syntax errors)
- [x] 6.2 Verify all acceptance criteria met against pipeline run output
- [x] 6.3 Dartdoc comments not applicable (no Dart code in this story) — verify all YAML/JSON/MD files are well-formed

## Dev Notes

### Current State — What Already Exists

The `.github/` directory already has a working baseline from the VGV CLI project generator:

```
.github/
├── PULL_REQUEST_TEMPLATE.md           # ✅ Exists — needs testing section
├── dependabot.yaml                    # ✅ Exists — daily github-actions + pub
├── cspell.json                        # ⚠️ Exists — needs more project terms
└── workflows/
    └── main.yaml                      # ⚠️ Exists — needs multi-platform builds
```

**Current `main.yaml`** uses VGV reusable workflows:
- `semantic_pull_request.yml@v1` — conventional commit enforcement → KEEP
- `flutter_package.yml@v1` — analyze + test on ubuntu only → REPLACE with custom jobs
- `spell_check.yml@v1` — markdown spell-check → KEEP

**Key gap:** VGV `flutter_package.yml` only runs `flutter analyze` + `flutter test` on a single ubuntu runner. It does NOT build for all 4 platforms. FR51 requires iOS, Android, Web, and Windows build verification.

### Pipeline Architecture — 3-Tier Job Design

- **Tier 0 (parallel, no deps):** `semantic-pull-request` (VGV reusable, PR-only via `if:`), `spell-check` (VGV reusable)
- **Tier 1 (quality gate):** `quality` on ubuntu-latest — format + analyze + test (excluding golden) + coverage upload
- **Tier 2 (needs: [quality]):** `test-goldens` (macos — golden baselines are platform-specific), `build-android` (ubuntu), `build-ios` (macos), `build-web` (ubuntu), `build-windows` (windows) — all run in parallel

**Rationale:** Quality gate on cheapest runner first. Expensive macOS (10x) / Windows (2x) runners only consume minutes if lint+test passes. Concurrency group cancels stale PR runs (push events to main always complete). Golden tests run on macOS where baselines were generated.

### Workflow File Reference — main.yaml Structure

> **This YAML is the source of truth.** Tasks describe *what* to do; this YAML shows the *target state*. When in doubt, match this output.

```yaml
name: time_money

concurrency:
  group: ${{ github.workflow }}-${{ github.head_ref || github.ref }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}

permissions:
  contents: read

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  semantic-pull-request:
    if: github.event_name == 'pull_request'
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/semantic_pull_request.yml@v1

  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - run: flutter pub get
      - run: dart format --output=none --set-exit-if-changed .
      - run: flutter analyze --fatal-infos
      - run: flutter test --coverage --test-randomize-ordering-seed random --exclude-tags golden
      - uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/lcov.info

  test-goldens:
    needs: [quality]
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v6
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - run: flutter pub get
      - run: flutter test --tags golden

  build-android:
    needs: [quality]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - run: flutter pub get
      - run: echo "::warning::CI uses debug signing — release keystore not configured"
      - run: flutter build appbundle --release --flavor production --target lib/main_production.dart

  build-ios:
    needs: [quality]
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v6
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign --flavor production --target lib/main_production.dart

  build-web:
    needs: [quality]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - run: flutter pub get
      - run: flutter build web --release --target lib/main_production.dart

  build-windows:
    needs: [quality]
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v6
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - run: flutter pub get
      - run: flutter build windows --release --target lib/main_production.dart

  spell-check:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/spell_check.yml@v1
    with:
      includes: |
        **/*.md
      modified_files_only: false
```

### Golden Tests in CI — Platform Consistency

Golden tests use Ahem font (Flutter test default) with `devicePixelRatio = 1.0` and fixed viewport sizes. The golden baselines were generated on macOS and exhibit rendering differences on Ubuntu (confirmed during implementation).

**Resolution:** Golden tests are excluded from the Ubuntu `quality` job (`--exclude-tags golden`) and run in a dedicated `test-goldens` job on `macos-latest` where the baselines were generated. This ensures golden regression detection works correctly while keeping the quality gate on the cheapest runner.

**Tag declaration:** `dart_test.yaml` at project root declares the `golden` tag to suppress undeclared-tag warnings. All golden test files use `@Tags(['golden'])` before the `library;` directive.

### cspell.json — Required Project Terms

Current words list has only 5 Spanish terms. The list below is a **baseline minimum** — Task 2.1 requires running `npx cspell "**/*.md"` to discover ALL missing terms before finalizing:

```json
"words": [
  "Contador", "localizable", "mostrado", "página", "Texto",
  "TimeMoney", "ObjectBox", "objectbox",
  "BLoC", "bloc", "Cubit", "cubit", "Cubits",
  "Drift", "fpdart", "Freezed", "freezed",
  "Dartdoc", "dartdoc", "Mocktail", "mocktail",
  "codecov", "lcov", "genhtml",
  "datasource", "datasources",
  "appbundle", "codesign",
  "pubspec", "OPFS", "WASM",
  "subosito", "temurin",
  "BMad", "BMAD"
]
```

**Known additional terms** likely needed (from `_bmad-output/` and `docs/` markdown scan): `BDD`, `ATDD`, `brownfield`, `monolith`, `json_serializable`, `flutter_bloc`, `bloc_test`, `very_good_analysis`, `intl`, `Impeller`, `pumpApp`, `setUp`, `tearDown`, `blocTest`, `matchesGoldenFile`, `pumpGoldenApp`, `NFR`, `PRD`, `CRUD`, `SOLID`, `SQLite`, `NoSQL`, `FFI`, `ARB`, among others. Run the cspell scan to get the definitive list.

### PR Template — Testing Section Addition

Add after existing "Type of Change" section:

```markdown
## Testing

- [ ] `flutter analyze` — zero warnings
- [ ] `flutter test` — all tests pass
- [ ] Coverage maintained or improved
- [ ] Platforms verified (if persistence/DI changes)
```

### Action Versions & Verification

**IMPORTANT:** Verify each action version exists before using. The YAML reference uses `actions/checkout@v6` — if v6 does not exist yet, fall back to the latest available (v4 as of mid-2025). Check https://github.com/actions/checkout/releases at implementation time.

- `actions/checkout` — v6 (verify exists; fallback v4)
- `actions/setup-java` — v4 (`distribution: temurin`, `java-version: '17'`)
- `actions/upload-artifact` — v4 (for coverage artifact upload)
- `subosito/flutter-action` — v2 (built-in pub cache with `cache: true`)
- VGV semantic PR / spell-check — @v1

### Build Environment Notes

- **Flavor and target flags required** — Project uses flavor-specific entry points (`lib/main_production.dart`, no `lib/main.dart`). Android/iOS builds require `--flavor production --target lib/main_production.dart`; Web/Windows require only `--target lib/main_production.dart` (no `--flavor` support on those platforms). CI builds are verification-only (no deployment).
- **Android signing:** CI has no release keystore — `build.gradle` falls back to debug signing with a `::warning::` annotation in the workflow log. Release signing will be configured in a future deployment story.
- **Security:** `permissions: contents: read` (least privilege), no secrets, no codesign tokens.
- **Cost awareness:** macOS runners are ~10x, Windows ~2x ubuntu cost. Build jobs and `test-goldens` gated behind `quality` to minimize waste. `cancel-in-progress` only applies to PR events; push events to main always complete full validation.

### Out of Scope

Coverage threshold enforcement, Codecov integration, release/deployment automation, issue templates, CODEOWNERS, and performance benchmarking are out of scope per the epic's 2-story structure.

### Project Structure Notes

- Primary changes in `.github/` directory; additional changes to `android/app/build.gradle` (signing fallback), `dart_test.yaml` (new), and `test/goldens/*.dart` (tag annotations)
- Alignment with architecture.md project structure tree: `.github/workflows/main.yaml`, `.github/dependabot.yaml`, `.github/cspell.json`, `.github/PULL_REQUEST_TEMPLATE.md`
- 91 Dart files in `lib/` and `test/` reformatted by `dart format` (formatting only — required for CI format check)

### References

- [epics.md#Epic 6 / Story 6.1] — AC, BDD specs, epic objectives (FR50, FR51, NFR21)
- [architecture.md#FR50-FR53] — CI/CD architecture, `.github/` directory structure
- [prd.md#FR50-FR51, NFR21] — pipeline requirements: lint, test, coverage, 4-platform builds, merge blocking
- [project-context.md] — test command, 373 tests, 92.3% coverage, zero warnings policy
- [.github/] — current baseline files: main.yaml (VGV), dependabot.yaml, cspell.json, PULL_REQUEST_TEMPLATE.md

### Previous Story Intelligence (Story 5.3)

- 373 tests passing with randomized ordering, 92.3% overall coverage
- Golden test PNGs committed to git in `test/goldens/` — CI must handle golden comparison
- `pumpGoldenApp` uses `devicePixelRatio = 1.0` and Ahem font — should be platform-deterministic
- Code review found 13 issues, applied 2 patches, 1 bad_spec — demonstrates thorough review process
- Epic 5 retrospective confirmed zero deferred items — clean foundation for Epic 6

### Git Intelligence

Recent commits follow conventional format:
- `24efdee` — `docs:` update project-context post epic 5
- `0f8048a` — `fix:` epic 5 tech debt & UX fixes
- `5e3eecf` — `docs:` epic 5 retrospective
- `cb9a219` — `fix:` code review story 5.3
- `33020e8` — `feat:` implement story 5.3

Pipeline's semantic PR validation enforces this format. All 5 epics complete, codebase is stable.

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Completion Notes List

- **Task 1:** Rewrote `.github/workflows/main.yaml` from VGV reusable workflow to custom 3-tier pipeline. Verified all action versions: checkout@v6 (v6.0.2), upload-artifact@v4 (v4.6.2), setup-java@v4, flutter-action@v2 (v2.22.0). Added `--target lib/main_production.dart` to all build commands because project uses flavor-specific entry points (no `lib/main.dart`).
- **Task 2:** Ran `npx cspell "**/*.md"` — discovered 4247 issues across 671 files. Added `ignorePaths: ["../_bmad/**"]` to exclude 448 BMad framework words. Added 190+ project-specific terms (Spanish words, technical terms, package names). Used `ignoreWords: ["open-source"]` to override VGV forbidden dictionary for 7 planning artifact occurrences. Final: zero failures across 52 project files.
- **Task 3:** Added Testing section to PR template with `flutter analyze`, `flutter test`, coverage, and platform verification checklist.
- **Task 4:** Verified existing `dependabot.yaml` — both `github-actions` and `pub` ecosystems with daily schedule confirmed. No changes needed.
- **Task 5:** `flutter analyze` zero issues; `dart format` discovered 91 files needing formatting — fixed all. 373 tests pass with random ordering. `flutter build web --release` succeeds. Golden tests fail on Ubuntu CI (macOS baselines) — applied Option C: tagged with `@Tags(['golden'])` and added `--exclude-tags golden` to CI test command. 368 tests pass in CI. All 4 platform builds verified green (PR #8, run 23415764297).
- **Task 6:** YAML and JSON validated syntactically. All 9 ACs verified against pipeline run output. Full E2E pipeline passes: quality → 4 platform builds.
- **CI Fixes (3 iterations):** (1) Added `--target lib/main_production.dart` — project uses flavor entry points, no `lib/main.dart`. (2) Added `--flavor production` — iOS/Android need explicit flavor for Xcode/Gradle build configs. (3) Android `build.gradle` signing fallback to debug when no release keystore available in CI.
- **Code Review (3 bad_spec, 3 patch, 0 defer, 11 reject):** (BS-1) Spec incorrectly stated no flavors needed — amended to document required `--flavor/--target` flags. (BS-2) Android debug signing fallback was undocumented — added `::warning::` annotation and documented in spec. (BS-3) `cancel-in-progress: true` cancelled main-branch CI on rapid merges — changed to `${{ github.event_name == 'pull_request' }}`. (P-1) Golden tests used last-resort exclusion — added dedicated `test-goldens` job on macOS to validate golden baselines in CI. (P-2) `semantic-pull-request` ran on push events — added `if: github.event_name == 'pull_request'` guard. (P-3) Missing `dart_test.yaml` for golden tag — created with tag declaration. (D-1→resolved) `_bmad/` cspell ignorePaths is correct — it's third-party framework tooling (1064 md files); `_bmad-output/` is NOT ignored and passes with zero failures. (D-2→resolved) 91 Dart format changes were necessary for CI `dart format --set-exit-if-changed` check — documented as process learning.

### File List

- `.github/workflows/main.yaml` — rewritten: custom quality + test-goldens + 4 platform build jobs
- `.github/cspell.json` — updated: 190+ words, ignorePaths, ignoreWords
- `.github/PULL_REQUEST_TEMPLATE.md` — updated: Testing section added
- `android/app/build.gradle` — release signing fallback to debug when storeFile is null
- `dart_test.yaml` — new: declares `golden` tag for test runner
- `test/goldens/create_time_dialog_golden_test.dart` — added `@Tags(['golden'])`
- `test/goldens/home_page_golden_test.dart` — added `@Tags(['golden'])`
- `test/goldens/payment_result_page_golden_test.dart` — added `@Tags(['golden'])`
- `test/goldens/update_time_dialog_golden_test.dart` — added `@Tags(['golden'])`
- 91 Dart files in `lib/` and `test/` — formatted by `dart format .` (formatting only, no logic changes)
