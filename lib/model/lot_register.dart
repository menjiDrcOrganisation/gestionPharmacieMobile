class Lot_register {
  final int? idLot;
  final int idMedicament;
  final int quantite;
  final String dateExpiration;
  final int prixAchat;
  final int idPharmacie;

  Lot_register({
    this.idLot,
    required this.idMedicament,
    required this.quantite,
    required this.dateExpiration,
    required this.prixAchat,
    required this.idPharmacie,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_medicament': idMedicament,
      'quantite': quantite,
      'date_expiration': dateExpiration,
      'prix_achat': prixAchat,
      'id_pharmacie': idPharmacie,
    };
  }

  factory Lot_register.fromJson(Map<String, dynamic> json) {
    return Lot_register(
      idLot: json['id_lot'],
      idMedicament: json['id_medicament'],
      quantite: json['quantite'] ,
      dateExpiration: json['date_expiration'],
      prixAchat: json['prix_achat'],
      idPharmacie: json['id_pharmacie'],
    );
  }
}
