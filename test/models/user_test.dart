import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';

void main() {
  group('User', () {
    final json = {
      'id': 1,
      'name': 'Alice Johnson',
      'company': 'Acme Inc',
      'username': 'alice_j',
      'email': 'alice@acme.com',
      'address': '456 Oak Ave',
      'zip': '67890',
      'state': 'California',
      'country': 'USA',
      'phone': '+1-555-000-1234',
      'photo': 'https://example.com/alice.png',
    };

    test('fromJson creates User with correct fields', () {
      final user = User.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'Alice Johnson');
      expect(user.company, 'Acme Inc');
      expect(user.username, 'alice_j');
      expect(user.email, 'alice@acme.com');
      expect(user.address, '456 Oak Ave');
      expect(user.zip, '67890');
      expect(user.state, 'California');
      expect(user.country, 'USA');
      expect(user.phone, '+1-555-000-1234');
      expect(user.photo, 'https://example.com/alice.png');
    });

    test('toJson returns correct map', () {
      final user = User.fromJson(json);
      final result = user.toJson();

      expect(result, json);
    });

    test('fromJson and toJson are symmetric', () {
      final user = User.fromJson(json);
      final roundTripped = User.fromJson(user.toJson());

      expect(roundTripped.id, user.id);
      expect(roundTripped.name, user.name);
      expect(roundTripped.company, user.company);
      expect(roundTripped.username, user.username);
      expect(roundTripped.email, user.email);
      expect(roundTripped.address, user.address);
      expect(roundTripped.zip, user.zip);
      expect(roundTripped.state, user.state);
      expect(roundTripped.country, user.country);
      expect(roundTripped.phone, user.phone);
      expect(roundTripped.photo, user.photo);
    });

    test('fullAddress combines address, state, zip, and country', () {
      final user = User.fromJson(json);

      expect(user.fullAddress, '456 Oak Ave, California, 67890, USA');
    });

    test('fromJson handles null photo', () {
      final jsonWithNullPhoto = {...json, 'photo': null};
      final user = User.fromJson(jsonWithNullPhoto);

      expect(user.photo, isNull);
    });

    test('fromJson handles missing photo key', () {
      final jsonWithoutPhoto = Map<String, dynamic>.from(json)..remove('photo');
      final user = User.fromJson(jsonWithoutPhoto);

      expect(user.photo, isNull);
    });

    test('toJson includes null photo', () {
      final jsonWithNullPhoto = {...json, 'photo': null};
      final user = User.fromJson(jsonWithNullPhoto);
      final result = user.toJson();

      expect(result.containsKey('photo'), true);
      expect(result['photo'], isNull);
    });

    test('placeHolder has default empty/zero values', () {
      final placeholder = User.placeHolder;

      expect(placeholder.id, 0);
      expect(placeholder.name, '');
      expect(placeholder.company, '');
      expect(placeholder.username, '');
      expect(placeholder.email, '');
      expect(placeholder.address, '');
      expect(placeholder.zip, '');
      expect(placeholder.state, '');
      expect(placeholder.country, '');
      expect(placeholder.phone, '');
      expect(placeholder.photo, isNull);
    });
  });
}
