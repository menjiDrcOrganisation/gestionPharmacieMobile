import 'package:flutter/material.dart';
import '../../controller/FormeDoseController.dart';
import '../../controller/LotController.dart';
import '../../controller/MedocController.dart';
import '../../model/Medicament.dart';
import '../../services/GetStorage/Pharmacie.dart';
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
  String? selectedMedicament;
  double quantity = 0;
  DateTime? expirationDate;
  bool isLoading = false;
  bool isSubmitting = false;

  final TextEditingController nomProduitController = TextEditingController();
  final TextEditingController prixUnitaireController = TextEditingController(text: "0");
  final TextEditingController prixAchatController = TextEditingController(text: "0");
  final TextEditingController searchController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(text: "0");

  final MedicamentController _medicamentController = MedicamentController();
  final FormeDoseController controller = FormeDoseController();
  final LotController lotController = LotController();

  List<Medicament>? medicaments;
  List<Medicament> filteredMedicaments = [];
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();

    _loadMedicaments();

    // Écouter les changements de prix d'achat pour calculer automatiquement le prix unitaire
    prixAchatController.addListener(_calculatePrixUnitaire);
    searchController.addListener(_filterMedicaments);
    quantityController.addListener(_updateQuantityFromField);
  }

  @override
  void dispose() {
    prixAchatController.removeListener(_calculatePrixUnitaire);
    searchController.removeListener(_filterMedicaments);
    quantityController.removeListener(_updateQuantityFromField);
    super.dispose();
  }

  void _calculatePrixUnitaire()async {
    if (prixAchatController.text.isNotEmpty) {
      try {
        final prixAchat = double.parse(prixAchatController.text);
        String indiceStr = await PharmacieStorage.getindice();
        double indice = double.parse(indiceStr);
        print("indice");
        print(indice);// convertir en nombre
        int prixFinal = (prixAchat * indice).round();
        // Calculer le prix unitaire avec une marge de 20%
        final prixUnitaire =prixFinal;
        prixUnitaireController.text = prixUnitaire.toString();
      } catch (e) {
        // Ignorer les erreurs de parsing
      }
    }
  }

  void _updateQuantityFromField() {
    if (quantityController.text.isNotEmpty) {
      try {
        final newQuantity = double.tryParse(quantityController.text) ?? 0;
        if (newQuantity >= 0 && newQuantity <= 1000) {
          setState(() => quantity = newQuantity);
        }
      } catch (e) {
        // Ignorer les erreurs de parsing
      }
    }
  }

  void _updateQuantityFromSlider(double value) {
    setState(() {
      quantity = value;
      quantityController.text = value.round().toString();
    });
  }

  void _filterMedicaments() {
    if (medicaments == null) return;

    final query = searchController.text.toLowerCase();
    setState(() {
      filteredMedicaments = medicaments!
          .where((med) => med.nom.toLowerCase().contains(query))
          .toList();

      // Mettre à jour la sélection si le médicament sélectionné ne fait plus partie des résultats filtrés
      if (selectedMedicament != null &&
          !filteredMedicaments.any((med) => med.id.toString() == selectedMedicament)) {
        selectedMedicament = null;
      }
    });
  }

  Future<void> _loadMedicaments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final meds = await _medicamentController.loadMedicaments();
      setState(() {
        medicaments = meds;
        filteredMedicaments = meds;
        if (meds.isNotEmpty && selectedMedicament == null) {
          selectedMedicament = meds.first.id.toString();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des médicaments: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (selectedMedicament == null || expirationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner un médicament et une date d'expiration")),
      );
      return;
    }

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La quantité doit être supérieure à 0")),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final medicament = medicaments!.firstWhere(
            (m) => m.id.toString() == selectedMedicament,
      );

      String id_pharmacie= await PharmacieStorage.getPharma();

      final lot = await lotController.enregistrerLot(
        idMedicament: medicament.id,
        quantite: quantity.round(),
        dateExpiration: expirationDate!.toIso8601String().split("T")[0],
        prixAchat: int.parse(prixAchatController.text),
        idPharmacie: int.parse(id_pharmacie),
      );

      if (lot != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lot ajouté avec succès")),
        );
        // Réinitialiser le formulaire après succès
        _resetForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'ajout du lot ❌")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _resetForm() {
    setState(() {
      selectedMedicament = medicaments?.isNotEmpty == true ? medicaments!.first.id.toString() : null;
      quantity = 0;
      quantityController.text = "0";
      expirationDate = null;
      prixAchatController.text = "0";
      prixUnitaireController.text = "0"; // 1500 * 1.2
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Ajouter un Lot"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Barre de recherche des médicaments
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: "Rechercher un médicament...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.green),
                          onPressed: () {
                            // Action de filtrage supplémentaire
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Sélection du médicament avec indicateur de chargement
                  if (isLoading)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (medicaments == null || medicaments!.isEmpty)
                    const Text("Aucun médicament disponible")
                  else
                    DropdownButtonFormField(
                      value: selectedMedicament,
                      items: filteredMedicaments
                          .map((m) => DropdownMenuItem(
                        value: m.id.toString(),
                        child: Text(m.nom),
                      ))
                          .toList(),
                      onChanged: (val) => setState(() => selectedMedicament = val),
                      decoration: _inputDecoration("Médicament"),
                      isExpanded: true,
                    ),

                  const SizedBox(height: 20),

                  // Date d'expiration
                  Row(
                    children: [
                      Expanded(
                        child: InputDecorator(
                          decoration: _inputDecoration("Date d'expiration"),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                expirationDate != null
                                    ? "${expirationDate!.day}/${expirationDate!.month}/${expirationDate!.year}"
                                    : "Sélectionner une date",
                                style: TextStyle(
                                  color: expirationDate != null
                                      ? Colors.black
                                      : Colors.grey[400],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_month, color: Colors.green),
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: expirationDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Colors.green,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      expirationDate = picked;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Quantité avec slider et champ numérique
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Quantité",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: quantity,
                              min: 0,
                              max: 1000,
                              divisions: 100,
                              label: quantity.round().toString(),
                              activeColor: Colors.green,
                              onChanged: _updateQuantityFromSlider,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 80,
                            child: TextField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              onChanged: (value) {
                                final newQuantity = double.tryParse(value) ?? 0;
                                if (newQuantity >= 0 && newQuantity <= 1000) {
                                  setState(() => quantity = newQuantity);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Quantité sélectionnée: ${quantity.round()}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Prix d'achat
                  TextField(
                    controller: prixAchatController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("Prix d'achat (FC)").copyWith(
                      suffixIcon: const Icon(Icons.money, color: Colors.green),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Prix unitaire (calculé automatiquement)
                  TextField(
                    controller: prixUnitaireController,
                    readOnly: true,
                    decoration: _inputDecoration("Prix unitaire (FC)").copyWith(
                      suffixIcon: const Icon(Icons.calculate, color: Colors.green),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Bouton d'ajout avec état de chargement
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isSubmitting ? null : _submitForm,
                child: isSubmitting
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Ajout en cours..."),
                  ],
                )
                    : const Text(
                  "Ajouter le Lot",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}