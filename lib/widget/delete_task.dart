// delete_task.dart
import 'package:flutter/material.dart';
import 'package:todo_list/constants/custom_color.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        "Hapus",
        style: TextStyle(
          color: CustomColor.warna2,
        ),
      ),
      content: Text(
        "Kamu Yakin Ingin Menghapus?",
        style: TextStyle(
          color: CustomColor.warna2,
        ),
      ),
      backgroundColor: CustomColor.warna1,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: CustomColor.warna3,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 171, 22, 11),
          ),
          child: Text(
            "Delete",
            style: TextStyle(
              color: CustomColor.warna3,
            ),
          ),
        ),
      ],
    ),
  );
}
