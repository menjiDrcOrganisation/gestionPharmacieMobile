import 'package:flutter/material.dart';

class SeashBar {
  Widget lancer() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Rechercher...",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

