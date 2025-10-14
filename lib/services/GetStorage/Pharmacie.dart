import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_pharmacie_mobile/ModelTampo/Lot.dart';

class PharmacieStorage {
  static const String PHAR_KEY = "pharmacieSelect";
  static const String INDICE_KEY = "recupinDICE";

  /// Sauvegarder la liste de lots
  static Future<void> savePharmacie(id,indice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PHAR_KEY, id);
    await prefs.setString(INDICE_KEY, indice);
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

  static Future<String> getindice() async {
    final prefs = await SharedPreferences.getInstance();
    String? indice= prefs.getString(INDICE_KEY);

    if (indice != null) {
      return indice;
    } else {
      return "";
    }
  }



}
