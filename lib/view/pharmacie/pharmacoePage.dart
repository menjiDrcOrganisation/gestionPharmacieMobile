import 'package:flutter/material.dart';
import '../../ModelTampo/Pharmacie.dart';
import '../../component/AppBar.dart';
import '../../component/AppBarTest.dart';
import '../../component/Combobox.dart';
import '../../component/Confirmation.dart';
import '../../controller/PharmacieController.dart';
import '../../utils/navigation.dart';
import '../principal/portail.dart';

class CreationComptePage extends StatefulWidget {
  const CreationComptePage({super.key});

  @override
  State<CreationComptePage> createState() => _CreationComptePageState();
}

class _CreationComptePageState extends State<CreationComptePage> {
  final _formKey = GlobalKey<FormState>();

  List<String> villes = ["Kinshasa", "Lubumbashi"];
  String? selectedVille = "Kinshasa";

  // Controllers
  final TextEditingController nomController = TextEditingController();
  final TextEditingController quartierController = TextEditingController();
  final TextEditingController rueController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController indiceController = TextEditingController();

  bool isLoading = false; // loader

  @override
  void dispose() {
    nomController.dispose();
    quartierController.dispose();
    rueController.dispose();
    telephoneController.dispose();
    indiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTest(title: "Creation Pharmacie",pageDeRemplacement: Portail()).lancer(context),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Création de compte",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[200],
                        child:
                        const Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                      const SizedBox(height: 15),
                      // Stepper
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            const Text("1 sur 2", style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: 0.5,
                              backgroundColor: Colors.grey[300],
                              color: Colors.green,
                              minHeight: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Nom pharmacie
                      _buildTextField(
                        "Nom de la pharmacie",
                        controller: nomController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Le nom est obligatoire";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      // Ville et quartier
                      Row(
                        children: [
                          Expanded(
                            child: buildComboBox<String>(
                              items: villes.map((ville) {
                                return DropdownMenuItem<String>(
                                  value: ville,
                                  child: Text(ville),
                                );
                              }).toList(),
                              selectedItem: selectedVille,
                              placeholder: "Choisissez une ville",
                              onChanged: (String? ville) {
                                setState(() {
                                  selectedVille = ville;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              "Quartier",
                              controller: quartierController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Quartier obligatoire";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Rue
                      _buildTextField(
                        "Rue",
                        controller: rueController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Rue obligatoire";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      // Téléphone
                      _buildTextField(
                        "Téléphone (82xxxxxxx)",
                        controller: telephoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Téléphone obligatoire";
                          }
                          // 9 chiffres RDC commençant par 8 ou 9
                          if (!RegExp(r'^[89][0-9]{8}$').hasMatch(value)) {
                            return "Numéro invalide (format 82xxxxxxx ou 91xxxxxxx)";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      // Indice
                      _buildTextField(
                        "Indice de la pharmacie",
                        controller: indiceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Indice obligatoire";
                          }
                          final number = double.tryParse(value);
                          if (number == null) {
                            return "Indice doit être un nombre (entier ou décimal)";
                          }
                          if (number <= 0) {
                            return "Indice doit être supérieur à 0";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      // Bouton Suivant
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            if (_formKey.currentState!.validate()) {
                              confirmation(
                                context,
                                "Vous confirmez l'ajout de cette pharmacie?",
                                onOui: () async {
                                  setState(() => isLoading = true);

                                  try {
                                    Pharmacie p = await ControllerPharmacie
                                        .createPhramacie(
                                      nomController.text,
                                      selectedVille,
                                      quartierController.text,
                                      rueController.text,
                                      telephoneController.text,
                                      indiceController.text,
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Pharmacie ${p.nom} créée avec succès"),
                                      ),
                                    );
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    goToPagePlacement(context, Portail());
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Erreur lors de la création de la pharmacie"),
                                      ),
                                    );
                                    print("Erreur: $e");
                                  } finally {
                                    if (mounted)
                                      setState(() => isLoading = false);
                                  }
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text(
                            "Suivant",
                            style: TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TextFormField avec validator
  Widget _buildTextField(
      String label, {
        TextInputType keyboardType = TextInputType.text,
        TextEditingController? controller,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
