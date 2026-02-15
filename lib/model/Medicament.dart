import '../ModelTampo/Forme_Dose.dart';

class Medicament {
  final int id;
  final String nom;
  final String description;
  final int idForme;
  final int idDose;
  final Forme forme;
  final Dose dose;

  Medicament({
    required this.id,
    required this.nom,
    required this.description,
    required this.idForme,
    required this.idDose,
    required this.forme,
    required this.dose
  });

  factory Medicament.fromJson(Map<String, dynamic> json) {

    Medicament medoc = Medicament(
      id: int.parse(json["id_medicament"].toString()),
      nom: "${json["nom"]}_${json["forme"]["nom"]}_${json["dose"]["quantite"]}_${json["dose"]["unite"]}",
      description: json["description"]??"",
      forme: Forme.fromJson(json["forme"]),
      dose: Dose.fromJson(json["dose"]),
      idForme: int.parse(json["id_forme"].toString()),
      idDose: int.parse(json["id_dose"].toString()),
    );
    return medoc;
  }

  Map<String, dynamic> toJson() => {
    "id_medicament": id,
    "nom": nom,
    "description": description,
    "id_forme": idForme,
    "id_dose": idDose,
  };
}
