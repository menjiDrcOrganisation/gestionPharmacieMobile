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

class Dose {
  final int idDose;
  final String quantite;
  final String unite;
  final String createdAt;
  final String updatedAt;

  Dose({
    required this.idDose,
    required this.quantite,
    required this.unite,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Dose.fromJson(Map<String, dynamic> json) {
    return Dose(
      idDose: json['id_dose'],
      quantite: json['quantite'],
      unite: json['unite'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_dose': idDose,
      'quantite': quantite,
      'unite': unite,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

