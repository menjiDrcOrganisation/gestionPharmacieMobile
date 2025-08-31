import '../model/Medicament.dart';

import '../services/ApiService/ApiServiceMedicament.dart';


class MedicamentController {
  final MedicamentService service = MedicamentService();

  // Récupérer depuis API et sauvegarder local
  Future<List<Medicament>> loadMedicaments() async {
    try {
      return await service.fetchMedicaments();
    } catch (e) {
      // si l'API échoue, récupérer depuis local
      return await service.getMedicamentsLocal();
    }
  }
}
