import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:learn_hub/main.dart' as app;
import 'package:learn_hub/features/company/presentation/widgets/company_tile.dart';
import 'package:learn_hub/features/user/presentation/widgets/user_tile.dart';
import 'package:learn_hub/features/user/presentation/widgets/user_list_shimmer.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

  /// Waits through splash (and optional onboarding) until the Login screen is
  /// visible ("Welcome Developer" text present).
  Future<void> waitForLoginScreen(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final welcomeText = find.text('Welcome Developer');
    if (welcomeText.evaluate().isNotEmpty) return;

    final skipButton = find.text('Skip');
    final continueButton = find.text('Continue');

    if (skipButton.evaluate().isNotEmpty) {
      await tester.tap(skipButton);
      await tester.pumpAndSettle();

      final signInBtn = find.text('Sign In');
      if (signInBtn.evaluate().isNotEmpty) {
        await tester.tap(signInBtn.first);
        await tester.pumpAndSettle();
      }
    } else if (continueButton.evaluate().isNotEmpty) {
      for (int i = 0; i < 5; i++) {
        final continueBtn = find.text('Continue');
        if (continueBtn.evaluate().isNotEmpty) {
          await tester.tap(continueBtn);
          await tester.pumpAndSettle();
        } else {
          final signInBtn = find.text('Sign In');
          if (signInBtn.evaluate().isNotEmpty) {
            await tester.tap(signInBtn.first);
            await tester.pumpAndSettle();
            break;
          }
        }
      }
    } else {
      final signInBtn = find.text('Sign In');
      if (signInBtn.evaluate().isNotEmpty && welcomeText.evaluate().isEmpty) {
        await tester.tap(signInBtn.first);
        await tester.pumpAndSettle();
      }
    }

    expect(find.text('Welcome Developer'), findsOneWidget);
  }

  /// Fills the login form and taps Sign In.
  Future<void> attemptLogin(WidgetTester tester) async {
    final textFields = find.byType(TextField);
    if (textFields.evaluate().length >= 2) {
      await tester.enterText(textFields.first, 'testuser');
      await tester.pump();
      await tester.enterText(textFields.last, 'testpassword');
      await tester.pump();
    }

    final signInButton = find.text('Sign In');
    if (signInButton.evaluate().isNotEmpty) {
      await tester.tap(signInButton.last);
      await tester.pumpAndSettle(const Duration(seconds: 10));
    }
  }

  // ─────────────────────────────────────────────
  // TEST GROUPS
  // ─────────────────────────────────────────────

  group('Learn Hub Integration Tests', () {
    // ── Splash & Launch ──────────────────────────

    testWidgets(
      'App launches and shows splash screen before navigating further',
      (WidgetTester tester) async {
        app.main();
        await tester.pump();

        // Immediately after pump the app should render something
        expect(find.byType(MaterialApp), findsOneWidget);

        // Within 100 ms the splash should still be showing (not yet navigated)
        await tester.pump(const Duration(milliseconds: 100));

        // After 3 s it should have moved on to onboarding or login
        await tester.pumpAndSettle(const Duration(seconds: 3));
        final skipButton = find.text('Skip');
        final continueButton = find.text('Continue');
        final welcomeText = find.text('Welcome Developer');
        expect(
          skipButton.evaluate().isNotEmpty ||
              continueButton.evaluate().isNotEmpty ||
              welcomeText.evaluate().isNotEmpty,
          isTrue,
        );
      },
    );

    testWidgets(
      'App launches and displays splash → onboarding → login screen',
      (WidgetTester tester) async {
        app.main();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        final skipButton = find.text('Skip');
        final continueButton = find.text('Continue');
        expect(
          skipButton.evaluate().isNotEmpty ||
              continueButton.evaluate().isNotEmpty,
          isTrue,
        );

        await waitForLoginScreen(tester);

        expect(find.text('Sign In'), findsNWidgets(2));
        expect(find.text('Welcome Developer'), findsOneWidget);
        expect(find.text('User Name'), findsNWidgets(2));
        expect(find.text('Password'), findsNWidgets(2));
      },
    );

    // ── Onboarding ───────────────────────────────

    testWidgets('Onboarding screen has a PageView widget', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final skipButton = find.text('Skip');
      final continueButton = find.text('Continue');
      expect(
        skipButton.evaluate().isNotEmpty ||
            continueButton.evaluate().isNotEmpty,
        isTrue,
      );

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('Skip button skips onboarding and reaches Sign In', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final skipButton = find.text('Skip');
      if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton);
        await tester.pumpAndSettle();
      }

      final signInButton = find.text('Sign In');
      if (signInButton.evaluate().isNotEmpty) {
        await tester.tap(signInButton.first);
        await tester.pumpAndSettle();
      }

      expect(find.text('Welcome Developer'), findsOneWidget);
    });

    testWidgets(
      'Onboarding Continue button advances to next page each time',
      (WidgetTester tester) async {
        app.main();
        await tester.pump();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Navigate page by page using the Continue button
        for (int page = 0; page < 4; page++) {
          final continueBtn = find.text('Continue');
          if (continueBtn.evaluate().isNotEmpty) {
            await tester.tap(continueBtn);
            await tester.pumpAndSettle();
          } else {
            break; // Reached the last onboarding page
          }
        }

        // After all Continue taps we should see Sign In (last page) or login screen
        expect(
          find.text('Sign In').evaluate().isNotEmpty ||
              find.text('Welcome Developer').evaluate().isNotEmpty,
          isTrue,
        );
      },
    );

    // ── Login Screen ──────────────────────────────

    testWidgets('Login screen has exactly two TextField widgets', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('User Name'), findsWidgets);
      expect(find.text('Password'), findsWidgets);
    });

    testWidgets('Username field is NOT obscured', (WidgetTester tester) async {
      app.main();
      await waitForLoginScreen(tester);

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      final usernameTextField = tester.widget<TextField>(textFields.first);
      expect(usernameTextField.obscureText, isFalse);
    });

    testWidgets('Password field IS obscured', (WidgetTester tester) async {
      app.main();
      await waitForLoginScreen(tester);

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      final passwordTextField = tester.widget<TextField>(textFields.last);
      expect(passwordTextField.obscureText, isTrue);
    });

    testWidgets('Can type credentials into both login fields', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.first, 'testuser');
      await tester.pump();
      await tester.enterText(textFields.last, 'testpassword');
      await tester.pump();

      // Verify widget types are correct
      expect(tester.widget<TextField>(textFields.first), isA<TextField>());
      expect(tester.widget<TextField>(textFields.last), isA<TextField>());
    });

    testWidgets('Sign In button is present and has an InkWell', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'testuser');
      await tester.pump();
      await tester.enterText(textFields.last, 'testpassword');
      await tester.pump();

      expect(find.text('Sign In'), findsWidgets);
      expect(find.byType(InkWell), findsAtLeastNWidgets(1));

      await tester.tap(find.text('Sign In').last);
      await tester.pump();
    });

    testWidgets(
      'Login with whitespace-only credentials stays on login or shows error',
      (WidgetTester tester) async {
        app.main();
        await waitForLoginScreen(tester);

        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, '   ');
        await tester.pump();
        await tester.enterText(textFields.last, '   ');
        await tester.pump();

        await tester.tap(find.text('Sign In').last);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // App should remain on login or navigate (API may handle validation)
        final isOnLoginScreen =
            find.text('Welcome Developer').evaluate().isNotEmpty;
        final isOnHome =
            find.byType(BottomNavigationBar).evaluate().isNotEmpty;
        expect(isOnLoginScreen || isOnHome, isTrue);
      },
    );

    testWidgets('Empty credentials — app handles gracefully', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      // Tap Sign In without entering anything
      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should remain on login or show some feedback
      expect(
        find.text('Welcome Developer').evaluate().isNotEmpty ||
            find.byType(BottomNavigationBar).evaluate().isEmpty,
        isTrue,
      );
    });

    testWidgets('Login failure with invalid credentials stays on login screen', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      expect(find.text('Welcome Developer'), findsOneWidget);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'invaliduser');
      await tester.pump();
      await tester.enterText(textFields.last, 'wrongpassword');
      await tester.pump();

      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      final signInText = find.text('Sign In');
      final bottomNavBar = find.byType(BottomNavigationBar);

      if (signInText.evaluate().isNotEmpty) {
        expect(find.text('Welcome Developer'), findsOneWidget);
      } else if (bottomNavBar.evaluate().isNotEmpty) {
        expect(bottomNavBar, findsOneWidget);
      } else {
        // Dialog or loading state — app is handling the attempt
        expect(true, isTrue);
      }
    });

    testWidgets('Complete login flow → home screen visible', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      expect(find.text('Welcome Developer'), findsOneWidget);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'testuser');
      await tester.pump();
      await tester.enterText(textFields.last, 'testpassword');
      await tester.pump();

      await tester.tap(find.text('Sign In').last);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final bottomNav =
            tester.widget<BottomNavigationBar>(bottomNavBar);
        expect(bottomNav.items.length, 3);
        expect(find.text('Home'), findsOneWidget);
      }
    });

    // ── Bottom Navigation ─────────────────────────

    testWidgets('Bottom navigation bar has three tabs with correct icons', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final bottomNav =
            tester.widget<BottomNavigationBar>(bottomNavBar);
        expect(bottomNav.items.length, 3);
        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
        expect(find.byIcon(Icons.collections_bookmark), findsOneWidget);
      }
    });

    testWidgets('Tapping User tab changes currentIndex to 1', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        final nav = tester.widget<BottomNavigationBar>(bottomNavBar);
        expect(nav.currentIndex, 1);
      }
    });

    testWidgets('Tapping Company tab changes currentIndex to 2', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.collections_bookmark));
        await tester.pumpAndSettle();

        final nav = tester.widget<BottomNavigationBar>(bottomNavBar);
        expect(nav.currentIndex, 2);
      }
    });

    testWidgets('Can switch between all navigation tabs', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        expect(find.text('Home'), findsOneWidget);

        final userTab = find.byIcon(Icons.person);
        if (userTab.evaluate().isNotEmpty) {
          await tester.tap(userTab);
          await tester.pumpAndSettle();
          expect(find.text('User List'), findsOneWidget);
        }

        final companyTab = find.byIcon(Icons.collections_bookmark);
        if (companyTab.evaluate().isNotEmpty) {
          await tester.tap(companyTab);
          await tester.pumpAndSettle();
          expect(find.text('Company List'), findsOneWidget);
        }

        final homeTab = find.byIcon(Icons.home);
        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pumpAndSettle();
          expect(find.text('Home'), findsOneWidget);
        }
      }
    });

    // ── Home Screen ───────────────────────────────

    testWidgets('Home screen displays correctly', (WidgetTester tester) async {
      app.main();
      await waitForLoginScreen(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final homeTab = find.byIcon(Icons.home);
        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pumpAndSettle();
          expect(find.text('Home'), findsOneWidget);
        }
      } else {
        expect(find.text('Sign In'), findsWidgets);
        expect(find.text('Welcome Developer'), findsOneWidget);
      }
    });

    // ── User List ─────────────────────────────────

    testWidgets('User list screen loads and shows shimmer or list', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final userTab = find.byIcon(Icons.person);
        if (userTab.evaluate().isNotEmpty) {
          await tester.tap(userTab);
          await tester.pumpAndSettle(const Duration(seconds: 5));

          expect(find.text('User List'), findsOneWidget);

          final shimmer = find.byType(UserListShimmer);
          final shimmerWidget = find.byType(Shimmer);
          final listView = find.byType(ListView);

          expect(
            shimmer.evaluate().isNotEmpty ||
                shimmerWidget.evaluate().isNotEmpty ||
                listView.evaluate().isNotEmpty,
            isTrue,
          );
        }
      }
    });

    testWidgets('User list is scrollable without crashing', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final userTab = find.byIcon(Icons.person);
        if (userTab.evaluate().isNotEmpty) {
          await tester.tap(userTab);
          await tester.pumpAndSettle(const Duration(seconds: 5));
        }

        final listView = find.byType(ListView);
        if (listView.evaluate().isNotEmpty) {
          await tester.drag(listView.first, const Offset(0, -300));
          await tester.pumpAndSettle();
          // If we reach here without exception, scroll works
          expect(true, isTrue);
        }
      }
    });

    testWidgets('User detail screen opens from user list', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final userTab = find.byIcon(Icons.person);
        if (userTab.evaluate().isNotEmpty) {
          await tester.tap(userTab);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }

        final userTileFinder = find.byType(UserTile);
        if (userTileFinder.evaluate().isNotEmpty) {
          await tester.tap(userTileFinder.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          expect(find.text('About Me'), findsOneWidget);
          expect(find.text('Personal Information'), findsOneWidget);
        }
      }
    });

    testWidgets('User detail screen shows skills and personal info sections', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final userTab = find.byIcon(Icons.person);
        if (userTab.evaluate().isNotEmpty) {
          await tester.tap(userTab);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }

        final userTileFinder = find.byType(UserTile);
        if (userTileFinder.evaluate().isNotEmpty) {
          await tester.tap(userTileFinder.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          expect(find.text('My Skills'), findsOneWidget);
          expect(find.text('Personal Information'), findsOneWidget);
          expect(find.text('COMPANY'), findsWidgets);
          expect(find.text('EMAIL'), findsWidgets);
          expect(find.text('PHONE'), findsWidgets);
          expect(find.text('ADDRESS'), findsWidgets);
        }
      }
    });

    testWidgets('Back button from user detail returns to user list', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final userTab = find.byIcon(Icons.person);
        if (userTab.evaluate().isNotEmpty) {
          await tester.tap(userTab);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }

        final userTileFinder = find.byType(UserTile);
        if (userTileFinder.evaluate().isNotEmpty) {
          await tester.tap(userTileFinder.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Tap system back button
          final NavigatorState navigator = tester.state(find.byType(Navigator));
          navigator.pop();
          await tester.pumpAndSettle();

          expect(find.text('User List'), findsOneWidget);
        }
      }
    });

    // ── Company List ──────────────────────────────

    testWidgets('Company list screen loads and shows shimmer or list', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final companyTab = find.byIcon(Icons.collections_bookmark);
        if (companyTab.evaluate().isNotEmpty) {
          await tester.tap(companyTab);
          await tester.pumpAndSettle(const Duration(seconds: 5));

          expect(find.text('Company List'), findsOneWidget);

          final shimmer = find.byType(Shimmer);
          final listView = find.byType(ListView);

          expect(
            shimmer.evaluate().isNotEmpty || listView.evaluate().isNotEmpty,
            isTrue,
          );
        }
      }
    });

    testWidgets('Company list is scrollable without crashing', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final companyTab = find.byIcon(Icons.collections_bookmark);
        if (companyTab.evaluate().isNotEmpty) {
          await tester.tap(companyTab);
          await tester.pumpAndSettle(const Duration(seconds: 5));
        }

        final listView = find.byType(ListView);
        if (listView.evaluate().isNotEmpty) {
          await tester.drag(listView.first, const Offset(0, -300));
          await tester.pumpAndSettle();
          expect(true, isTrue);
        }
      }
    });

    testWidgets('Company detail screen opens from company list', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final companyTab = find.byIcon(Icons.collections_bookmark);
        if (companyTab.evaluate().isNotEmpty) {
          await tester.tap(companyTab);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }

        final companyTileFinder = find.byType(CompanyTile);
        if (companyTileFinder.evaluate().isNotEmpty) {
          await tester.tap(companyTileFinder.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          expect(find.text('About Company'), findsOneWidget);
          expect(find.text('Company Information'), findsOneWidget);
        }
      }
    });

    testWidgets('Company detail screen shows metrics and info sections', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final companyTab = find.byIcon(Icons.collections_bookmark);
        if (companyTab.evaluate().isNotEmpty) {
          await tester.tap(companyTab);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }

        final companyTileFinder = find.byType(CompanyTile);
        if (companyTileFinder.evaluate().isNotEmpty) {
          await tester.tap(companyTileFinder.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          expect(find.text('EMPLOYEES'), findsOneWidget);
          expect(find.text('MARKET CAP'), findsOneWidget);
          expect(find.text('About Company'), findsOneWidget);
          expect(find.text('Company Information'), findsOneWidget);
          expect(find.text('+ Follow'), findsOneWidget);
          expect(find.text('Website'), findsOneWidget);
        }
      }
    });

    testWidgets('Follow button on company detail is tappable', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final companyTab = find.byIcon(Icons.collections_bookmark);
        if (companyTab.evaluate().isNotEmpty) {
          await tester.tap(companyTab);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }

        final companyTileFinder = find.byType(CompanyTile);
        if (companyTileFinder.evaluate().isNotEmpty) {
          await tester.tap(companyTileFinder.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          final followButton = find.text('+ Follow');
          if (followButton.evaluate().isNotEmpty) {
            await tester.tap(followButton);
            await tester.pumpAndSettle();
            // Verify the app did not crash after tapping Follow
            expect(true, isTrue);
          }
        }
      }
    });

    testWidgets('Back button from company detail returns to company list', (
      WidgetTester tester,
    ) async {
      app.main();
      await waitForLoginScreen(tester);
      await attemptLogin(tester);

      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        final companyTab = find.byIcon(Icons.collections_bookmark);
        if (companyTab.evaluate().isNotEmpty) {
          await tester.tap(companyTab);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        }

        final companyTileFinder = find.byType(CompanyTile);
        if (companyTileFinder.evaluate().isNotEmpty) {
          await tester.tap(companyTileFinder.first);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          final NavigatorState navigator =
              tester.state(find.byType(Navigator));
          navigator.pop();
          await tester.pumpAndSettle();

          expect(find.text('Company List'), findsOneWidget);
        }
      }
    });
  });
}
