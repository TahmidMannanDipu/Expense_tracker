import 'package:collection/collection.dart';
import 'package:expense_tracker/constant/app_color.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              text: 'By Date',
            ),
            Tab(
              text: 'By Category',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(),
            ),
          );
        },
        tooltip: 'Add Expense',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColor.primaryColor),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Manage Categories'),
              leading: Icon(
                Icons.category,
                color: AppColor.primaryColor,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_categories');
              },
            ),
            ListTile(
              title: Text('Manage Tags'),
              leading: Icon(
                Icons.tag,
                color: AppColor.primaryColor,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_tags');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        buildExpensesByDate(context),
        buildExpensesByCategory(context),
      ]),
    );
  }

  buildExpensesByDate(BuildContext context) {
    return Consumer<ExpenseProvider>(builder: (context, provider, child) {
      if (provider.expenses.isEmpty) {
        return Center(
          child: Text(
            "Click the + button to record expenses.",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
            ),
          ),
        );
      }
      return ListView.builder(
          itemCount: provider.expenses.length,
          itemBuilder: (context, index) {
            final expense = provider.expenses[index];
            String formattedDate =
                DateFormat('dd MMM, yyyy').format(expense.date);
            return Dismissible(
              key: Key(expense.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.removeExpense(expense.id);
              },
              background: Container(
                color: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              child: Card(
                color: Colors.redAccent[100],
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: ListTile(
                  title: Text(
                      "${expense.payee} - \$${expense.amount.toStringAsFixed(2)}"),
                  subtitle: Text(
                      "$formattedDate - category: ${getCategoryNameById(context, expense.categoryId)}"),
                  isThreeLine: true,
                ),
              ),
            );
          });
    });
  }

  Widget buildExpensesByCategory(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return Center(
            child: Text("Click the + button to record expenses.",
                style: TextStyle(color: Colors.grey[600], fontSize: 18)),
          );
        }
        // Grouping expenses by category
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
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "$categoryName - Total: \$${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                ListView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // to disable scrolling within the inner list view
                  shrinkWrap:
                      true, // necessary to integrate a ListView within another ListView
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    Expense expense = entry.value[index];
                    return ListTile(
                      leading: Icon(Icons.monetization_on, color: Colors.red),
                      title: Text(
                          "${expense.payee} - \$${expense.amount.toStringAsFixed(2)}"),
                      subtitle:
                          Text(DateFormat('dd MMM, yyyy').format(expense.date)),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  String getCategoryNameById(BuildContext context, String categoryId) {
    var category = Provider.of<ExpenseProvider>(context, listen: false)
        .categories
        .firstWhere((cat) => cat.id == categoryId);
    return category.name;
  }
}
