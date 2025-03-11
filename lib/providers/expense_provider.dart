import 'dart:convert';
import 'package:expense_tracker/models/expense_category.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/expense.dart';
import '../models/tag.dart';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;

  //* LIST OF EXPENSE
  List<Expense> _expenses = [];

  //* LIST OF CATEGORIES
  final List<ExpenseCategory> _categories = [
    ExpenseCategory(id: '1', name: 'Food', isDefault: true),
    ExpenseCategory(id: '2', name: 'Transport', isDefault: true),
    ExpenseCategory(id: '3', name: 'Entertainment', isDefault: true),
    ExpenseCategory(id: '4', name: 'Office', isDefault: true),
    ExpenseCategory(id: '5', name: 'Gym', isDefault: true),
    ExpenseCategory(id: '6', name: 'Others', isDefault: true),
  ];

  //* LIST OF TAGS
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
    Tag(id: '11', name: 'Movie'),
    Tag(id: '12', name: 'Tech'),
    Tag(id: '13', name: 'CarStuff'),
    Tag(id: '14', name: 'SelfCare'),
    Tag(id: '15', name: 'Others'),
  ];

  //*GETTERS
  List<Expense> get expenses => _expenses;
  List<ExpenseCategory> get categories => _categories;
  List<Tag> get tags => _tags;

  ExpenseProvider(this.storage) {
    _loadExpenseFromProvider();
  }

  //* LOAD DATA FROM STORAGE
  void _loadExpenseFromProvider() async {
    var storedExpense = storage.getItem('expenses');
    if (storedExpense != null) {
      _expenses = List<Expense>.from(
        (storedExpense as List).map(
          (item) => Expense.fromJson(item),
        ),
      );
    }
    notifyListeners();
  }

  //* SAVE EXPENSE TO STORAGE
  void _saveExpensesToStorage() async {
    storage.setItem(
        'expenses', jsonEncode(_expenses.map((e) => e.toJson()).toList()));
  }

  //* ADD EXPENSE
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpensesToStorage();
    notifyListeners();
  }

//* UPDATE EXPENSE
  void addOrUpdateExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    } else {
      _expenses.add(expense);
    }
    _saveExpensesToStorage();
    notifyListeners();
  }

//* REMOVE EXPENSE
  void removeExpense(String id) {
    _expenses.removeWhere((expenses) => expenses.id == id);
    _saveExpensesToStorage();
    notifyListeners();
  }

  //* ADD CATEGORY
  void addCategory(ExpenseCategory category) {
    if (!_categories.any((cat) => cat.name == category.name)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  //* DELETE CATEGORY
  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  //*ADD TAG
  void addTag(Tag tag) {
    if (!_tags.any((t) => t.name == tag.name)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  //*DELETE TAG
  void deleteTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    notifyListeners();
  }
}
