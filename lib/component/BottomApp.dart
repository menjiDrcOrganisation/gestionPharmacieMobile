import 'package:flutter/material.dart';

class Bottomapp {
  final VoidCallback? onAccueil;
  final VoidCallback? onNotif;
  final VoidCallback? onUser;
  final int notifCount;

  Bottomapp({
    this.onAccueil,
    this.onNotif,
    this.onUser,
    this.notifCount = 0,
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
                this.onAccueil!();
              },
            ),
            InkWell(
              onTap:onNotif ,
              child:
              Stack(
                children: [
                  IconButton(
                    icon: Image.asset("assets/Icone/bell.png"),
                    onPressed:null ,
                  ),
                  if (notifCount > 0) // affiché seulement si > 0
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$notifCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
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
