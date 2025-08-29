

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button{

  String intitule;
  Color colorButton;
  Color colorText;
  double sizeText;
  Button({required this.intitule,
    this.colorButton=Colors.white,
    this.colorText=Colors.black,
    this.sizeText=20.0
  });


  lancer(){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorButton,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // couleur de l'ombre
            spreadRadius: 0, // étendue de l'ombre
            blurRadius: 1,   // flou de l'ombre
            offset: Offset(1, 0), // décalage horizontal et vertical
          ),
        ],
      ),
      child: Text(this.intitule,style: TextStyle(
        fontSize: sizeText,
        fontWeight: FontWeight.w600,
        color: colorText,
      ),),
    )
    ;
  }
}