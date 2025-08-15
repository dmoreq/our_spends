import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tag/tag_provider.dart';
import '../models/tag.dart';

class TagManagementScreen extends StatefulWidget {
  const TagManagementScreen({super.key});

  @override
  State<TagManagementScreen> createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.label_outline;

  void _showAddTagDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Tag'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tag Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tag name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Color: '),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _showColorPicker,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Icon: '),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _showIconPicker,
                    icon: Icon(_selectedIcon),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _saveTag,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showIconPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Icon'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Icons.shopping_cart,
              Icons.restaurant,
              Icons.local_gas_station,
              Icons.home,
              Icons.directions_bus,
              Icons.local_hospital,
              Icons.school,
              Icons.sports_esports,
              Icons.movie,
              Icons.flight_takeoff,
              Icons.fitness_center,
              Icons.shopping_bag,
              Icons.credit_card,
              Icons.attach_money,
              Icons.account_balance,
              Icons.category,
              Icons.label,
              Icons.local_offer,
              Icons.tag,
            ].map((icon) => IconButton(
              onPressed: () {
                setState(() => _selectedIcon = icon);
                Navigator.pop(context);
              },
              icon: Icon(icon),
              color: Colors.grey.shade700,
            )).toList(),
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Colors.red,
              Colors.pink,
              Colors.purple,
              Colors.deepPurple,
              Colors.indigo,
              Colors.blue,
              Colors.lightBlue,
              Colors.cyan,
              Colors.teal,
              Colors.green,
              Colors.lightGreen,
              Colors.lime,
              Colors.yellow,
              Colors.amber,
              Colors.orange,
              Colors.deepOrange,
              Colors.brown,
              Colors.grey,
              Colors.blueGrey,
            ].map((color) => GestureDetector(
              onTap: () {
                setState(() => _selectedColor = color);
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
            )).toList(),
          ),
        ),
      ),
    );
  }

  void _saveTag() {
    if (_formKey.currentState!.validate()) {
      final tag = Tag(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        color: _selectedColor.toARGB32(),
        iconCodePoint: _selectedIcon.codePoint,
        iconFontFamily: 'MaterialIcons',
        isActive: true,
      );

      Provider.of<TagProvider>(context, listen: false).addTag(tag);

      _nameController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedColor = Colors.blue;
        _selectedIcon = Icons.label_outline;
      });

      if (mounted) Navigator.pop(context);
    }
  }

  void _editTag(Tag tag) {
    _nameController.text = tag.name;
    _descriptionController.text = tag.description ?? '';
    setState(() {
      _selectedColor = Color(tag.color);
      _selectedIcon = IconData(tag.iconCodePoint, fontFamily: tag.iconFontFamily, fontPackage: 'flutter');
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tag'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tag Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tag name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Color: '),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _showColorPicker,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Icon: '),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _showIconPicker,
                    icon: Icon(_selectedIcon),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final updatedTag = tag.copyWith(
                  name: _nameController.text,
                  description: _descriptionController.text,
                  color: _selectedColor.toARGB32(),
                  iconCodePoint: _selectedIcon.codePoint,
                  iconFontFamily: 'MaterialIcons',
                );

                Provider.of<TagProvider>(context, listen: false).updateTag(updatedTag);

                _nameController.clear();
                _descriptionController.clear();
                setState(() {
                  _selectedColor = Colors.blue;
                  _selectedIcon = Icons.label_outline;
                });

                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteTag(Tag tag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tag'),
        content: Text('Are you sure you want to delete "${tag.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TagProvider>(context, listen: false).deleteTag(tag.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddTagDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<Tag>>(
        future: Provider.of<TagProvider>(context, listen: false).getTags(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading tags',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final tags = snapshot.data ?? [];

          if (tags.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.label_outline,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Tags',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create tags to organize your expenses',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _showAddTagDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Tag'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(tag.color).withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconData(tag.iconCodePoint, fontFamily: tag.iconFontFamily),
                      color: Color(tag.color),
                    ),
                  ),
                  title: Text(tag.name),
                  subtitle: tag.description != null && tag.description!.isNotEmpty
                      ? Text(
                          tag.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editTag(tag),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: theme.colorScheme.error,
                        ),
                        onPressed: () => _deleteTag(tag),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}