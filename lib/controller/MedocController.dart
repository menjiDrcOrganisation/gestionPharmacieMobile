import '../model/Medicament.dart';
import '../services/ApiService/ApiServiceMedicament.dart';


class MedicamentController {
  final MedicamentService service = MedicamentService();

  Future<List<Medicament>> loadMedicaments() async {
    try {
      final medoc=await service.fetchMedicaments();
      return medoc ;
    } catch (e) {
      throw Exception("Impossible de récupérer les médicaments");
    }
  }
}
