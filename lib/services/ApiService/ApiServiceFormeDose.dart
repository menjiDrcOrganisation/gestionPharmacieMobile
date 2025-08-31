import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FormeDoseService {

  final String apiUrl = "http://192.168.254.136:8000/api/getallformeanddose";

  // Récupérer depuis API et stocker localement
  Future<void> fetchAndSaveFormeDose() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sauvegarde locale
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("forme_dose_data", jsonEncode(data));
      } else {
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur fetchAndSaveFormeDose : $e");
    }
  }

  // Lire depuis le stockage local
  Future<Map<String, dynamic>?> getLocalFormeDose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString("forme_dose_data");

    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  // Supprimer du stockage
  Future<void> clearFormeDose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("forme_dose_data");
  }
}
