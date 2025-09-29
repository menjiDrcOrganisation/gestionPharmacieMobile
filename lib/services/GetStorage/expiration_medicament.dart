
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_pharmacie_mobile/ModelTampo/Lot.dart';

class ExpirationMedicamentStorage {
  static const String EXPIRATION_KEY = "expiration_medicaments";

  /// Sauvegarder la liste des lots à surveiller
  static Future<void> saveExpiringLots(List<Lot> lots) async {
    final prefs = await SharedPreferences.getInstance();

    // Transformer la liste des objets en JSON
    final List<String> lotsJson =
    lots.map((lot) => jsonEncode(lot.toJson())).toList();

    await prefs.setStringList(EXPIRATION_KEY, lotsJson);
  }

  /// Récupérer la liste des lots sauvegardés
  static Future<List<Lot>> getExpiringLots() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? lotsJson = prefs.getStringList(EXPIRATION_KEY);

    if (lotsJson == null) return [];

    return lotsJson.map((json) => Lot.fromJson(jsonDecode(json))).toList();
  }

  /// Ajouter un seul lot dans la liste
  static Future<void> addExpiringLot(Lot lot) async {
    final lots = await getExpiringLots();
    lots.add(lot);
    await saveExpiringLots(lots);
  }

  /// Supprimer tous les lots expirants sauvegardés
  static Future<void> clearExpiringLots() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(EXPIRATION_KEY);
  }


  int joursRestants(DateTime dateExpiration) {
    return dateExpiration.difference(DateTime.now()).inDays;
  }

  bool isNearExpiration(DateTime dateExpiration, {int daysBefore = 7}) {
    final diff = joursRestants(dateExpiration);
    return diff <= daysBefore && diff >= 0;
  }
}
