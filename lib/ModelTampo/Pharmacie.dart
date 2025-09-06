class Pharmacie {
  final int? id; // id peut être null lors de la création
  final String nom;
  final String adresse;
  final String telephone;
  final int indice;
  final int idGerant;
  final String statut;
  final String? createdAt;
  final String? updatedAt;

  Pharmacie({
    this.id,
    required this.nom,
    required this.adresse,
    required this.telephone,
    required this.indice,
    required this.idGerant,
    required this.statut,
    this.createdAt,
    this.updatedAt,
  });

  // Création d'une instance à partir d'un JSON
  factory Pharmacie.fromJson(Map<String, dynamic> json) {
    return Pharmacie(
      id: json['id_pharmacie'],
      nom: json['nom'] ?? '',
      adresse: json['adresse'] ?? '',
      telephone: json['telephone'] ?? '',
      indice: json['indice'] ?? 0,
      idGerant: json['id_gerant'] ?? 0,
      statut: json['statut'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Conversion d'une instance en JSON
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'adresse': adresse,
      'telephone': telephone,
      'indice': indice,
      'id_gerant': idGerant,
      'statut': statut,
    };
  }
}
