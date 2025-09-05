import 'package:gestion_pharmacie_mobile/ModelTampo/Medicament.dart';
import 'package:gestion_pharmacie_mobile/ModelTampo/Pharmacie.dart';

class Lot {
  final int idLot;
  final int quantite;
  final int prixAchat;
  final int prixUnitaire;
  final String numeroLot;
  final String dateExpiration;
  final String createdAt;
  final String updatedAt;
  final Medicament medicament;
  final Pharmacie pharmacie;

  Lot({
    required this.idLot,
    required this.quantite,
    required this.prixAchat,
    required this.prixUnitaire,
    required this.numeroLot,
    required this.dateExpiration,
    required this.createdAt,
    required this.updatedAt,
    required this.medicament,
    required this.pharmacie,
  });


  factory Lot.fromJson(Map<String, dynamic> json) {
    return Lot(
      idLot: json['id_lot'] as int,
      quantite: json['quantite'] as int,
      prixAchat: json['prix_achat'] as int,
      prixUnitaire: json['prix_unitaire'] as int,
      numeroLot: json['numero_lot'] as String,
      dateExpiration: json['date_expiration'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      medicament: Medicament.fromJson(json['medicament']),
      pharmacie: Pharmacie.fromJson(json['pharmacie']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_lot': idLot,
      'quantite': quantite,
      'prix_achat': prixAchat,
      'prix_unitaire': prixUnitaire,
      'numero_lot': numeroLot,
      'date_expiration': dateExpiration,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'medicament': medicament.toJson(),
      'pharmacie': pharmacie.toJson(),
    };
  }
}
