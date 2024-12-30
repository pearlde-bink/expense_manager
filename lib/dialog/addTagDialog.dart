import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tag.dart';
import '../providers/expense_provider.dart';

class AddTagDialog extends StatefulWidget {
  final Function(Tag) onAdd;

  AddTagDialog({required this.onAdd});

  @override
  _TagDialogState createState() => _TagDialogState();
}

class _TagDialogState extends State<AddTagDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Add Tag"),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Tag Name'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            // onPressed: () {
            //   final nameTag = _nameController.text;
            //   if (nameTag.isNotEmpty) {
            //     Navigator.of(context).pop();
            //   }
            // },
            onPressed: () {
              var newTag = Tag(
                  id: DateTime.now().toIso8601String(),
                  name: _nameController.text);
              widget.onAdd(newTag);
              //Update the provider and UI
              Provider.of<ExpenseProvider>(context, listen: false)
                  .addTag(newTag);
              //Clear the input field for next input
              _nameController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          )
        ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
