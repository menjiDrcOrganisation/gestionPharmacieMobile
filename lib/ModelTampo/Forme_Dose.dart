

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

