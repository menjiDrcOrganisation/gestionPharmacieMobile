import 'dart:convert';
import 'package:gestion_pharmacie_mobile/utils/Utilis.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/lotModel.dart';
import '../../model/lot_register.dart';


class LotService {
  final String baseUrl = Utilise.baseUrl+"lots";

  /// Récupération API

  Future<List<Lot>> fetchLots() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/1"));

      if (response.statusCode == 200) {
        print('Réponse API brute: ${response.body}');

        // Décoder le JSON
        final dynamic decodedData = jsonDecode(response.body);

        List<Lot> lots = [];

        // Vérifier le type de réponse
        if (decodedData is List) {
          // Si c'est une liste
          for (var item in decodedData) {
            if (item is Map<String, dynamic>) {
              try {
                lots.add(Lot.fromJson(item));
              } catch (e) {
                print('Erreur parsing item: $e');
                print('Item problématique: $item');
              }
            }
          }
        } else if (decodedData is Map<String, dynamic>) {
          // Si c'est un objet avec une clé contenant la liste
          // Essayez de trouver la clé qui contient les lots
          final possibleKeys = ['data', 'lots', 'results', 'items'];
          for (var key in possibleKeys) {
            if (decodedData.containsKey(key) && decodedData[key] is List) {
              for (var item in decodedData[key]) {
                if (item is Map<String, dynamic>) {
                  try {
                    lots.add(Lot.fromJson(item));
                  } catch (e) {
                    print('Erreur parsing item: $e');
                  }
                }
              }
              break;
            }
          }

          // Si aucune clé standard n'est trouvée, essayez de parser tout l'objet
          if (lots.isEmpty) {
            try {
              lots.add(Lot.fromJson(decodedData));
            } catch (e) {
              print('Erreur parsing object complet: $e');
            }
          }
        }

        print("Nombre de lots récupérés: ${lots.length}");
        print("Détails des lots: $lots");

        // Sauvegarde locale
        await saveLots(lots);

        return lots;
      } else {
        print('Erreur HTTP: ${response.statusCode}');
        print('Body erreur: ${response.body}');
        throw Exception("Erreur lors de la récupération des lots: ${response.statusCode}");
      }
    } catch (e) {
      print('Erreur fetchLots: $e');
      // En cas d'erreur, retourner les données locales
      return await getLocalLots();
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

  Future<Map<String, dynamic>> updatelot(
      int idlot,

      int quantite,
      String dateExpiration,
      int prixAchat,
      ) async {
    print('bien');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? ''; // récupération token

    final response = await http.put(
      Uri.parse('$baseUrl/ $idlot'),
      headers: {
        "Content-Type": "application/json",
        //"Authorization": "Bearer $token", // si ton API est protégée
      },
      body:jsonEncode( {
        "quantite": quantite,
        "date_expiration":dateExpiration,
        "prix_achat":prixAchat
      }),
    );

    if (response.statusCode == 201 ) {
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

  Future<Map<String, dynamic>> setprixunitaire(
      int idlot,

      int prix_unitaire
      ) async {
    print('bien');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? ''; // récupération token

    final response = await http.put(
      Uri.parse('$baseUrl/ $idlot/prixunitaire'),
      headers: {
        "Content-Type": "application/json",
        //"Authorization": "Bearer $token", // si ton API est protégée
      },
      body:jsonEncode( {

        "prix_unitaire":prix_unitaire
      }),
    );

    if (response.statusCode == 201 ) {
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


  Future<Map<String, dynamic>> deletelot(
      int idlot,


      ) async {
    print('bien');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? ''; // récupération token

    final response = await http.delete(
      Uri.parse('$baseUrl/ $idlot'),
      headers: {
        "Content-Type": "application/json",
        //"Authorization": "Bearer $token", // si ton API est protégée
      },

    );

    if (response.statusCode == 201 ) {
      print('benikasu');
      final data = jsonDecode(response.body);
      print(jsonDecode(response.body));
      return {
        'data': data
      };
    } else {
      throw Exception("Erreur lors de suppression du lot: ${response.statusCode}");
    }
  }


  
}
