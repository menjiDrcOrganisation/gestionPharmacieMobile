import 'package:flutter/foundation.dart';

class Forme {
  late int id ;
  late String nom;

  Forme({ required this.nom, required this.id});


  factory Forme.fromJson(Map<String, dynamic> dose) {
    return Forme(
        id:int.parse(dose["id"]) ,
        nom: dose["nom"].toString()
    );
  }

  Map<String,dynamic>  toJson()=>{
    "id":this.id,
    "nom":this.nom
  };
}