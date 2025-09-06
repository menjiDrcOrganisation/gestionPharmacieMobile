

import 'package:flutter/material.dart';

class Prix {
  String intitule ,montant;

  Prix({required this.intitule,required this.montant,});

  lancer(

      ){
    return Container(
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),

      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(intitule,
              style: const TextStyle(
                fontSize: 20,

                color:  Colors.grey,
              )),
          Text(montant,
              style: const TextStyle(
                fontSize: 20,
                color:  Color.fromRGBO(40, 167, 69, 1),
              )),
        ],
      ),

    );
  }
}