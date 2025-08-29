
import 'package:flutter/material.dart';

import 'Colors.dart';

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
        backgroundColor: ColorsApp.primaryColor,
      automaticallyImplyLeading: true,
      // utilisation du titre injecté
    );
  }
}
