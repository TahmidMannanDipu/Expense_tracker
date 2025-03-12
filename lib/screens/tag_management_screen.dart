import 'package:expense_tracker/constant/widgets/add_tag_dialog.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagManagementScreen extends StatelessWidget {
  const TagManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tag'),
      ),
      body: Consumer<ExpenseProvider>(builder: (context, provider, child) {
        return ListView.builder(
            itemCount: provider.tags.length,
            itemBuilder: (context, index) {
              final tag = provider.tags[index];
              return ListTile(
                title: Text(tag.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.deleteTag(tag.id);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              );
            });
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[200],
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTagDialog(onAdd: (newTag) {
              Provider.of<ExpenseProvider>(context, listen: false)
                  .addTag(newTag);
            }),
          );
        },
        tooltip: 'Add New Tag',
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
