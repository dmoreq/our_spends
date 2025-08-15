import '../models/tag.dart';

/// Repository interface for Tag-related operations.
/// 
/// This interface follows the Interface Segregation Principle by providing
/// a focused set of methods specific to tag operations.
abstract class TagRepository {
  /// Retrieves all tags.
  Future<List<Tag>> getTags();
  
  /// Retrieves a specific tag by ID.
  Future<Tag?> getTagById(String id);
  
  /// Adds a new tag.
  Future<void> addTag(Tag tag);
  
  /// Updates an existing tag.
  Future<void> updateTag(Tag tag);
  
  /// Deletes a tag by ID.
  Future<void> deleteTag(String tagId);
  
  /// Gets all tag IDs associated with a specific expense.
  Future<List<String>> getExpenseTags(String expenseId);
  
  /// Sets the tag IDs associated with a specific expense.
  Future<void> setExpenseTags(String expenseId, List<String> tagIds);
}