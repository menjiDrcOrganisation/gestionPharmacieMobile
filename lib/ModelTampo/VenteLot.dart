import 'Lot.dart';

class VenteLot {
  final Lot lot;
  final int quantiteVendue;
  final int prixVente;

  VenteLot({
    required this.lot,
    required this.quantiteVendue,
    required this.prixVente,
  });

  factory VenteLot.fromJson(Map<String, dynamic> json) {
    print("fjjj");
    print(json);
    return VenteLot(
      lot: Lot.fromJson(json),
      quantiteVendue: 0,
      prixVente:0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lot': lot.toJson(),
      'quantite_vendue': quantiteVendue,
      'prix_vente': prixVente,
    };
  }
}
