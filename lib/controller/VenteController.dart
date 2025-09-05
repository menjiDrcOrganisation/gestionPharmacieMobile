


import '../ModelTampo/Lot.dart';
import '../services/ApiService/ApiServiceLotTampo.dart' show LotService;

class VenteController {


  static index () async{
    print("ddddd");
    List<Lot> lots= await LotService().fetchLots();
    print(lots[0].toJson());

  }

}