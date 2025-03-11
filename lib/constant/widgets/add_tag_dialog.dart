import 'package:flutter/material.dart';

import '../../models/tag.dart';

class AddTagDialog extends StatefulWidget {
  final Function(Tag) onAdd;
  const AddTagDialog({super.key, required this.onAdd});

  @override
  State<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add tag'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Tag Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final tagName = _nameController.text;
            if (tagName.isNotEmpty) {
              Navigator.of(context).pop(tagName);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
