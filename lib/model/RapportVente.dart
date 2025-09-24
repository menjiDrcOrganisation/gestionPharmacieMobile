class RapportVente {
  final Map<String, List<Vente>> ventesParDate;

  RapportVente({required this.ventesParDate});

  factory RapportVente.fromJson(Map<String, dynamic> json) {
    final Map<String, List<Vente>> data = {};
    json.forEach((date, ventesJson) {
      data[date] = (ventesJson as List)
          .map((venteJson) => Vente.fromJson(venteJson))
          .toList();
    });
    return RapportVente(ventesParDate: data);
  }
}

class Vente {
  final int idVente;
  final String dateVente;
  final String montantTotal;
  final String nomClient;
  final int idPharmacie;
  final List<Lot> lots;

  Vente({
    required this.idVente,
    required this.dateVente,
    required this.montantTotal,
    required this.nomClient,
    required this.idPharmacie,
    required this.lots,
  });

  factory Vente.fromJson(Map<String, dynamic> json) {
    return Vente(
      idVente: json['id_vente'],
      dateVente: json['date_vente'],
      montantTotal: json['montant_total'],
      nomClient: json['nom_client'],
      idPharmacie: json['id_pharmacie'],
      lots: (json['lots'] as List)
          .map((lotJson) => Lot.fromJson(lotJson))
          .toList(),
    );
  }
}

class Lot {
  final int idLot;
  final String numeroLot;
  final int prixAchat;
  final int quantite;
  final int? quantiteReel;
  final int prixUnitaire;
  final String dateExpiration;
  final int idMedicament;
  final int idPharmacie;
  final Medicament medicament;

  Lot({
    required this.idLot,
    required this.numeroLot,
    required this.prixAchat,
    required this.quantite,
    this.quantiteReel,
    required this.prixUnitaire,
    required this.dateExpiration,
    required this.idMedicament,
    required this.idPharmacie,
    required this.medicament,
  });

  factory Lot.fromJson(Map<String, dynamic> json) {
    return Lot(
      idLot: json['id_lot'],
      numeroLot: json['numero_lot'],
      prixAchat: json['prix_achat'],
      quantite: json['quantite'],
      quantiteReel: json['quantite_reel'],
      prixUnitaire: json['prix_unitaire'],
      dateExpiration: json['date_expiration'],
      idMedicament: json['id_medicament'],
      idPharmacie: json['id_pharmacie'],
      medicament: Medicament.fromJson(json['medicament']),
    );
  }
}

class Medicament {
  final int idMedicament;
  final String nom;
  final String description;
  final int idForme;
  final int idDose;
  final Forme? forme;
  final Dose? dose;

  Medicament({
    required this.idMedicament,
    required this.nom,
    required this.description,
    required this.idForme,
    required this.idDose,
    this.forme,
    this.dose,
  });

  factory Medicament.fromJson(Map<String, dynamic> json) {
    return Medicament(
      idMedicament: json['id_medicament'],
      nom: json['nom'],
      description: json['description'],
      idForme: json['id_forme'],
      idDose: json['id_dose'],
      forme: json['forme'] != null ? Forme.fromJson(json['forme']) : null,
      dose: json['dose'] != null ? Dose.fromJson(json['dose']) : null,
    );
  }
}

class Forme {
  final int idForme;
  final String nom;
  final String description;

  Forme({required this.idForme, required this.nom, required this.description});

  factory Forme.fromJson(Map<String, dynamic> json) {
    return Forme(
      idForme: json['id_forme'],
      nom: json['nom'],
      description: json['description'],
    );
  }
}

class Dose {
  final int idDose;
  final String quantite;
  final String unite;

  Dose({required this.idDose, required this.quantite, required this.unite});

  factory Dose.fromJson(Map<String, dynamic> json) {
    return Dose(
      idDose: json['id_dose'],
      quantite: json['quantite'],
      unite: json['unite'],
    );
  }
}
