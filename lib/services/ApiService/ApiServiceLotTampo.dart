import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gestion_pharmacie_mobile/ModelTampo/Lot.dart';

import '../GetStorage/LotStorage.dart';

class LotService {
   static  String baseUrl = "http://127.0.0.1:8001/api/pharmacies/1/medicaments";

  // Récupérer tous les lots
  Future<List<Lot>> fetchLots() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body); // JSON top-level = Map
      final List<dynamic> lotsJson = data["data"];
      List<Lot> lots=lotsJson.map((item) => Lot.fromJson(item)).toList();
      LotStorage.saveLots(lots);
      return lots;
    } else {
      throw Exception("Erreur lors du chargement des lots : ${response.statusCode}");
    }
  }

  // Récupérer un lot par son ID
  Future<Lot> fetchLotById(int id) async {
    final response = await http.get(Uri.parse(""));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Lot.fromJson(data);
    } else {
      throw Exception("Erreur lors du chargement du lot $id : ${response.statusCode}");
    }
  }

  // Ajouter un nouveau lot
  Future<Lot> createLot(Lot lot) async {
    final response = await http.post(
      Uri.parse(""),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(lot.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Lot.fromJson(data);
    } else {
      throw Exception("Erreur lors de la création du lot : ${response.statusCode}");
    }
  }

  // Mettre à jour un lot
  Future<Lot> updateLot(int id, Lot lot) async {
    var baseUrl;
    final response = await http.put(
      Uri.parse("$baseUrl/lots/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(lot.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Lot.fromJson(data);
    } else {
      throw Exception("Erreur lors de la mise à jour du lot $id : ${response.statusCode}");
    }
  }

  /// Supprimer un lot
  Future<void> deleteLot(int id) async {
    final response = await http.delete(Uri.parse(""));

    if (response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression du lot $id : ${response.statusCode}");
    }
  }
   }
