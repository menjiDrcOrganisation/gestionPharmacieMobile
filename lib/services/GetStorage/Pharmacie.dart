import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_pharmacie_mobile/ModelTampo/Lot.dart';

class PharmacieStorage {
  static const String PHAR_KEY = "pharmacieSelect";

  /// Sauvegarder la liste de lots
  static Future<void> savePharmacie(id) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(PHAR_KEY, id);
  }

  /// Récupérer la liste de lots
  static Future<String> getPharma() async {

    final prefs = await SharedPreferences.getInstance();
    String? id= prefs.getString(PHAR_KEY);

    if (id != null) {
      return id;
    } else {
      return "";
    }
  }


}
