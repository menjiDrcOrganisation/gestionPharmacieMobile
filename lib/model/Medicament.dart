
class Medicament {
  final int id;
  final String nom;
  final String description;
  final int idForme;
  final int idDose;

  Medicament({
    required this.id,
    required this.nom,
    required this.description,
    required this.idForme,
    required this.idDose,
  });

  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      id: json["id_medicament"],
      nom: json["nom"]+"_"+json["forme"]["nom"]+"_"+json["dose"]["quantite"]+"_"+json["dose"]["unite"],
      description: json["description"],
      idForme: json["id_forme"],
      idDose: json["id_dose"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id_medicament": id,
    "nom": nom,
    "description": description,
    "id_forme": idForme,
    "id_dose": idDose,
  };
}
