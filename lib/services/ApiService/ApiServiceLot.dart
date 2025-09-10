import 'dart:convert';
import 'package:gestion_pharmacie_mobile/utils/Utilis.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/lotModel.dart';
import '../../model/lot_register.dart';
import '../GetStorage/Pharmacie.dart';


class LotService {
  final String baseUrl = Utilise.baseUrl+"lots";

  /// Récupération API

  Future<List<Lot>> fetchLots() async {
    String idPharma = await PharmacieStorage.getPharma();
    print("Pharmacie ID: $idPharma");

    try {
      final response = await http.get(Uri.parse("$baseUrl/$idPharma"));

      if (response.statusCode == 200) {
        print('Réponse API brute: ${response.body}');
        final decodedData = jsonDecode(response.body);

        if (decodedData is List) {
          // On parse chaque lot
          final lots = decodedData.map((e) => Lot.fromJson(e)).toList();

          print("Nombre de lots récupérés: ${lots.length}");
          print("Détails des lots: $lots");

          // Sauvegarde locale
          await saveLots(lots,idPharma);

          return lots;
        } else {
          throw Exception("Format de réponse inattendu: ${decodedData.runtimeType}");
        }
      } else {
        print('Erreur HTTP: ${response.statusCode}');
        print('Body erreur: ${response.body}');
        throw Exception("Erreur lors de la récupération des lots: ${response.statusCode}");
      }
    } catch (e) {
      print('Erreur fetchLots: $e');

      // Fallback → récupérer les données locales
      final localLots = await getLocalLots(idPharma);
      return localLots.isNotEmpty ? localLots : <Lot>[]; // garanti jamais null
    }
  }

  /// Sauvegarde locale avec SharedPreferences
  Future<void> saveLots(List<Lot> lots,String idPharma) async {
    final prefs = await SharedPreferences.getInstance();
    String lotsJson = jsonEncode(lots.map((e) => e.toJson()).toList());
    await prefs.setString("lots_$idPharma", lotsJson);
  }

  /// Chargement local
  Future<List<Lot>> getLocalLots(String idPharma) async {
    final prefs = await SharedPreferences.getInstance();
    String? lotsJson = prefs.getString("lots_$idPharma");

    if (lotsJson != null) {
      List<dynamic> body = jsonDecode(lotsJson);
      return body.map((e) => Lot.fromJson(e)).toList();
    }
    return [];
  }


  Future<Map<String, dynamic>> createLot(Lot_register Lot_register) async {

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
    print(response);
    if (response.statusCode == 201) {
      print('bien');
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
