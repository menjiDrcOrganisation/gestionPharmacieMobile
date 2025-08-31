import 'package:flutter/material.dart';

import '../../controller/FormeDoseController.dart';
import '../../controller/LotController.dart';
import '../../controller/MedocController.dart';
import '../../model/Medicament.dart';
import '../layouts/AppBarCustomer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connexion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      home: const AddProduitPage(),
    );
  }
}



class AddProduitPage extends StatefulWidget {
  const AddProduitPage({super.key});

  @override
  State<AddProduitPage> createState() => _AddProduitPageState();
}

class _AddProduitPageState extends State<AddProduitPage> {
  String? selectedForme;
  String? selectedDosage;
  String? selectedMedicament; // null par défaut


  double quantity = 0;
  DateTime? expirationDate;



  final TextEditingController nomProduitController = TextEditingController();
  final TextEditingController prixUnitaireController =
  TextEditingController(text: "1500fc");
  final TextEditingController prixAchatController =
  TextEditingController(text: "1500fc");
  final MedicamentController _medicamentController = MedicamentController();
  final FormeDoseController controller = FormeDoseController();
  final LotController lotController = LotController();
  List<Medicament>? medicaments; // ← Variable pour stocker les médicaments



  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadMedicaments();
  }
  Future<void> _loadMedicaments() async {
    final meds = await _medicamentController.loadMedicaments(); // récupérer depuis API ou local
    setState(() {
      medicaments = meds;

      // valeur par défaut
      if (medicaments!.isNotEmpty) {
        selectedMedicament = medicaments![0].nom;
      }
    });
  }






  Future<void> _loadData() async {
    // Charger depuis API et stocker localement
    await controller.chargerFormeDose();

    // Lire depuis local
    var localData = await controller.recupererFormeDoseLocal();

    setState(() {
      data = localData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Gestion des Lots", showBack: true),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Barre de recherche
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Recherchez votre pharmacie",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.filter_list, color: Colors.green),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Nom du produit + calendrier
                    SingleChildScrollView(
                      child: Row(
                        children: [
                          // Dropdown pour le médicament
                          Expanded(
                            child: SizedBox(
                              width: 200,
                              child: DropdownButtonFormField<String>(
                                value: selectedMedicament,
                                items: medicaments != null
                                    ? medicaments!
                                    .map((m) => m.nom) // on prend le nom depuis le modèle
                                    .toSet() // éviter les doublons
                                    .map((nom) => DropdownMenuItem(
                                  value: nom,
                                  child: Text(nom),
                                ))
                                    .toList()
                                    : [], // liste vide si medicaments n'est pas encore chargé
                                onChanged: (val) => setState(() => selectedMedicament = val),
                                decoration: _inputDecoration("Nom du produit"),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // IconButton pour choisir la date d'expiration
                          IconButton(
                            icon: const Icon(Icons.calendar_month, color: Colors.green),
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: expirationDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() {
                                  expirationDate = picked;
                                });
                              }
                            },
                          ),

                          // Afficher la date sélectionnée
                          /*if (expirationDate != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "${expirationDate!.day}/${expirationDate!.month}/${expirationDate!.year}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),*/
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /* data == null
                        ? Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Dropdown Forme
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              value: selectedForme,
                              items: (data!["forme"] as List)
                                  .map<String>((e) => e["nom"] as String)
                                  .toSet()
                                  .map((forme) => DropdownMenuItem(
                                value: forme,
                                child: Text(forme),
                              ))
                                  .toList(),
                              onChanged: (val) => setState(() => selectedForme = val),
                              decoration: _inputDecoration("Choisir la forme"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Dropdown Dosage
                          SizedBox(
                            width: 150,
                            child: DropdownButtonFormField<String>(
                              value: selectedDosage,
                              items: (data!["dose"] as List)
                                  .map<String>((e) => "${e["quantite"]} ${e["unite"]}")
                                  .toSet()
                                  .map((dosage) => DropdownMenuItem(
                                value: dosage,
                                child: Text(dosage),
                              ))
                                  .toList(),
                              onChanged: (val) => setState(() => selectedDosage = val),
                              decoration: _inputDecoration("Dosage"),
                            ),
                          ),
                        ],
                      ),
                    ),*/




                    const SizedBox(height: 20),

                    // Quantité slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Quantité"),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: quantity,
                                min: 0,
                                max: 1000,
                                divisions: 1000,
                                label: quantity.round().toString(),
                                activeColor: Colors.green,
                                onChanged: (val) {
                                  setState(() => quantity = val);
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${quantity.round()}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )

                      ],
                    ),
                    const SizedBox(height: 20),


                    // Prix d'achats
                    TextField(
                      controller: prixAchatController,

                      decoration: _inputDecoration("Prix d’achats").copyWith(
                        suffixIcon: const Icon(Icons.check, color: Colors.green),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Prix unitaire
                    TextField(
                      controller: prixUnitaireController,
                      readOnly: true,
                      decoration: _inputDecoration("Prix Unitaire").copyWith(
                        suffixIcon: const Icon(Icons.check, color: Colors.green),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Bouton Ajouter

                  ],
                ),
              ),

            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  if (selectedMedicament == null || expirationDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Veuillez remplir tous les champs")),
                    );
                    return;
                  }

                  // Exemple : trouver l’ID du médicament à partir de son nom
                  final medicament = medicaments!.firstWhere(
                        (m) => m.nom == selectedMedicament,
                  );
                  print("quantite: ${expirationDate!.toIso8601String().split("T")[0]}");
                  final lot = await lotController.enregistrerLot(
                    idMedicament: medicament.id,



                    quantite: quantity.round(),
                    dateExpiration: expirationDate!.toIso8601String().split("T")[0],
                    prixAchat: int.parse(prixAchatController.text),
                    idPharmacie: 1, // ⚠️ à remplacer par l’ID réel (depuis storage)
                  );

                  if (lot != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lot ajouté avec succès ✅")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Erreur lors de l'ajout du lot ❌")),
                    );
                  }
                }
                ,
                child: const Text(
                  "Ajouter",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.green),
      ),
    );
  }
}
