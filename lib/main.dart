import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../screen/homeScreen.dart';
import '../screen/categoryManageScreen.dart';
import '../screen/tagManageScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({Key? key, required this.localStorage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ExpenseProvider(localStorage)),
        ],
        child: MaterialApp(
            title: 'Expense Tracker',
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => HomeScreen(),
              '/manage_categories': (context) => CategoryManageScreen(),
              '/manage_tags': (context) => TagManageScreen(),
            }));
  }
}
