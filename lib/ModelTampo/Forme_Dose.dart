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
}

class FormeAndDoseResponse {
  final List<Forme> formes;
  final List<Dose> doses;

  FormeAndDoseResponse({required this.formes, required this.doses});

  factory FormeAndDoseResponse.fromJson(Map<String, dynamic> json) {
    var formeList = (json['forme'] as List)
        .map((item) => Forme.fromJson(item))
        .toList();

    var doseList = (json['dose'] as List)
        .map((item) => Dose.fromJson(item))
        .toList();

    return FormeAndDoseResponse(formes: formeList, doses: doseList);
  }
}
