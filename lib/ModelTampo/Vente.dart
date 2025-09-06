import 'Lot.dart';
import 'Pharmacie.dart';
import 'VenteLot.dart';

class Vente {
  final int idVente;
  final String dateVente;
  final Pharmacie pharmacie;
  final List<VenteLot> lots; // liste des lots vendus avec détails
  final String createdAt;
  final String updatedAt;

  Vente({
    required this.idVente,
    required this.dateVente,
    required this.pharmacie,
    required this.lots,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vente.fromJson(Map<String, dynamic> json) {
    return Vente(
      idVente: json['id_vente'],
      dateVente: json['date_vente'],
      pharmacie: Pharmacie.fromJson(json['pharmacie']),
      lots: (json['lots'] as List)
          .map((item) => VenteLot.fromJson(item))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_vente': "2025-08-17",
      'lots': lots.map((lot) => lot.toJson()).toList(),
      "lots_ids":lots.map((lot) => lot.lot.idLot).toList(),
      "quantite_medicament_lot":lots.map((lot) => lot.quantiteVendue).toList(),

    };
  }
}
