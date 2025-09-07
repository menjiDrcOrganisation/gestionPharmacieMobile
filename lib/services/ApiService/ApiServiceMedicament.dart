import 'dart:convert';
import 'package:gestion_pharmacie_mobile/utils/Utilis.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../model/Medicament.dart';

class MedicamentService {
  final String baseUrl = Utilise.baseUrl;

  // Récupérer depuis API
  Future<List<Medicament>> fetchMedicaments() async {
    final url = Uri.parse("${baseUrl}getallmedicament");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final meds = data.map((e) => Medicament.fromJson(e)).toList();

      // Sauvegarder localement
      await saveMedicamentsLocal(meds);
      return meds;
    } else {
      throw Exception("Impossible de récupérer les médicaments");
    }
  }

  // Sauvegarder localement
  Future<void> saveMedicamentsLocal(List<Medicament> medicaments) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(medicaments.map((e) => e.toJson()).toList());
    await prefs.setString("medicaments_local", jsonString);
  }

  // Récupérer depuis local
  Future<List<Medicament>> getMedicamentsLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("medicaments_local");
    if (jsonString != null) {
      final List data = jsonDecode(jsonString);
      return data.map((e) => Medicament.fromJson(e)).toList();
    }
    return [];
  }
}
