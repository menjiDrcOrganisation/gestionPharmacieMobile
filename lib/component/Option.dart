import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Option {
  final String? intitule; // peut être null
  final Function action;
  final String src;

  Option({required this.src, required this.action, this.intitule});

  Widget lancer() {
    return InkWell(
      onTap: () {
        action(); // exécute la fonction passée
      },
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              height: 48,
              width: 55,
              decoration: BoxDecoration(
                color: Color.fromRGBO(40, 167, 69, 1),
                borderRadius: BorderRadius.circular(12),

              ),
              child:
              Padding(padding: const EdgeInsets.all(10),
                child:Image.asset(
                  src,
                  fit: BoxFit.contain, // adapte l’image à l’espace
                ) ,)
              ,
            ),
            intitule !=null?
            Text(
              intitule ?? 'tttttttt', // affiche une chaîne vide si null
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(107, 101, 101, 1),
              ),
            ):Center(),
          ],
        ),
      ),
    );
  }
}
