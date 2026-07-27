# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository overview

Monorepo for WorkoutRide, a cycling workout app: `backend/` (Rails 8 + Grape API) and `frontend/` (Flutter + Riverpod). Production runs on a single GCE VM via Kamal (`backend/config/deploy.yml`), with Postgres on Neon and Firebase (Auth-adjacent token issuance, Crashlytics, App Distribution) on the frontend side.

## Commands

### Frontend (`frontend/`)

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after any Freezed/Riverpod(@riverpod)/Retrofit annotated file changes
flutter test                                                 # full suite
flutter test test/path/to/some_test.dart                     # single file
flutter test test/path/to/some_test.dart --plain-name 'test name'  # single test
flutter analyze
dart format <specific changed files>   # NEVER `dart format lib test` (whole-tree) — it silently reformats unrelated files and creates noisy diffs. Scope to the files you actually touched.
flutter run -d <device-id>             # flutter devices to list; requires frontend/.env (API_BASE_URL, DEBUG_AUTH_TOKEN)
```

iOS-specific (this project's iOS build is young — CI never builds it, only Android does):
- First time on a machine: `flutter precache --ios` before `cd ios && pod install`, otherwise pod install fails looking for `Flutter.xcframework`.
- `ios/Podfile` pins `platform :ios, '13.0'` (required by `audioplayers_darwin`); the Runner target's `IPHONEOS_DEPLOYMENT_TARGET` must match or CocoaPods will fail to resolve.
- `GoogleService-Info.plist` must exist at `ios/Runner/GoogleService-Info.plist` (gitignored, not in CI) AND be registered in the Xcode project's Copy Bundle Resources — dropping the file in Finder is not enough, it must be added as a resource (e.g. via the `xcodeproj` Ruby gem or Xcode itself), or `Firebase.initializeApp()` throws `core/not-initialized` at runtime.
- App icon source: `assets/icon/app_icon.png` + `app_icon_foreground.png`, configured via `flutter_launcher_icons.yaml` (regenerate with `dart run flutter_launcher_icons`) and `flutter_native_splash` config in `pubspec.yaml` (regenerate with `dart run flutter_native_splash:create`). `assets/images/ic_splash.png` is a stale unused placeholder — don't reintroduce it.

### Backend (`backend/`)

```
bundle install
RAILS_ENV=test bundle exec rails db:schema:load   # first-time / after schema changes
bundle exec rspec                                  # full suite
bundle exec rspec spec/path/to/some_spec.rb         # single file
bundle exec rspec spec/path/to/some_spec.rb:42      # single example by line
bundle exec rails console
bundle exec rails routes
bundle exec rake grape:routes                       # Grape-specific route listing (method/path/description)
```

### CI

`.github/workflows/ci.yml` runs backend RSpec + frontend `flutter test` + Android debug APK build on every push/PR. There is no iOS CI job. `release-app-distribution.yml` is a manual `workflow_dispatch` (`gh workflow run release-app-distribution.yml --ref main -f build_type=debug|release`) that builds and pushes an APK to Firebase App Distribution (testers: the developer's own email, hardcoded in the workflow). `deploy-production.yml` runs Kamal deploy on push to `main`.

## Architecture

### Frontend — layered Clean Architecture (Riverpod)

The authoritative spec is **`docs/architecture.md`** — read it before making structural changes; it defines the target architecture, dependency rules, and an explicit list of current deviations with a migration plan. Key points:

- Layers: `ui/` (View + ViewModel, one pair per screen) → optional `domain/usecase/` → `domain/repository/` (interface) + `data/repository/` (impl) → `data/remote|ble_connector|audio` (Service, wraps exactly one external data source, Future/Stream only, no state).
- **Golden rule**: `domain/` must never import from `data/`. DTOs (`data/remote/model/`) never cross into `domain/` or `ui/`; only domain models do. Convert DTO↔domain in the data layer (Repository impl or an `extensions.dart` `toDomain()`).
- State management is `@riverpod` codegen `Notifier`/`class` providers only — never the old `StateNotifier`/`StateProvider`.
- UseCases are **not** the default — only introduce one when it integrates multiple repositories, encapsulates genuinely complex/reusable logic (e.g. `ManageWorkoutUseCase`'s state machine, `WorkoutResultRecorder`'s aggregation), or is reused across ViewModels. A UseCase that's just `repo.someMethod()` with no added logic should not exist; ViewModels call repositories directly for simple reads/writes.
- Views hold zero business logic — no data fetching, no DTO construction; everything lives in the ViewModel's `UiState` (Freezed).

### Backend — Grape API + simple token auth

- API lives in `app/api/v1/*.rb`, mounted through `app/api/root.rb` → `app/api/v1/root.rb`. Grape helpers must be wired with `helpers do include ::Helpers::AuthHelper end` (a bare `include` does not make the helper methods available inside endpoint blocks).
- Auth is a custom bearer token (not JWT): Google ID token → verified server-side via `Google::Auth::IDTokens.verify_oidc` (`googleauth` gem) → app issues its own 64-char `SecureRandom` token, 30-day expiry, stored in `auth_tokens` as a SHA256 digest only (`AuthToken#token` — the raw value — exists only in memory at creation time and is never persisted, so a lost token can't be recovered, only reissued).
- Debug builds skip Google Sign-In via a "Skip Login" button that reads `DEBUG_AUTH_TOKEN` from `frontend/.env` and authenticates as the system user (`provider: 'system', uid: 'system'`). When that token expires (30 days), reissue it against production: SSH to the deploy VM (`ios/Podfile`-adjacent `config/deploy.yml` has the host/user), find the running backend container (`docker ps`), then `docker exec <container> bin/rails runner "u=User.find_or_create_by!(provider: 'system', uid: 'system'); puts AuthToken.create!(user: u).token"`, and update `frontend/.env`.

## Working conventions

- This is a monorepo but changes are usually scoped to one PR per logical change (small, single-purpose PRs merged after CI is green), not one giant PR per feature.
