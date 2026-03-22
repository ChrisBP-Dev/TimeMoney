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

- [ ] 1.1 Rewrite `.github/workflows/main.yaml` — replace VGV `flutter_package.yml` with custom `quality` job on `ubuntu-latest`: checkout → `subosito/flutter-action@v2` (flutter-version from pubspec, channel stable, cache+pub-cache enabled) → `flutter pub get` → `dart format --output=none --set-exit-if-changed .` → `flutter analyze --fatal-infos` → `flutter test --coverage --test-randomize-ordering-seed random`
- [ ] 1.2 Keep `semantic-pull-request` job using VGV `semantic_pull_request.yml@v1`
- [ ] 1.3 Keep `spell-check` job using VGV `spell_check.yml@v1` with `includes: "**/*.md"` and `modified_files_only: false`
- [ ] 1.4 Add `build-android` job (`needs: [quality]`, `ubuntu-latest`): `actions/setup-java@v4` (distribution: temurin, java-version: '17') → flutter-action → `flutter build appbundle --release`
- [ ] 1.5 Add `build-ios` job (`needs: [quality]`, `macos-latest`): flutter-action → `flutter build ios --release --no-codesign`
- [ ] 1.6 Add `build-web` job (`needs: [quality]`, `ubuntu-latest`): flutter-action → `flutter build web --release`
- [ ] 1.7 Add `build-windows` job (`needs: [quality]`, `windows-latest`): flutter-action → `flutter build windows --release`
- [ ] 1.8 Set workflow-level `permissions: contents: read` for least privilege
- [ ] 1.9 Maintain concurrency group: `${{ github.workflow }}-${{ github.head_ref || github.ref }}` with `cancel-in-progress: true`

### Task 2: Update cspell.json with Project-Specific Terms (AC: 8)

- [ ] 2.1 Add comprehensive project terms to `.github/cspell.json` `words` array: TimeMoney, ObjectBox, BLoC, Cubit, Drift, fpdart, Freezed, Dartdoc, dartdoc, Mocktail, codecov, lcov, datasource, datasources, BMad, BMAD, pubspec, appbundle, codesign, riverpod (false positive prevention), and any other terms found in project markdown/dart files that would fail spell-check
- [ ] 2.2 Verify `useGitignore: true` excludes generated files (*.g.dart, *.freezed.dart)
- [ ] 2.3 Test locally: run `npx cspell "**/*.md"` to verify zero false positives

### Task 3: Update PR Template with Testing Verification (AC: 7)

- [ ] 3.1 Update `.github/PULL_REQUEST_TEMPLATE.md` — add "Testing" section with checklist: `flutter analyze` clean, `flutter test` passes, coverage maintained, platforms verified if applicable

### Task 4: Verify Dependabot Configuration (AC: 6)

- [ ] 4.1 Verify `.github/dependabot.yaml` has both `github-actions` and `pub` ecosystems with daily schedule — file already exists, confirm no changes needed

### Task 5: Pipeline End-to-End Verification (AC: 9)

- [ ] 5.1 Run `flutter analyze --fatal-infos` locally — confirm zero issues
- [ ] 5.2 Run `dart format --output=none --set-exit-if-changed .` locally — confirm zero formatting issues
- [ ] 5.3 Run `flutter test --coverage --test-randomize-ordering-seed random` locally — confirm all 373 tests pass
- [ ] 5.4 Verify `flutter build web --release` succeeds locally (web is the easiest to test locally)
- [ ] 5.5 Commit changes, create test PR to main → verify pipeline triggers and all jobs complete

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

```
┌─────────────────────┐
│  semantic-pull-req   │  (VGV reusable — commit format)
└─────────────────────┘
┌─────────────────────┐
│      quality         │  ubuntu-latest: format + analyze + test + coverage
└─────────┬───────────┘
          │ needs: [quality]
    ┌─────┼─────────────────────────┐
    │     │           │             │
┌───┴──┐ ┌┴────┐ ┌───┴──┐ ┌───────┴─┐
│android│ │ ios │ │ web  │ │ windows │
│ubuntu │ │macOS│ │ubuntu│ │ windows │
└──────┘ └─────┘ └──────┘ └─────────┘
┌─────────────────────┐
│    spell-check       │  (VGV reusable — parallel, no deps)
└─────────────────────┘
```

**Rationale:** Quality gate runs first on cheapest runner (ubuntu). Expensive macOS/Windows runners only consume minutes if lint+test passes. Build jobs run in parallel after quality gate.

### Workflow File Reference — main.yaml Structure

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
    runs-on: windows-latest
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

Current words list has only 5 Spanish terms. Add all domain terminology to prevent false positives:

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

Scan actual markdown files for additional terms that would fail before finalizing.

### PR Template — Testing Section Addition

Add after existing "Type of Change" section:

```markdown
## Testing

- [ ] `flutter analyze` — zero warnings
- [ ] `flutter test` — all tests pass
- [ ] Coverage maintained or improved
- [ ] Platforms verified (if persistence/DI changes)
```

### Action Versions (March 2026)

| Action | Version | Notes |
|--------|---------|-------|
| `actions/checkout` | v6 | |
| `actions/setup-java` | v4 | `distribution: temurin`, `java-version: '17'` |
| `subosito/flutter-action` | v2 (v2.22.0) | Supports Flutter 3.41+, built-in cache |
| VGV semantic PR | @v1 | Enforces conventional commits |
| VGV spell-check | @v1 | Uses cspell internally |

### Runner Cost Awareness

| Job | Runner | Relative Cost |
|-----|--------|---------------|
| quality | ubuntu-latest | 1x (base) |
| build-android | ubuntu-latest | 1x |
| build-web | ubuntu-latest | 1x |
| build-ios | macos-latest | 10x (Apple Silicon) |
| build-windows | windows-latest | 2x |

Build jobs are gated behind `quality` to avoid wasting expensive macOS/Windows minutes on code that fails lint/test. Concurrency group cancels stale runs.

### Security Best Practices

- `permissions: contents: read` at workflow level (least privilege)
- No secrets used — no codesign, no deployment tokens
- Concurrency groups prevent resource waste
- `cancel-in-progress: true` safe for PR validation (NOT for deployments)

### This Story Does NOT Include

- Coverage threshold enforcement in CI (Nice-to-have for future)
- Coverage badge/reporting service integration (e.g., Codecov)
- Release/deployment automation
- Issue templates
- CODEOWNERS file
- Performance benchmarking
These are explicitly out of scope per the epic's 2-story structure.

### Project Structure Notes

- All changes are in `.github/` directory — no Dart code changes
- Alignment with architecture.md project structure tree: `.github/workflows/main.yaml`, `.github/dependabot.yaml`, `.github/cspell.json`, `.github/PULL_REQUEST_TEMPLATE.md`
- No new directories created — all files exist; only content changes

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 6.1] — acceptance criteria and BDD specs
- [Source: _bmad-output/planning-artifacts/epics.md#Epic 6] — epic objectives: CI/CD pipeline, professional README, Dependabot, code quality cleanup
- [Source: _bmad-output/planning-artifacts/architecture.md#FR50-FR53] — CI/CD architecture mapping, `.github/` directory structure
- [Source: _bmad-output/planning-artifacts/prd.md#FR50] — CI pipeline: linting, testing, coverage on every PR
- [Source: _bmad-output/planning-artifacts/prd.md#FR51] — CI pipeline: build verification for all four platforms
- [Source: _bmad-output/planning-artifacts/prd.md#NFR21] — CI pipeline must pass before merge to main
- [Source: _bmad-output/project-context.md#Development Workflow Rules] — CI/CD: GitHub Actions with semantic PR, flutter_package, spell-check
- [Source: _bmad-output/project-context.md#Testing Rules] — test command: `flutter test --coverage --test-randomize-ordering-seed random`, 373 tests, 92.3% coverage
- [Source: _bmad-output/project-context.md#Code Quality] — zero warnings policy, `flutter analyze` must pass clean
- [Source: .github/workflows/main.yaml] — current VGV reusable workflow baseline
- [Source: .github/dependabot.yaml] — current Dependabot configuration
- [Source: .github/cspell.json] — current spell-check configuration
- [Source: .github/PULL_REQUEST_TEMPLATE.md] — current PR template

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

{{agent_model_name_version}}

### Debug Log References

### Completion Notes List

### File List
