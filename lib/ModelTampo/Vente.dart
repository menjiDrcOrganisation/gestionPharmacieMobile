import 'Pharmacie.dart';
import 'VenteLot.dart';

class Vente {
  final int idVente;
  final montant_total;
  final nom_client;

  final String dateVente;
  final Pharmacie pharmacie;
  final List<VenteLot> lots; // liste des lots vendus avec détails

  Vente({
    required this.idVente,
    required this.dateVente,
    required this.pharmacie,
    required this.lots,
    required this.montant_total,
    required this.nom_client

  });

  factory Vente.fromJson(Map<String, dynamic> json) {

    print(json);
    return Vente(
      idVente: json['id_vente'],
      nom_client: json['nom_client'] ,
      montant_total: json['montant_total'] ,
      dateVente: json['date_vente'],
      pharmacie: Pharmacie.fromJson(json['pharmacie']),
      lots: (json['lots'] as List)
          .map((item) => VenteLot.fromJson(item))
          .toList(),

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
