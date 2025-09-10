




import 'package:flutter/material.dart';

confirmation(BuildContext context, String message,{
Function()? onOui,
Function()? onNon,
}
){

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Confirmation"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OUI"),
            onPressed: () {
              onOui!(); // fermer la boîte de dialogue
            },
          ),
          TextButton(
            child: Text("NON"),
            onPressed: () {
              Navigator.of(context).pop(); // fermer la boîte de dialogue
            },
          ),
        ],
      );
    },
  );
}