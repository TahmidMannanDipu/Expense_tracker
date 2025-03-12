import 'package:expense_tracker/constant/app_color.dart';
import 'package:expense_tracker/constant/widgets/add_category_dialog.dart';
import 'package:expense_tracker/constant/widgets/add_tag_dialog.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? initialExpense;
  const AddExpenseScreen({super.key, this.initialExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late TextEditingController _amountController;
  late TextEditingController _payeeController;
  late TextEditingController _noteController;
  String? _selectedCategoryId;
  String? _selectedTagId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(
        text: widget.initialExpense?.amount.toString() ?? '');
    _payeeController = TextEditingController(
        text: widget.initialExpense?.payee.toString() ?? '');
    _noteController = TextEditingController(
        text: widget.initialExpense?.note.toString() ?? '');
    _selectedDate = widget.initialExpense?.date ?? DateTime.now();
    _selectedCategoryId = widget.initialExpense?.categoryId;
    _selectedTagId = widget.initialExpense?.tag;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialExpense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            buildTextField(
              _amountController,
              'Amount',
              TextInputType.numberWithOptions(decimal: true),
            ),
            buildTextField(_payeeController, 'Payee', TextInputType.text),
            buildTextField(_noteController, 'Note', TextInputType.text),
            buildDateField(_selectedDate),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: buildCategoryDropdown(expenseProvider),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildTagDropdown(expenseProvider),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: _saveExpense,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text("Save Expense"),
        ),
      ),
    );
  }

  //* BUILD TEXT FIELD
  Widget buildTextField(
      TextEditingController controller, String label, TextInputType type) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: type,
    );
  }

  //* BUILD DATE PICKER FIELD

  Widget buildDateField(DateTime _selectedDate) {
    return ListTile(
      title: Text('Date: ${DateFormat("dd-MM-yyyy").format(_selectedDate)}'),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != _selectedDate) {
          setState(
            () {
              _selectedDate = picked;
            },
          );
        }
      },
    );
  }

//* BUILD CATEGORY DROPDOWN
  Widget buildCategoryDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField(
        value: _selectedCategoryId,
        items: provider.categories.map<DropdownMenuItem<String>>((category) {
          return DropdownMenuItem(
            value: category.id,
            child: Text(category.name),
          );
        }).toList()
          ..add(
            DropdownMenuItem(
              value: "New",
              child: Text("Add New Category"),
            ),
          ),
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        onChanged: (newValue) {
          if (newValue == 'New') {
            showDialog(
                context: context,
                builder: (context) => AddCategoryDialog(onAdd: (newCategory) {
                      setState(() {
                        _selectedCategoryId = newCategory.id;
                        provider.addCategory(newCategory);
                      });
                    }));
          } else {
            setState(() {
              _selectedCategoryId = newValue;
            });
          }
        });
  }

//* BUILD TAG DROPDOWN ITEM
  Widget buildTagDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField(
        value: _selectedTagId,
        items: provider.tags.map((tag) {
          return DropdownMenuItem(value: tag.id, child: Text(tag.name));
        }).toList()
          ..add(
            DropdownMenuItem(
              value: "New",
              child: Text("Add New Tag"),
            ),
          ),
        decoration: InputDecoration(
          labelText: 'Tag',
          border: OutlineInputBorder(),
        ),
        onChanged: (newValue) {
          if (newValue == 'New') {
            showDialog(
                context: context,
                builder: (context) => AddTagDialog(onAdd: (newTag) {
                      setState(() {
                        _selectedTagId = newTag.id;
                        provider.addTag(newTag);
                      });
                    }));
          } else {
            setState(() {
              _selectedTagId = newValue;
            });
          }
        });
  }

  void _saveExpense() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields!'),
        ),
      );
      return;
    }

    final expense = Expense(
      id: widget.initialExpense?.id ?? DateTime.now().toString(),
      amount: double.parse(_amountController.text),
      categoryId: _selectedCategoryId!,
      payee: _payeeController.text,
      note: _noteController.text,
      date: _selectedDate,
      tag: _selectedTagId!,
    );
    Provider.of<ExpenseProvider>(context, listen: false)
        .addOrUpdateExpense(expense);
    Navigator.pop(context);
  }
}
