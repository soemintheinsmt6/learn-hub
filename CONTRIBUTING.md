# Contributing to LearnHub

Thanks for taking the time to contribute! This guide covers the basics for
getting set up and submitting changes.

## Prerequisites

- Flutter (stable channel) — see [`pubspec.yaml`](pubspec.yaml) for the
  required Dart SDK constraint.
- A configured `.env` file. Copy the template and fill in the base URL:

  ```bash
  cp .env.example .env
  ```

## Getting started

```bash
flutter pub get
flutter run
```

## Project layout

The app follows Clean Architecture with a feature-based folder structure
(`data` / `domain` / `presentation` per feature). See the
[Architecture section in the README](README.md#architecture) for details.

## Before opening a pull request

Run the same checks CI runs, locally:

```bash
dart format .                 # format code
flutter analyze               # static analysis (lints)
flutter test --coverage       # unit & widget tests
```

All three must pass. CI enforces formatting (`dart format --set-exit-if-changed`),
analysis, and tests on every pull request.

## Pull request guidelines

- Keep PRs focused — one logical change per PR.
- Add or update tests for any behavior you change.
- Write a clear description (the PR template will prompt you).
- Reference any related issue with `Closes #123`.

## Commit messages

Use clear, imperative subject lines (e.g. `fix: handle 401 on token refresh`).
Conventional Commit prefixes (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`)
are encouraged but not required.
