import 'package:flutter_test/flutter_test.dart';
import 'package:our_spends/models/category.dart';

void main() {
  group('Category Model Tests', () {
    test('should create a Category instance with required parameters', () {
      final category = Category(
        id: '1',
        name: 'Food & Dining',
        description: 'Restaurants, groceries, and food delivery',
        icon: '🍽️',
        color: '#FF6B6B',
        parentId: null,
        isActive: true,
        createdAt: DateTime(2023, 5, 15),
        updatedAt: DateTime(2023, 5, 15),
      );

      expect(category.id, '1');
      expect(category.name, 'Food & Dining');
      expect(category.description, 'Restaurants, groceries, and food delivery');
      expect(category.icon, '🍽️');
      expect(category.color, '#FF6B6B');
      expect(category.parentId, null);
      expect(category.isActive, true);
      expect(category.createdAt, DateTime(2023, 5, 15));
      expect(category.updatedAt, DateTime(2023, 5, 15));
    });

    test('should create a Category from JSON', () {
      final json = {
        'id': '1',
        'name': 'Food & Dining',
        'description': 'Restaurants, groceries, and food delivery',
        'icon': '🍽️',
        'color': '#FF6B6B',
        'parent_id': null,
        'is_active': true,
        'created_at': '2023-05-15T00:00:00.000',
        'updated_at': '2023-05-15T00:00:00.000',
      };

      final category = Category.fromJson(json);

      expect(category.id, '1');
      expect(category.name, 'Food & Dining');
      expect(category.description, 'Restaurants, groceries, and food delivery');
      expect(category.icon, '🍽️');
      expect(category.color, '#FF6B6B');
      expect(category.isActive, true);
      expect(category.createdAt, DateTime(2023, 5, 15));
      expect(category.updatedAt, DateTime(2023, 5, 15));
    });

    test('should convert Category to JSON', () {
      final category = Category(
        id: '1',
        name: 'Food & Dining',
        description: 'Restaurants, groceries, and food delivery',
        icon: '🍽️',
        color: '#FF6B6B',
        parentId: null,
        isActive: true,
        createdAt: DateTime(2023, 5, 15),
        updatedAt: DateTime(2023, 5, 15),
      );

      final json = category.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Food & Dining');
      expect(json['description'], 'Restaurants, groceries, and food delivery');
      expect(json['icon'], '🍽️');
      expect(json['color'], '#FF6B6B');
      expect(json['parent_id'], null);
      expect(json['is_active'], true);
      expect(json['created_at'], '2023-05-15T00:00:00.000');
      expect(json['updated_at'], '2023-05-15T00:00:00.000');
    });

    test('should create a copy with updated fields using copyWith', () {
      final category = Category(
        id: '1',
        name: 'Food & Dining',
        description: 'Restaurants, groceries, and food delivery',
        icon: '🍽️',
        color: '#FF6B6B',
        parentId: null,
        isActive: true,
        createdAt: DateTime(2023, 5, 15),
        updatedAt: DateTime(2023, 5, 15),
      );

      final updatedCategory = category.copyWith(
        name: 'Food',
        icon: '🍔',
        isActive: false,
        parentId: '2',
      );

      // Check that specified fields were updated
      expect(updatedCategory.name, 'Food');
      expect(updatedCategory.icon, '🍔');
      expect(updatedCategory.isActive, false);
      expect(updatedCategory.parentId, '2');

      // Check that other fields remain the same
      expect(updatedCategory.id, '1');
      expect(updatedCategory.description, 'Restaurants, groceries, and food delivery');
      expect(updatedCategory.color, '#FF6B6B');
      expect(updatedCategory.createdAt, DateTime(2023, 5, 15));
      expect(updatedCategory.updatedAt, DateTime(2023, 5, 15));
    });
  });

  test('should handle parent-child relationship', () {
    final parentCategory = Category(
      id: '1',
      name: 'Food & Dining',
      description: 'All food related expenses',
      icon: '🍽️',
      color: '#FF6B6B',
      isActive: true,
    );

    final childCategory = Category(
      id: '2',
      name: 'Restaurants',
      description: 'Eating out expenses',
      icon: '🍔',
      color: '#4ECDC4',
      parentId: parentCategory.id,
      isActive: true,
    );

    expect(childCategory.parentId, parentCategory.id);
    
    // Test JSON serialization of parent-child relationship
    final json = childCategory.toJson();
    expect(json['parent_id'], parentCategory.id);
    
    // Test JSON deserialization of parent-child relationship
    final deserializedCategory = Category.fromJson(json);
    expect(deserializedCategory.parentId, parentCategory.id);
  });
}