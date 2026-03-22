# Story 6.1: GitHub Actions CI/CD Pipeline

Status: ready-for-dev

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

- [ ] 1.1 Rewrite `.github/workflows/main.yaml` — replace VGV `flutter_package.yml` with custom `quality` job on `ubuntu-latest`: checkout → `subosito/flutter-action@v2` (channel stable, cache enabled — do NOT pin flutter-version, use latest stable) → `flutter pub get` → `dart format --output=none --set-exit-if-changed .` → `flutter analyze --fatal-infos` → `flutter test --coverage --test-randomize-ordering-seed random` → upload coverage artifact
- [ ] 1.2 Keep `semantic-pull-request` job using VGV `semantic_pull_request.yml@v1`
- [ ] 1.3 Keep `spell-check` job using VGV `spell_check.yml@v1` with `includes: "**/*.md"` and `modified_files_only: false`
- [ ] 1.4 Add `build-android` job (`needs: [quality]`, `ubuntu-latest`): `actions/setup-java@v4` (distribution: temurin, java-version: '17') → flutter-action → `flutter build appbundle --release`
- [ ] 1.5 Add `build-ios` job (`needs: [quality]`, `macos-latest`): flutter-action → `flutter build ios --release --no-codesign`
- [ ] 1.6 Add `build-web` job (`needs: [quality]`, `ubuntu-latest`): flutter-action → `flutter build web --release`
- [ ] 1.7 Add `build-windows` job (`needs: [quality]`, `windows-latest`): flutter-action → `flutter build windows --release`
- [ ] 1.8 Set workflow-level `permissions: contents: read` for least privilege
- [ ] 1.9 Maintain concurrency group: `${{ github.workflow }}-${{ github.head_ref || github.ref }}` with `cancel-in-progress: true`
- [ ] 1.10 Add `actions/upload-artifact@v4` step after `flutter test` in `quality` job — upload `coverage/lcov.info` as artifact named `coverage-report` (required by AC3: "coverage artifact uploaded for reference")

### Task 2: Update cspell.json with Project-Specific Terms (AC: 8)

- [ ] 2.1 **FIRST** run `npx cspell "**/*.md"` on current codebase to discover ALL failing terms — the baseline list in Dev Notes is a minimum, not exhaustive. `_bmad-output/` and `docs/` contain many technical terms (BDD, ATDD, brownfield, monolith, json_serializable, flutter_bloc, bloc_test, very_good_analysis, intl, Impeller, pumpApp, setUp, genhtml, etc.)
- [ ] 2.2 Add ALL discovered terms + the baseline list to `.github/cspell.json` `words` array
- [ ] 2.3 Verify `useGitignore: true` excludes generated files (*.g.dart, *.freezed.dart)
- [ ] 2.4 Re-run `npx cspell "**/*.md"` — must produce **zero** failures before proceeding

### Task 3: Update PR Template with Testing Verification (AC: 7)

- [ ] 3.1 Update `.github/PULL_REQUEST_TEMPLATE.md` — add "Testing" section with checklist: `flutter analyze` clean, `flutter test` passes, coverage maintained, platforms verified if applicable

### Task 4: Verify Dependabot Configuration (AC: 6)

- [ ] 4.1 Verify `.github/dependabot.yaml` has both `github-actions` and `pub` ecosystems with daily schedule — file already exists, confirm no changes needed

### Task 5: Pipeline End-to-End Verification (AC: 9)

- [ ] 5.1 Run `flutter analyze --fatal-infos` locally — confirm zero issues
- [ ] 5.2 Run `dart format --output=none --set-exit-if-changed .` locally — confirm zero formatting issues
- [ ] 5.3 Run `flutter test --coverage --test-randomize-ordering-seed random` locally — confirm all 373 tests pass
- [ ] 5.4 **Golden test CI compatibility check** — golden baselines were generated on macOS but CI `quality` runs on ubuntu. If golden tests fail on the CI ubuntu runner: (A) preferred: regenerate baselines on ubuntu and commit updated PNGs, or (B) last resort: tag golden tests with `@Tags(['golden'])` and add `--exclude-tags golden` to the CI test command. Verify this BEFORE merging.
- [ ] 5.5 Verify `flutter build web --release` succeeds locally (web is the easiest to test locally)
- [ ] 5.6 Commit changes, create test PR to main → verify pipeline triggers and all jobs complete

### Task 6: Final Validation (AC: all)

- [ ] 6.1 Verify workflow file YAML is valid (no syntax errors)
- [ ] 6.2 Verify all acceptance criteria met against pipeline run output
- [ ] 6.3 Dartdoc comments not applicable (no Dart code in this story) — verify all YAML/JSON/MD files are well-formed

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

- **Tier 0 (parallel, no deps):** `semantic-pull-request` (VGV reusable), `spell-check` (VGV reusable)
- **Tier 1 (quality gate):** `quality` on ubuntu-latest — format + analyze + test + coverage upload
- **Tier 2 (needs: [quality]):** `build-android` (ubuntu), `build-ios` (macos), `build-web` (ubuntu), `build-windows` (windows) — all run in parallel

**Rationale:** Quality gate on cheapest runner first. Expensive macOS (10x) / Windows (2x) runners only consume minutes if lint+test passes. Concurrency group cancels stale runs.

### Workflow File Reference — main.yaml Structure

> **This YAML is the source of truth.** Tasks describe *what* to do; this YAML shows the *target state*. When in doubt, match this output.

```yaml
name: time_money

concurrency:
  group: ${{ github.workflow }}-${{ github.head_ref || github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  semantic-pull-request:
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
      - run: flutter test --coverage --test-randomize-ordering-seed random
      - uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/lcov.info

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
      - run: flutter build appbundle --release

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
      - run: flutter build ios --release --no-codesign

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
      - run: flutter build web --release

  build-windows:
    needs: [quality]
    runs-on: windows-latest  # includes Visual Studio/MSVC toolchain required for Flutter Windows builds
    steps:
      - uses: actions/checkout@v6
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - run: flutter pub get
      - run: flutter build windows --release

  spell-check:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/spell_check.yml@v1
    with:
      includes: |
        **/*.md
      modified_files_only: false
```

### Golden Tests in CI — Platform Consistency

Golden tests use Ahem font (Flutter test default) with `devicePixelRatio = 1.0` and fixed viewport sizes. These are platform-deterministic for layout and color rendering. The golden baselines were generated on macOS but CI `quality` job runs on ubuntu.

**If golden comparison fails on CI due to minor platform rendering differences:**
- Option A (preferred): Regenerate golden baselines on ubuntu to match CI runner, commit updated PNGs
- Option B: Add `--update-goldens` flag in CI and diff the output (not recommended — defeats regression purpose)
- Option C: Skip golden tests in CI via `--exclude-tags golden` (requires tagging — last resort)

Most Flutter projects with Ahem font + fixed pixel ratio see no platform differences. Test first before adding workarounds.

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

- **No flavor/environment needed** — CI builds are verification-only (no deployment). Default Flutter build with no `--dart-define` or flavor flags.
- **Security:** `permissions: contents: read` (least privilege), no secrets, no codesign tokens.
- **Cost awareness:** macOS runners are ~10x, Windows ~2x ubuntu cost. Build jobs gated behind `quality` to minimize waste.

### Out of Scope

Coverage threshold enforcement, Codecov integration, release/deployment automation, issue templates, CODEOWNERS, and performance benchmarking are out of scope per the epic's 2-story structure.

### Project Structure Notes

- All changes are in `.github/` directory — no Dart code changes
- Alignment with architecture.md project structure tree: `.github/workflows/main.yaml`, `.github/dependabot.yaml`, `.github/cspell.json`, `.github/PULL_REQUEST_TEMPLATE.md`
- No new directories created — all files exist; only content changes

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

<!-- filled by dev agent at implementation time -->

### Completion Notes List

<!-- dev agent logs decisions, issues encountered, and resolution notes here -->

### File List

<!-- dev agent lists all files created or modified -->
