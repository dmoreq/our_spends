import 'dart:convert';

import '../../models/tag.dart';
import '../../repositories/tag_repository.dart';
import '../../services/storage/storage_service.dart';

/// Implementation of [TagRepository] using SharedPreferences for storage.
/// 
/// This class follows the Single Responsibility Principle by focusing only on
/// tag-related data operations.
class SharedPreferencesTagRepository implements TagRepository {
  static const String _tagsKey = 'tags_data';
  static const String _expenseTagsKey = 'expense_tags_data';
  
  final StorageService _storageService;
  List<Tag>? _tagsCache;
  Map<String, List<String>>? _expenseTagsCache;
  
  SharedPreferencesTagRepository(this._storageService);
  
  /// Loads tags from storage.
  Future<List<Tag>> _loadTags() async {
    if (_tagsCache != null) return _tagsCache!;
    
    final tagsJson = await _storageService.getString(_tagsKey);
    
    if (tagsJson == null) {
      _tagsCache = [];
      return _tagsCache!;
    }
    
    final List<dynamic> tagsList = json.decode(tagsJson);
    _tagsCache = tagsList.map((json) => Tag.fromJson(json)).toList();
    return _tagsCache!;
  }
  
  /// Saves tags to storage.
  Future<void> _saveTags(List<Tag> tags) async {
    final tagsJson = json.encode(tags.map((t) => t.toJson()).toList());
    await _storageService.setString(_tagsKey, tagsJson);
    _tagsCache = tags;
  }
  
  /// Loads expense-tag relationships from storage.
  Future<Map<String, List<String>>> _loadExpenseTags() async {
    if (_expenseTagsCache != null) return _expenseTagsCache!;
    
    final expenseTagsJson = await _storageService.getString(_expenseTagsKey);
    
    if (expenseTagsJson == null) {
      _expenseTagsCache = {};
      return _expenseTagsCache!;
    }
    
    final Map<String, dynamic> expenseTagsMap = json.decode(expenseTagsJson);
    _expenseTagsCache = expenseTagsMap.map(
      (expenseId, tagIds) => MapEntry(
        expenseId,
        (tagIds as List).map((tagId) => tagId.toString()).toList(),
      ),
    );
    return _expenseTagsCache!;
  }
  
  /// Saves expense-tag relationships to storage.
  Future<void> _saveExpenseTags(Map<String, List<String>> expenseTags) async {
    final expenseTagsJson = json.encode(expenseTags);
    await _storageService.setString(_expenseTagsKey, expenseTagsJson);
    _expenseTagsCache = expenseTags;
  }
  
  @override
  Future<List<Tag>> getTags() async {
    return await _loadTags();
  }
  
  @override
  Future<Tag?> getTagById(String id) async {
    final tags = await _loadTags();
    try {
      return tags.firstWhere((tag) => tag.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> addTag(Tag tag) async {
    final tags = await _loadTags();
    final newTag = tag.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    tags.add(newTag);
    await _saveTags(tags);
  }
  
  @override
  Future<void> updateTag(Tag tag) async {
    final tags = await _loadTags();
    final index = tags.indexWhere((t) => t.id == tag.id);
    if (index != -1) {
      tags[index] = tag;
      await _saveTags(tags);
    }
  }
  
  @override
  Future<void> deleteTag(String tagId) async {
    final tags = await _loadTags();
    tags.removeWhere((tag) => tag.id == tagId);
    await _saveTags(tags);
    
    // Also remove this tag from all expenses
    final expenseTags = await _loadExpenseTags();
    for (final expenseId in expenseTags.keys) {
      expenseTags[expenseId]?.removeWhere((id) => id == tagId);
    }
    await _saveExpenseTags(expenseTags);
  }
  
  @override
  Future<List<String>> getExpenseTags(String expenseId) async {
    final expenseTags = await _loadExpenseTags();
    return expenseTags[expenseId] ?? [];
  }
  
  @override
  Future<void> setExpenseTags(String expenseId, List<String> tagIds) async {
    final expenseTags = await _loadExpenseTags();
    expenseTags[expenseId] = tagIds;
    await _saveExpenseTags(expenseTags);
  }
}