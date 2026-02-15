import 'package:flutter/material.dart';

class Appbar {
  final String Title;
  final Widget? pageDeRemplacement; // optionnel : page à ouvrir si retour

  Appbar({required this.Title, this.pageDeRemplacement});

  AppBar lancer(BuildContext context) {
    return AppBar(
      title: Text(
        Title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.green, // remplace avec MyColors.primaryColor
      automaticallyImplyLeading: true,
      leading: pageDeRemplacement != null
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(
            context,
            true,
          );

        },
      )
          : null, // sinon bouton retour par défaut
    );
  }
}

