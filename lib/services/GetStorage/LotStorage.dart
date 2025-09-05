import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_pharmacie_mobile/ModelTampo/Lot.dart';

class LotStorage {
  static const String LOT_KEY = "lots";

  /// Sauvegarder la liste de lots
  static Future<void> saveLots(List<Lot> lots) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> lotStrings = lots.map((lot) => jsonEncode(lot.toJson())).toList();
    await prefs.setStringList(LOT_KEY, lotStrings);
  }

  /// Récupérer la liste de lots
  static Future<List<Lot>> getLots() async {
    print("pppppp");
    final prefs = await SharedPreferences.getInstance();
    final List<String>? lotStrings = prefs.getStringList(LOT_KEY);

    if (lotStrings != null) {
      return lotStrings.map((str) => Lot.fromJson(jsonDecode(str))).toList();
    } else {
      return [];
    }
  }

  /// Ajouter un lot (ou mettre à jour si existant)
  static Future<void> addOrUpdateLot(Lot lot) async {
    List<Lot> lots = await getLots();

    // Vérifier si le lot existe déjà
    int index = lots.indexWhere((l) => l.idLot == lot.idLot);
    if (index >= 0) {
      lots[index] = lot; // mise à jour
    } else {
      lots.add(lot); // ajout
    }

    await saveLots(lots);
  }

  /// Supprimer un lot
  static Future<void> deleteLot(int idLot) async {
    List<Lot> lots = await getLots();
    lots.removeWhere((lot) => lot.idLot == idLot);
    await saveLots(lots);
  }

  /// Supprimer tous les lots
  static Future<void> clearLots() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(LOT_KEY);
  }
}
