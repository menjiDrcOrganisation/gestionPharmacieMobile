
import 'package:flutter/material.dart';

class Bottomapp {
  BottomAppBar lancer() {
    return BottomAppBar(
      color: Colors.white,
      child: SizedBox(
        height: 60, // hauteur de la barre
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // espace entre les icônes
          crossAxisAlignment: CrossAxisAlignment.center,     // centre verticalement
          children: [
            IconButton(
              icon: Image.asset("assets/Icone/accueil.png"),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset("assets/Icone/bell.png"),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset("assets/Icone/user.png"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
