import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_pharmacie_mobile/ModelTampo/Lot.dart';

class ExpirationMedicamentStorage {
  static const String _expirationKey = "expiration_medicaments";

  /// Sauvegarder la liste complète des lots
  static Future<void> saveExpiringLots(List<Lot> lots) async {
    final prefs = await SharedPreferences.getInstance();
    final lotsJson = lots.map((lot) => jsonEncode(lot.toJson())).toList();
    await prefs.setStringList(_expirationKey, lotsJson);
  }

  /// Récupérer la liste des lots expirants
  static Future<List<Lot>> getExpiringLots() async {
    final prefs = await SharedPreferences.getInstance();
    final lotsJson = prefs.getStringList(_expirationKey);
    if (lotsJson == null) return [];
    return lotsJson.map((json) => Lot.fromJson(jsonDecode(json))).toList();
  }

  /// Ajouter un lot, sans doublons
  static Future<void> addExpiringLot(Lot lot) async {
    final lots = await getExpiringLots();
    if (!lots.any((l) => l.numeroLot == lot.numeroLot)) {
      lots.add(lot);
      await saveExpiringLots(lots);
    }
  }

  /// Supprimer un lot spécifique
  static Future<void> removeExpiringLot(String numeroLot) async {
    final lots = await getExpiringLots();
    lots.removeWhere((l) => l.numeroLot == numeroLot);
    await saveExpiringLots(lots);
  }

  /// Supprimer tous les lots expirés
  static Future<void> removeExpiredLots() async {
    final lots = await getExpiringLots();
    final updatedLots = lots.where((lot) {
      return DateTime.parse(lot.dateExpiration).isAfter(DateTime.now());
    }).toList();
    await saveExpiringLots(updatedLots);
  }

  /// Supprimer tous les lots stockés
  static Future<void> clearExpiringLots() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_expirationKey);
  }

  /// Calculer les jours restants avant expiration
  static int joursRestants(DateTime dateExpiration) {
    return dateExpiration.difference(DateTime.now()).inDays;
  }

  /// Vérifier si le lot est proche de l'expiration
  static bool isNearExpiration(DateTime dateExpiration, {int daysBefore = 7}) {
    final diff = joursRestants(dateExpiration);
    return diff <= daysBefore && diff >= 0;
  }
}
