import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> _items = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, String>> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;
    return _items.where((item) {
      final name = item['name']?.toLowerCase() ?? '';
      final description = item['description']?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || description.contains(query);
    }).toList();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void _addItem(String name, String description) {
    if (name.isEmpty) return;
    setState(() {
      _items.add({'name': name, 'description': description});
    });
  }

  void _deleteItem(int index) {
    setState(() {
      final itemIndex = _items.indexOf(_filteredItems[index]);
      _items.removeAt(itemIndex);
    });
  }

  void _editItem(int index, String name, String description) {
    if (name.isEmpty) return;
    setState(() {
      final itemIndex = _items.indexOf(_filteredItems[index]);
      _items[itemIndex] = {'name': name, 'description': description};
    });
  }

  void _showAddEditDialog({int? editIndex}) {
    final isEditing = editIndex != null;
    final nameController = TextEditingController(
      text: isEditing ? _filteredItems[editIndex]['name'] : '',
    );
    final descController = TextEditingController(
      text: isEditing ? _filteredItems[editIndex]['description'] : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Item' : 'Add New Item'),
        content: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  return (value?.isEmpty ?? true) ? "required" : null;
                },
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter item name',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Enter item description',
                ),
                maxLines: 3,
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
              if (_formkey.currentState?.validate() ?? false) {
                if (isEditing) {
                  _editItem(
                      editIndex, nameController.text, descController.text);
                } else {
                  _addItem(nameController.text, descController.text);
                }
                Navigator.pop(context);
              }
            },
            child: Text(isEditing ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search items',
                hintText: 'Enter search term',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 16),
            // List of Items
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return _filteredItems.isEmpty
                      ? const Center(
                          child: Text('No items found'),
                        )
                      : ListView.builder(
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ExpansionTile(
                                title: Text(item['name'] ?? ''),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _showAddEditDialog(
                                        editIndex: index,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _deleteItem(index),
                                    ),
                                  ],
                                ),
                                children: [
                                  if (item['description']?.isNotEmpty ?? false)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(item['description'] ?? ''),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
