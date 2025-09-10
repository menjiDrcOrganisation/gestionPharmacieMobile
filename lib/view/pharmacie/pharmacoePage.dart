import 'package:flutter/material.dart';
import '../../ModelTampo/Pharmacie.dart';
import '../../component/AppBar.dart';
import '../../component/Combobox.dart';
import '../../component/Confirmation.dart';
import '../../controller/PharmacieController.dart';
import '../../services/ApiService/ApiPharmacie.dart';
import '../../utils/navigation.dart';
import '../principal/portail.dart';
import 'CreationCompteStep2.dart';

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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const CreationComptePage(),
    );
  }
}

class CreationComptePage extends StatefulWidget {
  const CreationComptePage({super.key});

  @override
  State<CreationComptePage> createState() => _CreationComptePageState();
}

class _CreationComptePageState extends State<CreationComptePage> {
  List<String> villes = ["Kinshasa", "Lubumbashi"];
  String? selectedVille = "Kinshasa";

  // Controllers pour récupérer les valeurs des TextField
  final TextEditingController nomController = TextEditingController();

  final TextEditingController quartierController = TextEditingController();
  final TextEditingController rueController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController indiceController = TextEditingController();

  @override
  void dispose() {
    // Toujours libérer les controllers
    nomController.dispose();
    quartierController.dispose();
    rueController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  Appbar(Title: "Opharma").lancer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 20),

              // Titre
              const Text(
                "Création de compte",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Icône profil circulaire
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, size: 50, color: Colors.grey),
              ),

              const SizedBox(height: 15),
              // Stepper
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("1 sur 2", style: TextStyle(fontSize: 14)),
                      ],
                    ),
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

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildTextField("Nom de la pharmacie", controller: nomController),
                    const SizedBox(height: 15),
                    Row(
                      children: [

                        Expanded(child:
                        buildComboBox<String>(
                          items: villes.map((ville) {
                            return DropdownMenuItem<String>(
                              value: ville, // identifiant unique
                              child: Text(
                                  "${ville} "
                              ),
                            );
                          }).toList(),
                          selectedItem: selectedVille, // garder uniquement l'id comme valeur
                          placeholder: "Choisissez un produit",
                          onChanged: (String? pharamacie) {
                            setState(() {
                              selectedVille=pharamacie;
                              // retrouver le lot complet via son id
                            });
                          },
                        )
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _buildTextField("Quartier", controller: quartierController)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildTextField("Rue", controller: rueController),
                    const SizedBox(height: 15),
                    _buildTextField("Téléphone", controller: telephoneController, keyboardType: TextInputType.phone),
                    const SizedBox(height: 15),
                    _buildTextField("Indice de la pharmacie", controller: indiceController, keyboardType: TextInputType.number),
                    const SizedBox(height: 30),

                    // Bouton Suivant
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          confirmation(context,"Vous confirmez l'ajout de cette pharmacie?",
                            onOui: () async{
                              final nom = nomController.text;
                              final ville = selectedVille;
                              final quartier = quartierController.text;
                              final rue = rueController.text;
                              final tel = telephoneController.text;


                              try {
                                Pharmacie p=await ControllerPharmacie.createPhramacie(nom, ville, quartier,
                                    rue, tel,"4");

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Pharmacie  ${p.nom} creer avec succes avec succes")),
                                );
                                goToPagePlacement(context,Portail());
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur lors de la création du pharmacie")),
                                );
                                print('Erreur lors de la création du pharmacie : $e');
                                // Afficher un snackbar ou dialogue d'erreur
                              }

                            }

                          );
                          // Récupérer les valeurs


                          // Ici tu peux les envoyer à la prochaine page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Suivant",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode réutilisable pour un champ texte
  Widget _buildTextField(String label,
      {TextInputType keyboardType = TextInputType.text, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
