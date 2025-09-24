
import '../ModelTampo/Pharmacie.dart';
import '../model/userModel.dart';
import '../services/ApiService/ApiPharmacie.dart';
import '../services/ApiService/ApiRapportVente.dart';
import '../services/GetStorage/local_storage_service.dart';

class RapportVenteController{


  static Future<void> getRapportVente(id_pharmacie) async{
    Apirapportvente().fetchRapport();
  }


}