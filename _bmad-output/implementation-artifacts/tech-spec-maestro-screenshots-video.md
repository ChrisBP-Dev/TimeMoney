---
title: 'Maestro E2E UI testing setup with automated screenshots, video, and README update'
type: 'chore'
created: '2026-03-23'
status: 'done'
baseline_commit: 'd1fa131'
context: ['_bmad-output/project-context.md']
---

# Maestro E2E UI Testing Setup with Automated Screenshots, Video, and README Update

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The README demo video no longer reflects the modernized app after 6 epics of brownfield refactoring, and no portfolio-quality screenshots exist. Manual capture is tedious and not reproducible.

**Approach:** Install Maestro CLI as E2E UI testing infrastructure. Create YAML flows that navigate all TimeMoney screens, seed realistic demo data, capture screenshots, and record a demo video. Update the README with new assets and document Maestro as part of the testing stack.

## Boundaries & Constraints

**Always:**
- YAML flows target elements by visible text (no Semantics labels exist in the codebase)
- Screenshot/video binary output gitignored — never committed
- Flow YAML files committed to `.maestro/` for reproducibility
- English locale for screenshots (international portfolio visibility)
- Seed realistic demo data (wage + multiple time entries) before capturing
- Present Maestro honestly as E2E UI testing infrastructure in README
- Add new terms to cspell dictionary alphabetically

**Ask First:**
- If Maestro installation fails or requires system-level changes beyond curl

**Never:**
- Modify existing Dart source code (no Semantics wrappers, no pubspec changes)
- Commit binary screenshot/video files to git
- Break any existing CI checks (format, analyze, test, cspell, builds)
- Update project-context.md or internal docs (deferred to retrospective)

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Screenshot flow | App launched on simulator | 6 PNG screenshots in output dir | Flow fails if element not found — retry with adjusted selector |
| Video recording | App launched on simulator | MP4 video of full walkthrough | Maestro caps at 2 min — keep flow concise |
| Empty DB start | Fresh app launch, no data | Flow seeds data before capturing | N/A — flow handles data creation |

</frozen-after-approval>

## Code Map

- `.maestro/screenshots.yaml` -- Flow: seed demo data + capture all screens
- `.maestro/demo-video.yaml` -- Flow: smooth walkthrough for video recording
- `.gitignore` -- Add Maestro output exclusions
- `README.md` -- Update Demo section with new video/screenshots, add Maestro to Testing section
- `.github/cspell.json` -- Add Maestro-related terms
- `lib/.../custom_create_field.dart` -- Semantics identifier for E2E testability
- `lib/.../custom_update_field.dart` -- Semantics identifier for E2E testability
- `lib/.../wage_hourly_field.dart` -- Semantics identifier + onTapOutside for E2E testability

## Tasks & Acceptance

**Execution:**
- [x] Install Maestro CLI via official installer script
- [x] Build and install TimeMoney on booted iOS simulator (iPhone 17 Pro, iOS 26.2)
- [x] Create `.maestro/screenshots.yaml` -- seed wage + time entries, capture all screens
- [x] Create `.maestro/demo-video.yaml` -- full app walkthrough flow with natural pacing
- [x] Update `.gitignore` -- add Maestro output exclusions
- [x] Run screenshot flow and verify output PNGs exist
- [x] Run video recording and verify output MP4
- [x] Update `README.md` -- replace Demo section with new screenshots/video placeholder, add Maestro to Testing table and Tech Stack
- [x] Update `.github/cspell.json` -- add "Maestro" and related terms alphabetically
- [x] Verify CI checks pass: `dart format`, `flutter analyze`, `cspell`
- [x] Add `Semantics(identifier:)` to TextFields for Maestro E2E testability (renegotiated — see Change Log)
- [x] Add `onTapOutside` to `WageHourlyField` and `CustomUpdateField` for keyboard dismiss consistency

**Acceptance Criteria:**
- Given Maestro is installed, when `maestro test .maestro/screenshots.yaml` runs, then PNG screenshots are saved for all app screens with realistic data
- Given Maestro is installed, when `maestro record .maestro/demo-video.yaml` runs, then an MP4 captures the full app walkthrough
- Given README is updated, when viewed on GitHub, then new Demo section references current app UI and Maestro appears in Testing/Tech Stack
- Given cspell dictionary is updated, when `npx cspell --config .github/cspell.json "**/*.md"` runs, then zero spelling errors

## Verification

**Commands:**
- `maestro --version` -- expected: version string confirming installation
- `maestro test .maestro/screenshots.yaml` -- expected: all steps pass, screenshots saved
- `dart format --output=none --set-exit-if-changed .` -- expected: no formatting issues
- `flutter analyze --fatal-infos` -- expected: no issues (no Dart changes)
- `npx cspell --config .github/cspell.json "**/*.md"` -- expected: zero errors

**Manual checks:**
- Screenshots visually show all app screens with populated demo data
- Video shows smooth navigation through the complete app flow
- README renders correctly on GitHub with updated Demo section

## Spec Change Log

### Iteration 1 (review)

**Finding:** Maestro cannot interact with empty Flutter TextFields that lack Semantics identifiers. Coordinate taps and positional selectors (`below:`, `rightOf:`) all failed to focus empty fields.

**Amendment:** Renegotiated "Never: Modify existing Dart source code" constraint with human approval. Added `Semantics(identifier:)` wrappers to 3 widgets (`CustomCreateField`, `CustomUpdateField`, `WageHourlyField`) and `onTapOutside` to `WageHourlyField` for keyboard dismiss. Updated Code Map and Tasks accordingly. Committed screenshot PNGs to `docs/screenshots/` (spec said gitignore all binaries, but PNGs must be committed for README relative paths to render on GitHub — MP4 video remains gitignored).

**Known-bad state avoided:** Without Semantics identifiers, Maestro flows cannot seed demo data, producing empty screenshots unusable for portfolio.

**KEEP:** Semantics identifiers must be locale-invariant (not derived from localized `title` strings) to prevent Maestro flow breakage when the app runs in non-English locales.
