import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestion_pharmacie_mobile/ModelTampo/Vente.dart';

import '../../model/RapportVente.dart';
import '../../utils/Utilis.dart';
import '../GetStorage/Pharmacie.dart';

class Apirapportvente {
  final String baseUrl = "${Utilise.baseUrl}";

  /// Récupérer toutes les rapport
  Future<RapportVente> fetchRapport() async {
    String idPharma = await PharmacieStorage.getPharma();

    final response = await http.post(
      Uri.parse("${baseUrl}RapportVente"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"id_pharmacie": int.parse(idPharma)}),
    );

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body) as Map<String, dynamic>;

      final rapport = RapportVente.fromJson(jsonData);

      return rapport; // ici c'est un objet RapportVente, pas une List
    } else {
      throw Exception("Erreur lors du chargement des ventes : ${response.statusCode}");
    }

  }

}
