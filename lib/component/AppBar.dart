
import 'package:flutter/material.dart';

class Appbar {
  final String Title; // peut être null

  Appbar({required this.Title});
  AppBar lancer() {
    return AppBar(
        title: Text(Title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )
        ),
        backgroundColor: Color.fromRGBO(40, 167, 69, 1)
      // utilisation du titre injecté
    );
  }
}
