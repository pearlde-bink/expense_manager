import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/expense.dart';
// import '../models/category.dart';
import '../screen/addExpenseScreen.dart';
// import '../screen/categoryManageScreen.dart';
// import '../screen/tagManageScreen.dart';
import '../providers/expense_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "By Date"),
            Tab(text: "By Category"),
          ],
        ),
      ),
      drawer: Drawer(
          child: ListView(padding: const EdgeInsets.all(5), children: <Widget>[
        const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text('Menu',
                style: TextStyle(color: Colors.white, fontSize: 24))),
        ListTile(
            leading: const Icon(Icons.category, color: Colors.deepPurple),
            title: const Text("Manage Categories"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/manage_categories');
            }),
        ListTile(
            leading: const Icon(Icons.tag, color: Colors.deepPurple),
            title: const Text("Manage Tags"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/manage_tags');
            }),
      ])),
      body: TabBarView(controller: _tabController, children: [
        buildExpensesByDate(context),
        buildExpenseByCategory(context),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddExpenseScreen()));
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildExpensesByDate(BuildContext context) {
    return Consumer<ExpenseProvider>(builder: (context, provider, child) {
      if (provider.expenses.isEmpty) {
        return Center(
          child: Text("Click the + button to record expenses.",
              style: TextStyle(color: Colors.grey[600], fontSize: 18)),
        );
      }
      return ListView.builder(
        itemCount: provider.expenses.length,
        itemBuilder: (context, index) {
          final expense = provider.expenses[index];
          String formattedDate = DateFormat('dd MM, yyyy').format(expense.date);
          return Dismissible(
              key: Key(expense.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.removeExpense(expense);
              },
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                  color: Colors.purple[50],
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: ListTile(
                    title: Text(
                        '${expense.payee} - \$${expense.amount.toStringAsFixed(2)}'),
                    subtitle: Text(
                        "$formattedDate - Category: ${getCategoryNameById(context, expense.categoryId)}"),
                    isThreeLine: true,
                  )));
        },
      );
    });
  }

  Widget buildExpenseByCategory(BuildContext context) {
    return Consumer<ExpenseProvider>(builder: (context, provider, child) {
      if (provider.expenses.isEmpty) {
        return Center(
          child: Text("Click the + button to record expenses.",
              style: TextStyle(color: Colors.grey[600], fontSize: 18)),
        );
      }

      var grouped = groupBy(provider.expenses, (Expense e) => e.categoryId);

      return ListView(
        children: grouped.entries.map((entry) {
          String categoryName = getCategoryNameById(context, entry.key);
          double total = entry.value.fold(
              0.0, (double prev, Expense element) => prev + element.amount);
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "$categoryName - Total: \$${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple))),
                ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // to disable scrolling within the inner list view
                    shrinkWrap:
                        true, // necessary to integrate a ListView within another ListView
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      Expense expense = entry.value[index];
                      return ListTile(
                        leading: const Icon(Icons.monetization_on,
                            color: Colors.deepPurple),
                        title: Text(
                            "${expense.payee} - \SS{expense.amount.toStringAsFixed(2)}"),
                        subtitle: Text(
                            DateFormat('dd MM, yyyy').format(expense.date)),
                      );
                    })
              ]);
        }).toList(),
      );
    });
  }

  String getCategoryNameById(BuildContext context, String categoryId) {
    var category = Provider.of<ExpenseProvider>(context, listen: false)
        .categories
        .firstWhere((c) => c.id == categoryId);
    return category.name;
  }
}