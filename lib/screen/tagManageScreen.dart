import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../models/tag.dart';
import '../providers/expense_provider.dart';
import '../dialog/addTagDialog.dart';

class TagManageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ExpenseProvider>(builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.tags.length,
          itemBuilder: (context, index) {
            final tag = provider.tags[index];
            return ListTile(
                title: Text(tag.name),
                trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      provider.deleteTag(tag);
                    }));
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTagDialog(
              onAdd: (newTag) {
                Provider.of<ExpenseProvider>(context, listen: false)
                    .addTag(newTag);
                Navigator.pop(
                    context); // Close the dialog after adding the new tag
              },
            ),
          );
        },
        tooltip: "Add tag",
        child: const Icon(Icons.add),
      ),
    );
  }
}
