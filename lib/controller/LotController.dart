import '../model/lotModel.dart';
import '../services/ApiService/ApiServiceLot.dart';
import '../model/lot_register.dart';
import '../services/GetStorage/Pharmacie.dart';


class LotController {
  final LotService _lotService = LotService();


  Future<List<Lot>> getLots() async {
    try {

      // Appel API
      return await _lotService.fetchLots();
    } catch (e) {
      String idPharma = await PharmacieStorage.getPharma();
      print('Erreur fetchLots: $e');

      // Tentative récupération locale
      final localLots = await _lotService.getLocalLots(idPharma);

      // Toujours retourner une liste, même vide
      return localLots.isNotEmpty ? localLots : <Lot>[];
    }
  }



  Future<Map<String, dynamic>?> enregistrerLot({
    required int idMedicament,
    required int quantite,
    required String dateExpiration,
    required int prixAchat,
    required int idPharmacie,
  }) async {

    try {
      String idPharma = await PharmacieStorage.getPharma();
      print(idPharma);
      Lot_register lot = Lot_register(
        idMedicament: idMedicament,
        quantite: quantite,
        dateExpiration: dateExpiration,
        prixAchat: prixAchat,
        idPharmacie:int.parse(idPharma)
      );

      return await _lotService.createLot(lot);
    } catch (e) {
      print("Erreur dans LotController: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updatelot({
    required int idlot,

    required int quantite,
    required String dateExpiration,
    required int prixAchat,

  }) async {
    try {
      return await _lotService.updatelot(idlot,quantite,dateExpiration,prixAchat);
    } catch (e) {
      print("Erreur dans LotController update : $e");
      return null;
    }

  }

  Future<Map<String, dynamic>?> deletelot({
    required int idlot,

  }) async {
    try {


      return await _lotService.deletelot(idlot);
    } catch (e) {
      print("Erreur dans LotController update : $e");
      return null;
    }

  }
  Future<Map<String, dynamic>?> setprixunitaire({
    required int idlot,

    required int prix_unitaire
  }) async {
    try {


      return await _lotService.setprixunitaire(idlot,prix_unitaire);
    } catch (e) {
      print("Erreur dans LotController update : $e");
      return null;
    }

  }


}
