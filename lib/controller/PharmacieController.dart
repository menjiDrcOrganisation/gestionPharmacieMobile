

import '../ModelTampo/Pharmacie.dart';
import '../model/userModel.dart';
import '../services/ApiService/ApiPharmacie.dart';
import '../services/GetStorage/local_storage_service.dart';

class ControllerPharmacie{

  static Future<Pharmacie> createPhramacie(nom,ville,quartier,rue,tel) async{


    RoleInfo? user = await LocalStorageService().getRoleInfo();

    int? idUser=user!.id;
    print("id genrant $idUser");
    Pharmacie pharmacie = Pharmacie(
      id: 0,
      nom: nom,
      adresse: '$rue, $quartier, $ville',
      telephone: tel,
      indice: 2,
      idGerant: idUser,
      statut: 'valide',
      createdAt: null,
      updatedAt: null,
    );
   return PharmacieService().createPharmacie(pharmacie);

  }

}