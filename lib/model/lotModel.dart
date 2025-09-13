class Lot {
  final int idLot;
  final String numeroLot;
  final int prixAchat;
  final int quantite;
  final int prixUnitaire;
  final String dateExpiration;
  final int idMedicament;
  final int idPharmacie;
  final String createdAt;
  final String updatedAt;
  final Medicament medicament;

  Lot({
    required this.idLot,
    required this.numeroLot,
    required this.prixAchat,
    required this.quantite,
    required this.prixUnitaire,
    required this.dateExpiration,
    required this.idMedicament,
    required this.idPharmacie,
    required this.createdAt,
    required this.updatedAt,
    required this.medicament,
  });

  factory Lot.fromJson(Map<String, dynamic> json) {
    return Lot(
      idLot: json['id_lot'] ?? 0,
      numeroLot: json['numero_lot'] ?? '',
      prixAchat: json['prix_achat'] ?? 0,
      quantite: json['quantite'] ?? 0,
      prixUnitaire: json['prix_unitaire'] ?? 0,
      dateExpiration: json['date_expiration'] ?? '',
      idMedicament: json['id_medicament'] ?? 0,
      idPharmacie: json['id_pharmacie'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      medicament: json['medicament'] != null
          ? Medicament.fromJson(json['medicament'])
          : Medicament(
        idMedicament: 0,
        nom: 'Inconnu',
        description: '',
        idForme: 0,
        idDose: 0,
        createdAt: '',
        updatedAt: '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_lot': idLot,
      'numero_lot': numeroLot,
      'prix_achat': prixAchat,
      'quantite': quantite,
      'prix_unitaire': prixUnitaire,
      'date_expiration': dateExpiration,
      'id_medicament': idMedicament,
      'id_pharmacie': idPharmacie,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'medicament': medicament.toJson(),
    };
  }
}

class Medicament {
  final int idMedicament;
  final String nom;
  final String description;
  final int idForme;
  final int idDose;
  final String createdAt;
  final String updatedAt;

  Medicament({
    required this.idMedicament,
    required this.nom,
    required this.description,
    required this.idForme,
    required this.idDose,
    required this.createdAt,
    required this.updatedAt,
  });

  /*factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      idMedicament: json['id_medicament'] ?? 0,
      nom: json['nom'] ?? 'Inconnu',
      description: json['description'] ?? '',
      idForme: json['id_forme'] ?? 0,
      idDose: json['id_dose'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }*/
  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      idMedicament: json["id_medicament"],
      nom: json["nom"]+"_"+json["forme"]["nom"]+"_"+json["dose"]["quantite"]+"_"+json["dose"]["unite"],
      description: json['description'] ?? '',
      idForme: json['id_forme'] ?? 0,
      idDose: json['id_dose'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_medicament': idMedicament,
      'nom': nom,
      'description': description,
      'id_forme': idForme,
      'id_dose': idDose,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}