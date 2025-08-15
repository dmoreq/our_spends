import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/tag.dart';

void main() {
  group('Tag Model Tests', () {
    test('should create a Tag instance with required parameters', () {
      final tag = Tag(
        id: '1',
        name: 'Business',
        description: 'Business related expenses',
        color: 0xFF4287F5,
        isActive: true,
        createdAt: DateTime(2023, 5, 15),
        updatedAt: DateTime(2023, 5, 15),
      );

      expect(tag.id, '1');
      expect(tag.name, 'Business');
      expect(tag.description, 'Business related expenses');
      expect(tag.color, 0xFF4287F5);
      expect(tag.isActive, true);
      expect(tag.createdAt, DateTime(2023, 5, 15));
      expect(tag.updatedAt, DateTime(2023, 5, 15));
    });

    test('should create a Tag from JSON', () {
      final json = {
        'id': '1',
        'name': 'Business',
        'description': 'Business related expenses',
        'color': 0xFF4287F5,
        'is_active': true,
        'created_at': '2023-05-15T00:00:00.000',
        'updated_at': '2023-05-15T00:00:00.000',
      };

      final tag = Tag.fromJson(json);

      expect(tag.id, '1');
      expect(tag.name, 'Business');
      expect(tag.description, 'Business related expenses');
      expect(tag.color, 0xFF4287F5);
      expect(tag.isActive, true);
      expect(tag.createdAt, DateTime(2023, 5, 15));
      expect(tag.updatedAt, DateTime(2023, 5, 15));
    });

    test('should convert Tag to JSON', () {
      final tag = Tag(
        id: '1',
        name: 'Business',
        description: 'Business related expenses',
        color: 0xFF4287F5,
        isActive: true,
        createdAt: DateTime(2023, 5, 15),
        updatedAt: DateTime(2023, 5, 15),
      );

      final json = tag.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Business');
      expect(json['description'], 'Business related expenses');
      expect(json['color'], 0xFF4287F5);
      expect(json['is_active'], true);
      expect(json['created_at'], '2023-05-15T00:00:00.000');
      expect(json['updated_at'], '2023-05-15T00:00:00.000');
    });

    test('should create a copy with updated fields using copyWith', () {
      final tag = Tag(
        id: '1',
        name: 'Business',
        description: 'Business related expenses',
        color: 0xFF4287F5,
        isActive: true,
        createdAt: DateTime(2023, 5, 15),
        updatedAt: DateTime(2023, 5, 15),
      );

      final updatedTag = tag.copyWith(
        name: 'Work',
        description: 'Work related expenses',
        color: 0xFFF54242,
        isActive: false,
      );

      // Check that specified fields were updated
      expect(updatedTag.name, 'Work');
      expect(updatedTag.description, 'Work related expenses');
      expect(updatedTag.color, 0xFFF54242);
      expect(updatedTag.isActive, false);

      // Check that other fields remain the same
      expect(updatedTag.id, '1');
      expect(updatedTag.createdAt, DateTime(2023, 5, 15));
      expect(updatedTag.updatedAt, DateTime(2023, 5, 15));
    });
  });

  test('should handle null description', () {
    final tag = Tag(
      id: '1',
      name: 'Business',
      color: 0xFF4287F5,
      isActive: true,
    );

    expect(tag.description, null);
    
    final json = tag.toJson();
    expect(json['description'], null);
    
    final deserializedTag = Tag.fromJson(json);
    expect(deserializedTag.description, null);
  });
}