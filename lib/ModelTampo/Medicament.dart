
import 'package:gestion_pharmacie_mobile/ModelTampo/Forme_Dose.dart';

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
      forme:Forme(idForme: 1, nom: json["forme"]["nom"], description:"douleur", createdAt: "", updatedAt: ""),
      dose: Dose(idDose: 1, quantite: json["dose"]["quantite"], unite: json["dose"]["unite"], createdAt: "", updatedAt: ""),
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id_medicament": id,
    "nom": nom,
    "description": description,
  };
}
