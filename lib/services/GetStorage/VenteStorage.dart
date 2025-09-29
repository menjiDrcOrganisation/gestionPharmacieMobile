import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_pharmacie_mobile/ModelTampo/Lot.dart';

import '../../ModelTampo/Vente.dart';

class VenteStorage {
  static const String VENTE_KEY = "vente";

  /// Sauvegarder la liste des ventes
  static Future<void> saveVentes(List<Vente> lots) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> lotStrings = lots.map((lot) => jsonEncode(lot.toJson())).toList();
    await prefs.setStringList(VENTE_KEY, lotStrings);
  }

  /// ajouter une vente AddVente
  static Future<void> AddVente(Map<String, dynamic> vente) async {

    //effectuer une vente en local en utilisant meme les lots en local
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ventes = prefs.getStringList(VENTE_KEY);
    final venteEncodeString=jsonEncode(vente);
    ventes!.add(venteEncodeString);

    //List<Vente> lotStrings = ventes!.map((vente) => Vente.fromJson(jsonDecode(vente))).toList();

    await prefs.setStringList(VENTE_KEY, ventes);
  }


}
