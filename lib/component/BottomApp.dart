
import 'package:flutter/material.dart';

class Bottomapp {
  final VoidCallback? onAccueil;
  final VoidCallback? onNotif;
  final VoidCallback? onUser;

  Bottomapp({
    this.onAccueil,
    this.onNotif,
    this.onUser,
  });

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
              onPressed: () {
                this.onAccueil;
              },
            ),
            IconButton(
              icon: Image.asset("assets/Icone/bell.png"),
              onPressed: () {
                this.onNotif;
              },
            ),
            IconButton(
              icon: Image.asset("assets/Icone/user.png"),
              onPressed: () {
                this.onUser!();
              },
            ),
          ],
        ),
      ),
    );
  }
}
