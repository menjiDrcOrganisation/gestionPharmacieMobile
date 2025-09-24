
import '../ModelTampo/Pharmacie.dart';
import '../ModelTampo/Vente.dart';
import '../model/RapportVente.dart';
import '../model/userModel.dart';
import '../services/ApiService/ApiPharmacie.dart';
import '../services/ApiService/ApiRapportVente.dart';
import '../services/GetStorage/local_storage_service.dart';

class RapportVenteController{


  static Future<RapportVente> getRapportVente() async{
    print(await Apirapportvente().fetchRapport());
    return await Apirapportvente().fetchRapport();

  }


}