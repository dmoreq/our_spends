import 'package:flutter/material.dart';
import '../models/tag.dart';
import '../l10n/app_localizations.dart';

/// A reusable widget for selecting tags.
/// 
/// This widget follows the Single Responsibility Principle by focusing only on
/// tag selection UI and functionality.
class TagSelector extends StatefulWidget {
  /// The currently selected tag IDs.
  final List<String> selectedTagIds;
  
  /// Callback when selected tags change.
  final Function(List<String>) onTagsChanged;
  
  /// Function to fetch available tags.
  final Future<List<Tag>> Function() fetchTags;
  
  const TagSelector({
    Key? key,
    required this.selectedTagIds,
    required this.onTagsChanged,
    required this.fetchTags,
  }) : super(key: key);

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  late List<String> _selectedTagIds;
  
  @override
  void initState() {
    super.initState();
    _selectedTagIds = List.from(widget.selectedTagIds);
  }
  
  @override
  void didUpdateWidget(TagSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTagIds != widget.selectedTagIds) {
      _selectedTagIds = List.from(widget.selectedTagIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tags,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<Tag>>(
          future: widget.fetchTags(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text(l10n.noTagsAvailable);
            }
            
            final tags = snapshot.data!;
            
            return Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: tags.map((tag) {
                final isSelected = _selectedTagIds.contains(tag.id);
                
                return FilterChip(
                  label: Text(tag.name),
                  selected: isSelected,
                  avatar: Icon(IconData(
                    tag.icon,
                    fontFamily: 'MaterialIcons',
                  )),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTagIds.add(tag.id);
                      } else {
                        _selectedTagIds.remove(tag.id);
                      }
                    });
                    widget.onTagsChanged(_selectedTagIds);
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}