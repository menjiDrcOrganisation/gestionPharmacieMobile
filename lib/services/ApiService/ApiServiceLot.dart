import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/lotModel.dart';
import '../../model/lot_register.dart';


class LotService {
  final String baseUrl = "http://192.168.254.136:8000/api/lots";

  /// Récupération API
  Future<List<Lot>> fetchLots() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Lot> lots = body.map((e) => Lot.fromJson(e)).toList();

      // Sauvegarde locale
      await saveLots(lots);

      return lots;
    } else {
      throw Exception("Erreur lors de la récupération des lots");
    }
  }

  /// Sauvegarde locale avec SharedPreferences
  Future<void> saveLots(List<Lot> lots) async {
    final prefs = await SharedPreferences.getInstance();
    String lotsJson = jsonEncode(lots.map((e) => e.toJson()).toList());
    await prefs.setString("lots", lotsJson);
  }

  /// Chargement local
  Future<List<Lot>> getLocalLots() async {
    final prefs = await SharedPreferences.getInstance();
    String? lotsJson = prefs.getString("lots");

    if (lotsJson != null) {
      List<dynamic> body = jsonDecode(lotsJson);
      return body.map((e) => Lot.fromJson(e)).toList();
    }
    return [];
  }


  Future<Map<String, dynamic>> createLot(Lot_register Lot_register) async {
    print('bien');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? ''; // récupération token

    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {
        "Content-Type": "application/json",
        //"Authorization": "Bearer $token", // si ton API est protégée
      },
      body: jsonEncode(Lot_register.toJson()),
    );

    if (response.statusCode == 201) {
      print('benikasu');
      final data = jsonDecode(response.body);
      print(jsonDecode(response.body));
      return {
        'data': data
      };
    } else {
      throw Exception("Erreur lors de l'enregistrement du lot: ${response.statusCode}");
    }
  }
  
}
