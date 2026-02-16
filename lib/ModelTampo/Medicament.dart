
import 'package:gestion_pharmacie_mobile/ModelTampo/Forme_Dose.dart';

import '../model/Forme.dart';

class Medicament {
  final int id;
  final String nom;
  final String description;
  final Forme forme;
  final Dose dose;

  Medicament({
    required this.id,
    required this.nom,
    required this.description,
    required this.forme,
    required this.dose,
  });

  factory Medicament.fromJson(Map<String, dynamic> json) {

    return Medicament(
      id: json["id_medicament"],
      nom: json["nom"],
      forme:Forme.fromJson(json["forme"]),
      dose: Dose.fromJson(json["dose"]),
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id_medicament": id,
    "nom": nom,
    "description": description,
    "forme":forme.toJson(),
    "dose":dose.toJson(),

  };
}
