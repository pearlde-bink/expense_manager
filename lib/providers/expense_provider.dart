import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:intl/intl.dart';
import 'dart:convert';
import '../models/expense.dart';
import '../models/category.dart';
import '../models/tag.dart';
import '../models/payee.dart';
import '../models/date.dart';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;
  List<Expense> _expenses = [];
  List<Payee> _payees = [];
  List<DateExpense> _dates = [];

  final List<Category> _categories = [
    Category(id: '1', name: 'Entertainment', isDefault: true),
    Category(id: '2', name: 'Education', isDefault: true),
    Category(id: '3', name: 'Food', isDefault: true),
    Category(id: '4', name: 'Health', isDefault: true),
    Category(id: '5', name: 'Office', isDefault: true),
    Category(id: '6', name: 'Shopping', isDefault: true),
    Category(id: '7', name: 'Transport', isDefault: true),
  ];

  // List of tags
  final List<Tag> _tags = [
    Tag(id: '1', name: 'Breakfast'),
    Tag(id: '2', name: 'Lunch'),
    Tag(id: '3', name: 'Dinner'),
    Tag(id: '4', name: 'Treat'),
    Tag(id: '5', name: 'Cafe'),
    Tag(id: '6', name: 'Restaurant'),
    Tag(id: '7', name: 'Train'),
    Tag(id: '8', name: 'Vacation'),
    Tag(id: '9', name: 'Birthday'),
    Tag(id: '10', name: 'Diet'),
    Tag(id: '11', name: 'MovieNight'),
    Tag(id: '12', name: 'Tech'),
    Tag(id: '13', name: 'CarStuff'),
    Tag(id: '14', name: 'SelfCare'),
    Tag(id: '15', name: 'Streaming'),
  ];

  List<Expense> get expenses => _expenses;
  List<Category> get categories => _categories;
  List<Tag> get tags => _tags;
  List<Payee> get payees => _payees;
  List<DateExpense> get dates => _dates;

  ExpenseProvider(this.storage) {
    _loadExpensesFromStorage();
  }

  void _loadExpensesFromStorage() async {
    // WidgetsFlutterBinding.ensureInitialized();
    // await initLocalStorage();
    var storedExpenses = storage.getItem('expenses');

    if (storedExpenses != null) {
      _expenses = List<Expense>.from(
        (storedExpenses as List).map((item) => Expense.fromJson(item)),
      );
      notifyListeners();
    }
    // }
  }

  // void _loadDatesFromStorage() {
  //   var savedDates = storage.getItem('dates');
  //   if (savedDates != null) {
  //     _dates = (jsonDecode(savedDates) as List<dynamic>).map((date) {
  //       var parts = date.split('-');
  //       return DateExpense(
  //         id: UniqueKey().toString(),
  //         year: int.parse(parts[0]),
  //         month: int.parse(parts[1]),
  //         day: int.parse(parts[2]),
  //       );
  //     }).toList();
  //   }
  // }

  void _saveExpenseToStorage() {
    // storage.setItem('expenses', _expenses.map((e) => e.toJson()).toList());
    storage.setItem(
        'expenses', jsonEncode(_expenses.map((e) => e.toJson()).toList()));
  }

  void _savePayeeToStorage() {
    storage.setItem(
        'payees', jsonEncode(_payees.map((e) => e.toString()).toList()));
  }

  void _saveDatesToStorage() {
    // storage.setItem(
    //     'dates',
    //     jsonEncode(_dates
    //         .map((e) => DateFormat('yyyy-MM-dd').format(e.toDateTime()))
    //         .toList()));
    storage.setItem(
      'dates',
      jsonEncode(_dates
          .map((e) => e.toString())
          .toList()), // Use toString() for consistent format
    );
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpenseToStorage();
    notifyListeners();
  }

  void addPayee(Payee payee) {
    if (!_payees.any((p) => p == payee)) {
      _payees.add(payee);
      _savePayeeToStorage();
      notifyListeners();
    }
  }

  void addDate(DateExpense date) {
    if (!_dates.any((d) => d == date)) {
      _dates.add(date);
      _saveDatesToStorage();
      notifyListeners();
    }
  }

  void addCategory(Category category) {
    if (!_categories.any((c) => c.name == category.name)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  void addTag(Tag tag) {
    if (!_tags.any((t) => t.name == tag.name)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  void addOrUpdateExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);

    if (index != 1) {
      // Update existing expense
      _expenses[index] = expense;
    } else {
      _expenses.add(expense);
    }
    _saveExpenseToStorage();
    notifyListeners();
  }

  void removeExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    _expenses.removeAt(index);
    _saveExpenseToStorage();
    notifyListeners();
  }

  // void deleteExpense(String id) {
  //   _expenses.removeWhere((expense) => expense.id == id);
  //   _saveExpenseToStorage(); // Save the updated list to local storage
  //   notifyListeners();
  // }

  void deleteCategory(Category category) {
    int index = _categories.indexWhere((i) => i.id == category.id);
    _categories.removeAt(index);
    notifyListeners();
  }

  // void deleteCategory(String id) {
  //   _categories.removeWhere((category) => category.id == id);
  //   notifyListeners();
  // }

  void deleteTag(Tag tag) {
    _tags.removeWhere((t) => t.id == tag.id);
    notifyListeners();
  }

  // void deleteTag(String id) {
  //   _tags.removeWhere((tag) => tag.id == id);
  //   notifyListeners();
  // }
}
