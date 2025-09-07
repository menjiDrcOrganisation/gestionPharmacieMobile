import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestion_pharmacie_mobile/ModelTampo/Vente.dart';

import '../../utils/Utilis.dart';
import '../GetStorage/Pharmacie.dart';

class VenteService {
  final String baseUrl = "${Utilise.baseUrl}";

  /// Récupérer toutes les ventes
  Future<List<Vente>> fetchVentes() async {
    String idPharma = await PharmacieStorage.getPharma();
    final response = await http.get(Uri.parse("${baseUrl}pharmacie/${idPharma}/vente"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((venteJson) => Vente.fromJson(venteJson)).toList();
    } else {
      throw Exception("Erreur lors du chargement des ventes : ${response.statusCode}");
    }
  }

  /// Récupérer une vente par son ID
  Future<Vente> fetchVenteById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/ventes/$id"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Vente.fromJson(data);
    } else {
      throw Exception("Erreur lors du chargement de la vente $id : ${response.statusCode}");
    }
  }

  /// Ajouter une nouvelle vente
  Future<void> createVente(Map<String, dynamic> vente) async {
    String idPharma = await PharmacieStorage.getPharma();
    print(jsonEncode(vente));
    final response = await http.post(
      Uri.parse("${baseUrl}pharmacie/${idPharma}/vente"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(vente),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
    } else {
      throw Exception("Erreur lors de la création de la vente : ${response.statusCode}");
    }
  }

  /// Mettre à jour une vente
  Future<Vente> updateVente(int id, Vente vente) async {
    final response = await http.put(
      Uri.parse("$baseUrl/ventes/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(vente.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Vente.fromJson(data);
    } else {
      throw Exception("Erreur lors de la mise à jour de la vente $id : ${response.statusCode}");
    }
  }

  /// Supprimer une vente
  Future<void> deleteVente(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/ventes/$id"));

    if (response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression de la vente $id : ${response.statusCode}");
    }
  }
}
