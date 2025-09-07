import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_pharmacie_mobile/view/vente/pannier.dart';
import '../../ModelTampo/Lot.dart';
import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/Colors.dart';
import '../../component/Combobox.dart';
import '../../component/vente/BottomAppVente.dart';
import '../../component/vente/Prix.dart';
import '../../services/ApiService/ApiServiceLotTampo.dart';
import '../../services/GetStorage/LotStorage.dart';
import '../layouts/StructurePage.dart';

class Vendre extends StatefulWidget {
  @override
  State<Vendre> createState() => _VendreState();
}

class _VendreState extends State<Vendre> {
  Lot? selectedLot;
  double quantiteChoisie = 0;
  int coutPannier = 0;
  TextEditingController rechercheController = TextEditingController();

  /// Future pour récupérer les lots
  Future<List<Lot>> getLots() async {
    return await LotService().fetchLots();
  }

  /// Ajouter le lot au panier avec SharedPreferences
  Future<void> ajouterAuPanier(Lot lot, int quantite) async {
    if (quantite <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    final String? panierString = prefs.getString('panier');
    List<Map<String, dynamic>> panier = panierString != null
        ? List<Map<String, dynamic>>.from(jsonDecode(panierString))
        : [];

    int index = panier.indexWhere((item) => item['idLot'] == lot.idLot);
    if (index >= 0) {
      panier[index]['quantite'] += quantite;
    } else {
      panier.add({
        'idLot': lot.idLot,
        'medicament': lot.medicament.nom,
        'forme': lot.medicament.forme.nom,
        'dose': "${lot.medicament.dose.quantite} ${lot.medicament.dose.unite}",
        'quantite': quantite,
        'prixUnitaire': lot.prixUnitaire,
      });
    }

    await prefs.setString('panier', jsonEncode(panier));
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${lot.medicament.nom} ajouté au panier !")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Appbar(Title: "Espace vente").lancer(),
      body: FutureBuilder<List<Lot>>(
        future: getLots(),
        builder: (context, snapshot) {


          if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement des médicaments"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "cette pharmacie n'a pas des médicaments pour l'instant",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          List<Lot> lots = snapshot.data!;
          selectedLot ??= lots.first;

          return StructurePage(
            contentBack: InkWell(
              onTap: () {
                if (selectedLot != null && quantiteChoisie > 0) {
                  ajouterAuPanier(selectedLot!, quantiteChoisie.toInt());
                }
              },
              child: Container(
                height: screenWidth * 0.13,
                width: screenWidth * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  color: MyColors.primaryColor,
                ),
                child: Icon(Icons.add,
                    color: Colors.white, size: screenWidth * 0.1),
              ),
            ),
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: rechercheController,
                  decoration: InputDecoration(
                    labelText: "Rechercher un produit",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      lots = snapshot.data!
                          .where((lot) => lot.medicament.nom
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                          .toList();
                      selectedLot =
                      lots.isNotEmpty ? lots.first : null;
                      quantiteChoisie = 0;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.01),
                buildComboBox<int>(
                  title: "Nom du produit",
                  items: lots.map((lot) {
                    return DropdownMenuItem<int>(
                      value: lot.idLot, // identifiant unique
                      child: Text(
                        "${lot.medicament.nom} "
                            "${lot.medicament.forme.nom} "
                            "${lot.medicament.dose.quantite} "
                            "${lot.medicament.dose.unite}",
                      ),
                    );
                  }).toList(),
                  selectedItem: selectedLot?.idLot, // garder uniquement l'id comme valeur
                  placeholder: "Choisissez un produit",
                  onChanged: (int? id) {
                    setState(() {
                      // retrouver le lot complet via son id
                      selectedLot = lots.firstWhere((lot) => lot.idLot == id);
                      quantiteChoisie = 0;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                if (selectedLot != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Quantité"),
                      Text("0 - ${selectedLot!.quantite}"),
                    ],
                  ),
                  Slider(
                    value: quantiteChoisie,
                    onChanged: (double value) {
                      setState(() {
                        quantiteChoisie = value;
                      });
                    },
                    max: selectedLot!.quantite.toDouble(),
                    divisions: selectedLot!.quantite,
                    label: quantiteChoisie.toInt().toString(),
                    activeColor: MyColors.primaryColor,
                  ),
                  Text("Quantité choisie : ${quantiteChoisie.toInt()}"),
                  SizedBox(height: screenHeight * 0.02),
                  Prix(
                    intitule: "Prix unitaire",
                    montant: "${selectedLot!.prixUnitaire} FC",
                  ).lancer(),
                  SizedBox(height: screenHeight * 0.02),
                  Prix(
                    intitule: "Prix total",
                    montant:
                    "${selectedLot!.prixUnitaire * quantiteChoisie.toInt()} FC",
                  ).lancer(),
                ],
              ],
            ),
          ).lancer();
        },
      ),
      bottomNavigationBar: BottomappVente(
        onAccueil: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Vendre()),
          );
        },
        notifCount: coutPannier,
        onNotif: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Pannier()),
          );
        },
      ).lancer(),
    );
  }
}
