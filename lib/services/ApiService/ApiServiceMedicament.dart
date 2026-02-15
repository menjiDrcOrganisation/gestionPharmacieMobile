import 'dart:convert';
import 'package:gestion_pharmacie_mobile/utils/Utilis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../model/Medicament.dart';
import '../../model/userModel.dart';
import '../GetStorage/StorageMethode.dart';
import '../GetStorage/local_storage_service.dart';

class MedicamentService {
  final String baseUrl = Utilise.baseUrl;

  // Récupérer depuis API
  Future<List<Medicament>> fetchMedicaments() async {
    User? user = await LocalStorageService().getUser();
    if(user==null) {
      throw Exception("Impossible de récupérer les médicaments");
    }

    final url = Uri.parse("${baseUrl}getallmedicament");

    final response = await http.get(url);

    if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final meds = data.map((e) => Medicament.fromJson(e)).toList();
        await LocalStorageMethode.save<Medicament>(
          user.id.toString(),
          meds,
              (n) => n.toJson(),
        );
        return meds;
    } else {
        throw Exception("Impossible de récupérer les médicaments");
    }
  }
}





