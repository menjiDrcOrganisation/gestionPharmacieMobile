import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../ModelTampo/Pharmacie.dart';
import '../../model/userModel.dart';
import '../../utils/Utilis.dart';
import '../GetStorage/local_storage_service.dart';

class PharmacieService {
  static final String baseUrl = "${Utilise.baseUrl}pharmacies";

  // Récupérer toutes les pharmacies
  Future<List<Pharmacie>> fetchPharmacies() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {

      final jsonResponse = jsonDecode(response.body); // objet complet
      final data = jsonResponse["data"] as List<dynamic>; // cast en List

      return data.map((json) => Pharmacie.fromJson(json)).toList();
    } else {
      throw Exception(
          "Erreur lors de la récupération des pharmacies : ${response.statusCode}");
    }
  }
  // Récupérer une pharmacie par ID
  Future<Pharmacie> fetchPharmacieById(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Pharmacie.fromJson(data);
    } else {
      throw Exception("Erreur lors de la récupération de la pharmacie $id : ${response.statusCode}");
    }
  }

  // Récupérer les pharmacies d’un gérant
  Future<List<Pharmacie>> fetchPharmaciesDuGerant(int idGerant) async {
    RoleInfo? user = await LocalStorageService().getRoleInfo();
    int? idUser=user?.id;

    final response = await http.get(
      Uri.parse("$baseUrl/gerant/$idUser"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Pharmacie.fromJson(json)).toList();
    } else {
      throw Exception("Erreur lors de la récupération des pharmacies du gérant $idGerant : ${response.statusCode}");
    }
  }

  // Ajouter une pharmacie
  Future<Pharmacie> createPharmacie(Pharmacie pharmacie) async {
    final response = await http.post(
      Uri.parse("$baseUrl"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(pharmacie.toJson()),
    );
print("pharmacies ${response.body}");
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Pharmacie.fromJson(data);
    } else {
      throw Exception("Erreur lors de la création de la pharmacie : ${response.statusCode}");
    }
  }

  // Mettre à jour une pharmacie
  Future<Pharmacie> updatePharmacie(int id, Pharmacie pharmacie) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(pharmacie.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Pharmacie.fromJson(data);
    } else {
      throw Exception("Erreur lors de la mise à jour de la pharmacie $id : ${response.statusCode}");
    }
  }

  // Supprimer une pharmacie
  Future<void> deletePharmacie(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode != 204) {
      throw Exception("Erreur lors de la suppression de la pharmacie $id : ${response.statusCode}");
    }
  }
}
