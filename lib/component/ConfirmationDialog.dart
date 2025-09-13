import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;

  const ConfirmationDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirmation"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // annuler
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true), // confirmer
          child: const Text("Confirmer"),
        ),
      ],
    );
  }
}
