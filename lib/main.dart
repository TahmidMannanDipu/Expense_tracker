import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/screens/category_management_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/tag_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'constant/app_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;
  const MyApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(localStorage),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: AppColor.primaryColor,
              centerTitle: true,
              foregroundColor: Colors.white // AppBar color
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll<Color>(AppColor.primaryColor),
              foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
              fixedSize: WidgetStatePropertyAll<Size>(
                Size(double.maxFinite, 50),
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/manage_categories': (context) => CategoryManagementScreen(),
          '/manage_tags': (context) => TagManagementScreen(),
        },
      ),
    );
  }
}
