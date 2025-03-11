import 'package:expense_tracker/models/expense_category.dart';
import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(ExpenseCategory) onAdd;
  const AddCategoryDialog({super.key, required this.onAdd});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

final TextEditingController _nameController = TextEditingController();

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add category'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Category Name'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final categoryName = _nameController.text;
            if (categoryName.isNotEmpty) {
              Navigator.of(context).pop(categoryName);
            }
          },
          child: Text('Add'),
        )
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
