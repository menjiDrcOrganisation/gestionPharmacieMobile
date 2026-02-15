import '../model/RapportVente.dart';
import '../services/ApiService/ApiRapportVente.dart';

class RapportVenteController{
  static Future<RapportVente> getRapportVente() async{
    return await Apirapportvente().fetchRapport();
  }
}