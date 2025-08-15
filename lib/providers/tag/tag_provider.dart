import 'package:flutter/material.dart';
import '../../models/tag.dart';
import '../../repositories/tag_repository.dart';
import '../../services/service_provider.dart';

/// A provider that manages tag data and operations.
/// 
/// This class follows the separation of concerns principle by focusing only on
/// tag-related operations, which were previously mixed with expense operations
/// in the ExpenseProvider.
class TagProvider extends ChangeNotifier {
  final TagRepository _tagRepository;
  
  bool _isLoading = false;
  String? _errorMessage;
  
  List<Tag> _tags = [];
  
  TagProvider({
    TagRepository? tagRepository,
  }) : _tagRepository = tagRepository ?? ServiceProvider.instance.tagRepository;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Tag> get tags => List.unmodifiable(_tags);
  
  /// Loads all tags from the repository.
  Future<void> loadTags() async {
    try {
      _setLoading(true);
      _clearError();
      
      final tags = await _tagRepository.getTags();
      _tags = tags;
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load tags: ${e.toString()}');
    }
  }
  
  /// Gets a tag by its ID.
  Future<Tag?> getTagById(String tagId) async {
    try {
      return await _tagRepository.getTagById(tagId);
    } catch (e) {
      _setError('Failed to get tag: ${e.toString()}');
      return null;
    }
  }
  
  /// Gets all tags.
  Future<List<Tag>> getTags() async {
    try {
      final tags = await _tagRepository.getTags();
      _tags = tags;
      return tags;
    } catch (e) {
      _setError('Failed to get tags: ${e.toString()}');
      return [];
    }
  }
  
  /// Gets all tag IDs associated with a specific expense.
  Future<List<String>> getExpenseTags(String expenseId) async {
    try {
      return await _tagRepository.getExpenseTags(expenseId);
    } catch (e) {
      _setError('Failed to get expense tags: ${e.toString()}');
      return [];
    }
  }
  
  /// Sets the tag IDs associated with a specific expense.
  Future<void> setExpenseTags(String expenseId, List<String> tagIds) async {
    try {
      _setLoading(true);
      await _tagRepository.setExpenseTags(expenseId, tagIds);
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to set expense tags: ${e.toString()}');
    }
  }
  
  /// Adds a new tag.
  Future<void> addTag(Tag tag) async {
    try {
      _setLoading(true);
      await _tagRepository.addTag(tag);
      await loadTags(); // Reload tags to update the list
      _setLoading(false);
    } catch (e) {
      _setError('Failed to add tag: ${e.toString()}');
    }
  }
  
  /// Updates an existing tag.
  Future<void> updateTag(Tag tag) async {
    try {
      _setLoading(true);
      await _tagRepository.updateTag(tag);
      await loadTags(); // Reload tags to update the list
      _setLoading(false);
    } catch (e) {
      _setError('Failed to update tag: ${e.toString()}');
    }
  }
  
  /// Deletes a tag by ID.
  Future<void> deleteTag(String tagId) async {
    try {
      _setLoading(true);
      await _tagRepository.deleteTag(tagId);
      await loadTags(); // Reload tags to update the list
      _setLoading(false);
    } catch (e) {
      _setError('Failed to delete tag: ${e.toString()}');
    }
  }
  
  // Private methods for internal use
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}