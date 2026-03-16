import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/user/presentation/screens/user_list.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';
import 'package:learn_hub/features/user/presentation/widgets/user_list_shimmer.dart';
import 'package:learn_hub/features/user/presentation/widgets/user_tile.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('UserList widget', () {
    testWidgets('shows list of users when loading completes', (tester) async {
      final repository = MockUserRepository();

      final users = [
        User(
          id: 1,
          name: 'Alice',
          company: 'Acme',
          username: 'alice',
          email: 'alice@example.com',
          address: '123 Street',
          zip: '12345',
          state: 'CA',
          country: 'USA',
          phone: '1234567890',
          photo: null,
        ),
      ];

      when(() => repository.fetchUsers()).thenAnswer(
        (_) async => users,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: UserList(repository: repository),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('User List'), findsOneWidget);
      expect(find.byType(UserTile), findsWidgets);
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('UserListShimmer builds list view skeleton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UserListShimmer(),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
