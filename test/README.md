# LearnHub – Test Suite

This folder contains all automated tests for the **LearnHub** Flutter application.

---

## Folder Structure

```
test/
├── bloc/                        # BLoC unit tests
│   ├── company_bloc_test.dart
│   ├── company_details_bloc_test.dart
│   ├── login_bloc_test.dart
│   ├── onboard_bloc_test.dart
│   ├── profile_bloc_test.dart
│   └── user_bloc_test.dart
│
├── features/                    # Widget tests for screen-level widgets
│   ├── company_list_widget_test.dart
│   └── user_list_widget_test.dart
│
├── models/                      # Model / serialization tests
│   └── on_board_test.dart
│
├── repositories/                # Repository unit tests
│   ├── company_repository_test.dart
│   ├── login_repository_test.dart
│   └── user_repository_test.dart
│
├── utils/                       # Utility / helper tests
│
├── integration_test/            # End-to-end integration tests
│   └── app_test.dart
│
└── mock_api.dart                # Shared MockApiService for repository tests
```

---

## Test Types

| Type | Location | Tool |
|---|---|---|
| Unit – BLoC | `bloc/` | `flutter_test` + `bloc_test` + `mocktail` |
| Unit – Repository | `repositories/` | `flutter_test` + `mocktail` |
| Unit – Model | `models/` | `flutter_test` |
| Widget | `features/` | `flutter_test` |
| Integration (E2E) | `integration_test/` | `integration_test` package |

---

## Running Tests

### All unit & widget tests
```bash
flutter test test/
```

### A specific test file
```bash
flutter test test/bloc/login_bloc_test.dart
```

### Integration tests (requires a connected device or emulator)
```bash
flutter test test/integration_test/app_test.dart -d <device_id>
```

List available devices:
```bash
flutter devices
```

### With coverage report
```bash
flutter test test/ --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Integration Test Coverage (`integration_test/app_test.dart`)

29 test cases across 8 categories:

| Category | What Is Tested |
|---|---|
| **Splash / Launch** | App renders and navigates away from splash |
| **Onboarding** | Skip button; Continue page-by-page; PageView presence |
| **Login UI** | Two text fields exist; username not obscured; password obscured |
| **Login Flow** | Enter credentials; Sign In button; complete login; invalid/empty/whitespace credentials |
| **Bottom Navigation** | Three tabs with correct icons; `currentIndex` updates on tap; tab switching |
| **User List / Detail** | Shimmer or list loads; scroll; open detail; section labels; back navigation |
| **Company List / Detail** | Shimmer or list loads; scroll; open detail; metrics; Follow button; back navigation |
| **Error Handling** | App stays stable on failed or empty login |

---

## Dependencies

Declared in `pubspec.yaml` under `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  flutter_lints: ^5.0.0

# In dependencies (also used by tests):
  bloc_test: ^10.0.0
  mocktail: ^1.0.4
```
