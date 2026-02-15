import 'package:flutter/foundation.dart';

class Dose {
  late int id ;
  late String nom;

  Dose({ required this.nom, required this.id});


  factory Dose.fromJson(Map<String, dynamic> dose) {
    return Dose(
      id:int.parse(dose["id"]) ,
      nom: dose["nom"].toString()
    );
  }

 Map<String,dynamic>  toJson()=>{
    "id":this.id,
   "nom":this.nom
 };
}