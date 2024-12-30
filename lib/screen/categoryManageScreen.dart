import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../models/category.dart';
import '../providers/expense_provider.dart';
import '../dialog/addCategoryDialog.dart';

class CategoryManageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Categories'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Consumer<ExpenseProvider>(builder: (context, provider, child) {
          return ListView.builder(
              itemCount: provider.categories.length,
              itemBuilder: (context, index) {
                final category = provider.categories[index];
                return ListTile(
                    title: Text(category.name),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          provider.deleteCategory(category);
                        }));
              });
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AddCategoryDialog(onAdd: (newCategory) {
                      Provider.of<ExpenseProvider>(context, listen: false)
                          .addCategory(newCategory);
                      Navigator.pop(context);
                    }));
          },
          tooltip: 'Add new category',
          child: const Icon(Icons.add),
        ));
  }

  // void _showAddCategoryDialog(BuildContext context) {
  //   final TextEditingController _categoryNameController =
  //       TextEditingController();
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //             title: const Text('Add Category'),
  //             content: TextField(
  //               controller: _categoryNameController,
  //               decoration: const InputDecoration(labelText: 'Category name'),
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Cancel'),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   final category = Category(
  //                     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //                     name: _categoryNameController.text,
  //                     isDefault: false,
  //                   );
  //                   Provider.of<ExpenseProvider>(context, listen: false)
  //                       .addCategory(category);
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Add'),
  //               )
  //             ]);
  //       });
  // }
}
