import 'package:flutter/material.dart';

import '../Colors.dart';

Widget createPaiementMarchandCard({
  required String montant,
  required String heure,
  String titre = 'Paiement Marchand',
  Color? backgroundColor,
  VoidCallback? onVoirDetailsTap,

}) {
  return  Container(

    margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black26, // couleur de la bordure
            width: 0.3,           // épaisseur de la bordure
          )
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(Icons.access_time_sharp),
          ),
          SizedBox(width: 12), // espace entre l'icône et le texte
          Expanded( // prend tout l'espace restant
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titre,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10,),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(text: "Montant  ",style: TextStyle(
                        fontWeight: FontWeight.w100,
                          fontSize: 17
                      )),
                      TextSpan(
                        text: "${montant} Fc",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: MyColors.primaryColor),
                      ),
                    ],
                  ),
                )
                ,
                SizedBox(height: 10,),

                Row(
                  children: [
                    Text(
                      heure,
                      style: TextStyle(color: Colors.black),
                    ),
                    Spacer(), // pousse "voir plus" à droite
                    GestureDetector(
                      onTap: onVoirDetailsTap,
                      child: Text(
                        "Voir plus",
                        style: TextStyle(
                          color: Colors.grey[600],

                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
}
