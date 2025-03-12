import 'package:expense_tracker/constant/widgets/add_category_dialog.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Category'),
      ),
      body: Consumer<ExpenseProvider>(builder: (context, provider, child) {
        return ListView.builder(
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              return ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.deleteCategory(category.id);
                  },
                  icon: Icon(Icons.delete,color: Colors.red,),
                ),
              );
            });
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[200],
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddCategoryDialog(onAdd: (newCategory) {
              Provider.of<ExpenseProvider>(context, listen: false)
                  .addCategory(newCategory);
              Navigator.pop(context);
            }),
          );
        },
        tooltip: 'Add New Category',
        child: Icon(Icons.add),
      ),
    );
  }
}
