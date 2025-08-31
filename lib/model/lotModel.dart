class Lot {
  final int idLot;
  final int idPharmacie;
  final int idMedicament;
  final int quantite;
  final int prixAchat;
  final int prixUnitaire;
  final String numeroLot;
  final String dateExpiration;
  final String createdAt;
  final String updatedAt;

  Lot({
    required this.idLot,
    required this.idPharmacie,
    required this.idMedicament,
    required this.quantite,
    required this.prixAchat,
    required this.prixUnitaire,
    required this.numeroLot,
    required this.dateExpiration,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Conversion JSON → Objet Dart
  factory Lot.fromJson(Map<String, dynamic> json) {
    return Lot(
      idLot: json['id_lot'] as int,
      idPharmacie: json['id_pharmacie'] as int,
      idMedicament: json['id_medicament'] as int,
      quantite: json['quantite'] as int,
      prixAchat: json['prix_achat'] as int,
      prixUnitaire: json['prix_unitaire'] as int,
      numeroLot: json['numero_lot'] as String,
      dateExpiration: json['date_expiration'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Conversion Objet Dart → JSON
  Map<String, dynamic> toJson() {
    return {
      'id_lot': idLot,
      'id_pharmacie': idPharmacie,
      'id_medicament': idMedicament,
      'quantite': quantite,
      'prix_achat': prixAchat,
      'prix_unitaire': prixUnitaire,
      'numero_lot': numeroLot,
      'date_expiration': dateExpiration,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
