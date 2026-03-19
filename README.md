# learn_hub

LearnHub is a Flutter application showcasing a compact but complete architecture stack:

- Onboarding flow with multiple pages
- Authentication (login screen with validation)
- Bottom navigation with nested tabs
- User profile, user list, company list, and detail screens backed by a REST API
- BLoC for state management
- Clean Architecture with feature-based organization
- Dependency injection with GetIt

The project follows Clean Architecture principles, organizing code by feature with clear
data/domain/presentation layers for better maintainability and scalability.

## Features

- Onboarding screens with SVG illustrations, skip button, smooth page indicator,
  and Continue/Sign In button (`lib/features/onboarding/presentation/screens/on_boarding_screen.dart`)
- Splash screen with centered logo (`lib/features/onboarding/presentation/screens/splash_screen.dart`)
- Login with username and password, including empty-field and min-length validation
  (`lib/features/auth/presentation/screens/login_screen.dart`)
- Home tab showing a user profile fetched from `users/1` with "About Me" and
  "My Skills" sections (`lib/features/home/presentation/screens/home_screen.dart`)
- User list tab with avatars and basic info (`lib/features/user/presentation/screens/user_list.dart`),
  including shimmer skeleton loading while data is fetched;
  tapping a user opens a full user details screen with profile photo, stats,
  "About Me", "My Skills", and personal information
  (`lib/features/user/presentation/screens/user_details_screen.dart`)
- Company list tab with card-style tiles, progress indicator, and shimmer skeleton loading
  (`lib/features/company/presentation/screens/company_list.dart`); tapping a company opens
  a company details screen with hero banner, metrics, and company information
  (`lib/features/company/presentation/screens/company_details_screen.dart`)
- Bottom navigation to switch between Home, Users, and Companies
  (`lib/features/home/presentation/screens/bottom_navigation_screen.dart`)
- API integration via a configurable `ApiClient` (`lib/core/network/api_client.dart`)
- Centralized API endpoint constants (`lib/core/network/api_endpoint.dart`)
- Error handling using a custom `ApiException` and alert/snackbar widgets

## Architecture

The app follows Clean Architecture with a feature-based folder structure. Each feature
contains its own data, domain, and presentation layers:

- **Presentation layer (UI + BLoC)**
    - Screens and widgets live inside each feature's `presentation/` folder.
    - Shared UI components live in `lib/shared/widgets/`.
    - BLoC classes hold the presentation logic and expose states to the UI.

- **Domain layer**
    - Abstract repository interfaces define the contract for data access.
    - Entities (`User`, `Company`, `OnBoard`) define the app's core data structures and
      serialization logic.

- **Data layer**
    - Repository implementations in each feature's `data/repositories/` folder fulfill
      the domain contracts using `ApiClient`.

- **Core layer**
    - `ApiClient` in `lib/core/network/` wraps HTTP calls, shared headers, token
      handling, and response/error handling.
    - `ApiEndpoint` in `lib/core/network/` centralizes all API endpoint paths as
      static constants and helper methods (e.g., `ApiEndpoint.login`,
      `ApiEndpoint.userById(id)`).
    - `ApiException` in `lib/core/error/` provides typed error handling.
    - `AppConfig` in `lib/core/app_config.dart` holds configuration like `baseUrl`.
    - Dependency injection setup in `lib/core/di/injection.dart` uses GetIt to register
      singletons.
    - Utility helpers in `lib/core/utils/` (colors, navigation, text field decoration,
      data formatting).

### Flow example: User list

1. `UserList` screen (`lib/features/user/presentation/screens/user_list.dart`) creates a
   `UserBloc` and injects the `UserRepository` from GetIt.
2. On initialization, `UserBloc` receives a `LoadUser` event.
3. `UserBloc` (`lib/features/user/presentation/bloc/user_bloc/user_bloc.dart`) calls
   `UserRepository.fetchUsers()`.
4. `UserRepositoryImpl` (`lib/features/user/data/repositories/user_repository_impl.dart`)
   calls `ApiClient.get(ApiEndpoint.users)`.
5. The JSON response is mapped to `User` entities and returned.
6. `UserBloc` emits loading, success, or error states, and the UI rebuilds with a shimmer
   skeleton, error message, or `ListView` of `UserTile` widgets.

The company list follows the same pattern using `CompanyBloc`, `CompanyRepository`, and
`Company` entities.

## Design patterns

- **BLoC (Business Logic Component)**
    - Implemented with `flutter_bloc`.
    - Each feature has its own BLoC(s):
        - `LoginBloc` (`lib/features/auth/presentation/bloc/login_bloc/`)
        - `UserBloc` (`lib/features/user/presentation/bloc/user_bloc/`)
        - `ProfileBloc` (`lib/features/user/presentation/bloc/profile_bloc/`)
        - `CompanyBloc` (`lib/features/company/presentation/bloc/company_bloc/`)
        - `CompanyDetailsBloc` (`lib/features/company/presentation/bloc/company_details_bloc/`)
        - `OnBoardBloc` (`lib/features/onboarding/presentation/bloc/onboarding_bloc/`)
    - Events represent user actions or lifecycle events (`*_event.dart`).
    - States capture UI-relevant data (`*_state.dart`), commonly including `isLoading`, data
      collections, and `error`.

- **Repository pattern**
    - Abstract interfaces in `domain/repositories/` define contracts.
    - Implementations in `data/repositories/` fulfill those contracts using `ApiClient`.
    - This keeps HTTP details out of BLoCs and widgets and makes the code easier to test.

- **Service layer**
    - `ApiClient` centralizes HTTP logic (headers, base URL, token, error handling).
    - Other parts of the app depend on the service via repositories, not on the raw `http` client.

- **Dependency injection with GetIt**
    - `setupDependencies()` in `lib/core/di/injection.dart` registers `ApiClient` and all
      repository implementations as lazy singletons.
    - BLoCs and screens resolve dependencies via `getIt<T>()`.

- **Value equality with `Equatable`**
    - BLoC states and some data classes extend `Equatable` to support value-based equality, which
      reduces unnecessary rebuilds and simplifies testing.

## Folder structure

```text
lib/
  core/
    di/
      injection.dart              # GetIt dependency registration
    error/
      api_exception.dart          # Custom API exception
    network/
      api_endpoint.dart           # Centralized API endpoint constants
      api_client.dart            # HTTP client with token handling
    utils/
      app_color.dart              # Color constants
      company_data_formatter.dart # Formatting helpers
      navigation.dart             # Navigation utilities
      text_field_decoration.dart  # Input decoration helpers
    app_config.dart               # Environment configuration
  features/
    auth/
      data/repositories/
        login_repository_impl.dart
      domain/repositories/
        login_repository.dart
      presentation/
        bloc/login_bloc/
        screens/login_screen.dart
    company/
      data/repositories/
        company_repository_impl.dart
      domain/
        entities/company.dart
        repositories/company_repository.dart
      presentation/
        bloc/company_bloc/
        bloc/company_details_bloc/
        screens/company_list.dart
        screens/company_details_screen.dart
        widgets/company_tile.dart
        widgets/company_list_shimmer.dart
    home/
      presentation/screens/
        bottom_navigation_screen.dart
        home_screen.dart
    onboarding/
      domain/entities/on_board.dart
      presentation/
        bloc/onboarding_bloc/
        screens/on_boarding_screen.dart
        screens/splash_screen.dart
        widgets/on_board_tile.dart
    user/
      data/repositories/
        user_repository_impl.dart
      domain/
        entities/user.dart
        repositories/user_repository.dart
      presentation/
        bloc/user_bloc/
        bloc/profile_bloc/
        screens/user_list.dart
        screens/user_details_screen.dart
        widgets/user_tile.dart
        widgets/user_list_shimmer.dart
  shared/
    widgets/
      alerts/alert.dart, snack_bar.dart
      buttons/bar_button.dart
      images/cached_image.dart, svg_image.dart
      text_fields/custom_text_field.dart
      tiles/skill_tile.dart
      custom_progress_indicator.dart
      info_row.dart
      metric_card.dart
      profile_card.dart
  main.dart

test/
  bloc/
    company_bloc_test.dart
    company_details_bloc_test.dart
    login_bloc_test.dart
    onboard_bloc_test.dart
    profile_bloc_test.dart
    user_bloc_test.dart
  core/
    di/injection_test.dart
    error/api_exception_test.dart
    network/api_client_test.dart
  features/
    company_list_widget_test.dart
    user_list_widget_test.dart
  models/
    company_test.dart
    on_board_test.dart
    user_test.dart
  repositories/
    company_repository_test.dart
    login_repository_test.dart
    user_repository_test.dart
  utils/
    company_data_formatter_test.dart
  mock_api.dart

integration_test/
  app_test.dart
```

## Testing

The project includes unit tests, widget tests, and an integration test:

- **Entity tests** (`test/models/`) verify JSON serialization/deserialization, computed
  properties, and placeholder instances for `Company`, `User`, and `OnBoard`.
- **Repository tests** (`test/repositories/`) verify API calls, JSON mapping, and error
  propagation using a mocked `ApiClient`.
- **BLoC tests** (`test/bloc/`) verify state transitions for success and error flows.
- **Core tests** (`test/core/`) cover `ApiClient` response handling and header construction,
  `ApiException` behavior, and dependency injection registration.
- **Widget tests** (`test/features/`) verify `CompanyList` and `UserList` screen rendering.
- **Utility tests** (`test/utils/`) cover data formatting helpers.
- **Integration test** (`integration_test/`) boots the full app and verifies the main
  flow.

Run all tests:

```bash
flutter test
```

Run tests with coverage:

```bash
flutter test --coverage
```

Run only the integration tests:

```bash
flutter test integration_test
```

## CI/CD

The project uses GitHub Actions for continuous integration and delivery:

- **Test workflow** (`.github/workflows/test.yml`) — runs `flutter analyze` and the full
  test suite with coverage on every push to `main` and on pull requests.
- **Android build** (`.github/workflows/build_android.yml`) — builds a release APK on push
  to the `deploy` branch and uploads it as an artifact.
- **iOS build** (`.github/workflows/build_ios.yml`) — builds for iOS on push to the
  `deploy` branch.

All workflows use dependency caching for faster builds and retain artifacts for 14 days.

## Running the app

1. Ensure Flutter SDK is installed and on your `PATH`.
2. Create a `.env` file in the project root and configure the API base URL referenced
   by `AppConfig`.
3. Fetch dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```
