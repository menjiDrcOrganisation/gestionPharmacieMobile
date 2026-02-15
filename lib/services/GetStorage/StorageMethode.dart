import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageMethode {

  static String _key(String userId) => 'client_storage_$userId';

  /// Sauvegarde une liste générique
  static Future<void> save<T>(
      String userId,
      List<T> elements,
      Map<String, dynamic> Function(T) toMap,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = elements.map((e) => toMap(e)).toList();
    final jsonString = jsonEncode(jsonList);

    await prefs.setString(_key(userId), jsonString);
  }

  /// Récupère une liste générique
  static Future<List<T>> get<T>(
      String userId,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key(userId));

    if (jsonString == null) return [];

    final List list = jsonDecode(jsonString);

    return list.map((e) => fromJson(e)).toList();
  }

  /// Ajouter un élément générique
  static Future<void> add<T>(
      String userId,
      T element,
      T Function(Map<String, dynamic>) fromJson,
      Map<String, dynamic> Function(T) toMap,
      bool Function(T existing, T newElement) isSame,
      ) async {

    final current = await get<T>(userId, fromJson);

    final exists = current.any((e) => isSame(e, element));

    if (!exists) {
      current.add(element);
      await save<T>(userId, current, toMap);
    }
  }

  static Future<void> clear(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(userId));
  }
}
