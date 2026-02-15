import 'package:intl/intl.dart';
import '../ModelTampo/Lot.dart';
import '../services/ApiService/ApiServiceLotTampo.dart' show LotService;
import '../services/ApiService/venteService.dart';

class VenteController {


  static index () async{

    List<Lot> lots= await LotService().fetchLots();


  }

  static getVente () async{
    List<Lot> lots= await LotService().fetchLots();
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
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    print("erreur date");
    print(formattedDateTime);

    Map<String, dynamic> vente={
      "date_vente" : formattedDateTime,
      "montant_total" :montant_total.toString(),
      "nom_client" : "client",
      "lots_ids":id_lots,
      "quantite_medicament_lot":quantites
    };

    VenteService().createVente(vente);


  }
  }