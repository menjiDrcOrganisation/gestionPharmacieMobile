class Forme {
  final int idForme;
  final String nom;
  final String description;
  final String createdAt;
  final String updatedAt;

  Forme({
    required this.idForme,
    required this.nom,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Forme.fromJson(Map<String, dynamic> json) {
    return Forme(
      idForme: json['id_forme'],
      nom: json['nom'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_forme': idForme,
      'nom': nom,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}