import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestion_pharmacie_mobile/ModelTampo/Lot.dart';

import '../../utils/Utilis.dart';
import '../GetStorage/LotStorage.dart';
import '../GetStorage/Pharmacie.dart';

class LotService {

  // Récupérer tous les lots
  Future<List<Lot>> fetchLots() async {
    try {
      String idPharma = await PharmacieStorage.getPharma();
      String base = "${Utilise.baseUrl}pharmacies/${idPharma}/medicaments";
      final response = await http.get(Uri.parse(base));

      if (response.statusCode == 200) {
        // On décode directement en liste
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> lotsJson = data["data"];

        List<Lot> lots = lotsJson.map((item) => Lot.fromJson(item)).toList();
        await LotStorage.saveLots(lots);

        return lots;
      } else {
        // Erreur serveur → on lit depuis le cache
        print(" Erreur API ${response
            .statusCode}, récupération du cache local");
        return await LotStorage.getLots();
      }
    } catch (e) {
      // Erreur réseau (connexion perdue, timeout, etc.)

      return await LotStorage.getLots();
    }
  }

}
