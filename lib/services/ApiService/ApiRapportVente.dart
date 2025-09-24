import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestion_pharmacie_mobile/ModelTampo/Vente.dart';

import '../../utils/Utilis.dart';
import '../GetStorage/Pharmacie.dart';

class Apirapportvente {
  final String baseUrl = "${Utilise.baseUrl}";

  /// Récupérer toutes les rapport
  Future<List<Vente>> fetchRapport() async {
    String idPharma = await PharmacieStorage.getPharma();
    final response = await http.get(Uri.parse("${baseUrl}pharmacie/${idPharma}/vente"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((venteJson) => Vente.fromJson(venteJson)).toList();
    } else {
      throw Exception("Erreur lors du chargement des ventes : ${response.statusCode}");
    }
  }

}
