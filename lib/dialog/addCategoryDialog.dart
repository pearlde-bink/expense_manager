import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/expense_provider.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(Category) onAdd;

  AddCategoryDialog({required this.onAdd});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              var newCategory = Category(
                  id: DateTime.now().toString(), name: _nameController.text);
              widget.onAdd(newCategory);
              // Update the provider and UI
              Provider.of<ExpenseProvider>(context, listen: false)
                  .addCategory(newCategory);
              // Clear the input field for next input
              _nameController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          )
        ]);
  }

  @override
  void dispose() {
    _nameController.dispose(); //to clean up _nameController
    super.dispose();
  }
}
