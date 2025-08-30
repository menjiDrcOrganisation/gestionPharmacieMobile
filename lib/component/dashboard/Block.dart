
import 'package:flutter/material.dart';

class Block {
  final String montant;
  final String text;
  final Function action;
  final String src;

  Block({required this.src, required this.action, required this.montant,required this.text, });

  Widget lancer() {
    return InkWell(
      onTap: () {
        action(); // exécute la fonction passée
      },
      child: Container(
        padding: const EdgeInsets.all(10),

        width: 190
        ,
        height:100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(234, 234, 234, 1), // couleur de la bordure
            width: 1,            // épaisseur de la bordure
          ),
            borderRadius: BorderRadius.circular(10)
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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

            SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    montant , // affiche une chaîne vide si null
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color:  Color.fromRGBO(40, 167, 69, 1),
                    ),
                  ),
                  Text(
                    text, // affiche une chaîne vide si null
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(107, 101, 101, 1),
                    ),
                  ),
                  Icon(Icons.access_time_rounded)

                ],
              ),
            )

           ,
          ],
        ),
      ),
    );
  }
}
