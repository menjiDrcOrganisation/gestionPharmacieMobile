import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Option {
  final String? intitule; // peut être null
  final Function action;
  final IconData icon;

  Option({required this.icon, required this.action, this.intitule});

  Widget lancer() {
    return InkWell(
      onTap: () {
        action(); // exécute la fonction passée
      },
      child: Container(
        height: 70,
        width: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 48,
              width: 55,
              decoration: BoxDecoration(
                color: Color.fromRGBO(40, 167, 69, 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            Text(
              intitule ?? '', // affiche une chaîne vide si null
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
