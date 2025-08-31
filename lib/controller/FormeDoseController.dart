import '../services/ApiService/ApiServiceFormeDose.dart';


class FormeDoseController {
  final FormeDoseService  _service = FormeDoseService();

  // Charger depuis API et sauvegarder localement
  Future<void> chargerFormeDose() async {
    await _service.fetchAndSaveFormeDose();
  }

  // Récupérer depuis local
  Future<Map<String, dynamic>?> recupererFormeDoseLocal() async {
    return await _service.getLocalFormeDose();
  }

  // Supprimer
  Future<void> supprimerFormeDoseLocal() async {
    await _service.clearFormeDose();
  }
}
