
import 'package:intl/intl.dart';
import '../ModelTampo/Lot.dart';
import '../ModelTampo/Vente.dart';
import '../services/ApiService/ApiServiceLotTampo.dart' show LotService;
import '../services/ApiService/venteService.dart';

class VenteController {


  static index () async{
    print("ddddd");
    List<Lot> lots= await LotService().fetchLots();
    print(lots[0].toJson());

  }

  static getVente () async{
    print("ddddd");
    List<Lot> lots= await LotService().fetchLots();
    print(lots[0].toJson());

  }

  static create (List<Map<String, dynamic>> ligneVente) async{

    List <int> id_lots =[];
    List <int> quantites =[];
    int montant_total=0;

    ligneVente.forEach((element) {
      id_lots.add(element["idLot"])   ;
      quantites.add(element["quantite"])   ; // chaque ligne
      montant_total += int.parse(element["quantite"].toString()) *
          int.parse(element["prixUnitaire"].toString());
    });
    // Récupérer la date actuelle
    DateTime now = DateTime.now();

    // Formater en "yyyy-MM-dd"
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    print(formattedDate);
    Map<String, dynamic> vente={
      "date_vente" : formattedDate,
      "montant_total" :montant_total.toString(),
      "nom_client" : "client",
      "lots_ids":id_lots,
      "quantite_medicament_lot":quantites
    };
    print(vente);
    VenteService().createVente(vente);


  }
  }