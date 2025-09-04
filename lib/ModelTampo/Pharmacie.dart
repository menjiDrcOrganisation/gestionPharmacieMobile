
class Pharmacie {
  final int id;
  final String nom;
  final String adresse;


  Pharmacie({
    required this.id,
    required this.nom,
    required this.adresse,

  });

  factory Pharmacie.fromJson(Map<String, dynamic> json) {
    return Pharmacie(
      id: json["id_pharmacie"],
      nom: json["nom"],
      adresse: json["adresse"]
    );
  }

  Map<String, dynamic> toJson() => {
    "id_pharmacie": id,
    "nom": nom,
    "adresse": adresse
  };
}




