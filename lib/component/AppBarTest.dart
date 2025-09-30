
import 'package:flutter/material.dart';

import 'Colors.dart';


class AppbarTest {
  final String title;
  final Widget? pageDeRemplacement; // optionnel : page à ouvrir si retour

  AppbarTest({required this.title, this.pageDeRemplacement});

  AppBar lancer(BuildContext context) {
    return AppBar(

      title: Text(title,style: TextStyle(color: Colors.white),),
      backgroundColor: MyColors.primaryColor, // remplace avec MyColors.primaryColor
      automaticallyImplyLeading: false,
      leading:pageDeRemplacement != null? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => pageDeRemplacement!),
            );
        },
      ):null,
    );
  }
}


