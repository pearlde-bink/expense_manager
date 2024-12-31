import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/payee.dart';
import '../models/date.dart';
import '../providers/expense_provider.dart';
import '../dialog/addCategoryDialog.dart';
import '../dialog/addTagDialog.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AddExpenseScreen extends StatefulWidget {
  final Expense? initialExpense;

  const AddExpenseScreen({Key? key, this.initialExpense}) : super(key: key);

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddExpenseScreen> {
  late TextEditingController _amountController;
  late TextEditingController _payeeController;
  late TextEditingController _noteController;
  String? _selectedCategoryId;
  String? _selectedTagId;
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.initialExpense?.amount.toString() ?? '');
    _payeeController =
        TextEditingController(text: widget.initialExpense?.payee ?? '');
    _noteController =
        TextEditingController(text: widget.initialExpense?.note ?? '');
    _selectedDate = widget.initialExpense?.date ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    ;
    _selectedCategoryId = widget.initialExpense?.categoryId;
    _selectedTagId = widget.initialExpense?.tag;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.initialExpense == null ? "Add Expense" : "Edit Expense"),
          backgroundColor: Colors.deepPurple[400],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              buildTextField(_amountController, "Amount",
                  const TextInputType.numberWithOptions(decimal: true)),
              buildTextField(_payeeController, "Payee", TextInputType.text),
              buildTextField(_noteController, "Note", TextInputType.text),
              buildDateField(_selectedDate),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: buildCategoryDropdown(expenseProvider),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: buildTagDropdown(expenseProvider),
              )
            ])),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _saveExpense,
              child: const Text("Save expense!"),
            )));
  }

  Widget buildTextField(
      TextEditingController controller, String label, TextInputType type) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          keyboardType: type,
        ));
  }

  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
        title: Text("Date: ${DateFormat('dd-MM-yyyy').format(selectedDate)}"),
        trailing: const Icon(Icons.calendar_today),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: selectedDate);
          if (picked != null && picked != selectedDate) {
            setState(() {
              _selectedDate = picked;
            });
          }
        });
  }

  Widget buildCategoryDropdown(ExpenseProvider expenseProvider) {
    return DropdownButtonFormField<String>(
        value: _selectedCategoryId,
        onChanged: (newValue) {
          if (newValue == "New") {
            showDialog(
              context: context,
              builder: (context) => AddCategoryDialog(onAdd: (newCategory) {
                setState(() {
                  _selectedCategoryId = newCategory.id;
                  expenseProvider.addCategory(newCategory);
                });
              }),
            );
          } else {
            setState(() => _selectedCategoryId = newValue as String);
          }
        },
        items: expenseProvider.categories
            .map<DropdownMenuItem<String>>((category) {
          return DropdownMenuItem<String>(
            value: category.id,
            child: Text(category.name),
          );
        }).toList()
          ..add(
            const DropdownMenuItem(
                value: "New", child: Text("Add new category")),
          ),
        decoration: const InputDecoration(
            labelText: 'Category', border: OutlineInputBorder()));
  }

  Widget buildTagDropdown(ExpenseProvider expenseProvider) {
    return DropdownButtonFormField<String>(
        value: _selectedTagId,
        onChanged: (newValue) {
          if (newValue == "New") {
            showDialog(
                context: context,
                builder: (context) => AddTagDialog(onAdd: (tag) {
                      setState(() {
                        _selectedTagId = tag.id;
                        expenseProvider.addTag(tag);
                      });
                    }));
          } else {
            setState(() => _selectedTagId = newValue as String);
          }
        },
        items: expenseProvider.tags.map<DropdownMenuItem<String>>((tag) {
          return DropdownMenuItem<String>(
            value: tag.id,
            child: Text(tag.name),
          );
        }).toList()
          ..add(
            const DropdownMenuItem(value: "New", child: Text("Add new tag")),
          ),
        decoration: const InputDecoration(
            labelText: 'Tag', border: OutlineInputBorder()));
  }

  void _saveExpense() {
    if (_amountController.text.isEmpty ||
        _selectedCategoryId == null ||
        _selectedTagId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Please fill in all fields!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red));
      return;
    }

    final expense = Expense(
      id: widget.initialExpense?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      amount: double.parse(_amountController.text),
      categoryId: _selectedCategoryId!,
      payee: _payeeController.text,
      note: _noteController.text,
      date: _selectedDate,
      tag: _selectedTagId!,
    );

    final payee = Payee(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: expense.payee);

    final date = DateExpense(
      id: expense.date.toString(),
      year: expense.date.year,
      month: expense.date.month,
      day: expense.date.day,
    );

    logger.d("Expense: $expense");

    Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
    Provider.of<ExpenseProvider>(context, listen: false).addPayee(payee);
    Provider.of<ExpenseProvider>(context, listen: false).addDate(date);
    // Navigator.of(context).pop();
    Navigator.pop(context);
  }

  // void dispose() {
  //   _amountController.dispose();
  //   // _selectedCategoryId!.dispose();
  //   // _selectedDate.dispose();
  //   // _selectedTagId.dispose();
  //   _noteController.dispose();
  //   _payeeController.dispose();
  //   super.dispose();
  // }
}
