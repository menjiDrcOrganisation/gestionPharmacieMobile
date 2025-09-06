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
  late List<Lot> lots;
  List<Lot> filteredLots = [];
  TextEditingController rechercheController = TextEditingController();
  Lot? selectedLot;
  double quantiteChoisie = 0;

  @override
  void initState() {
    getLots();
    super.initState();

  }

  Future<void> getLots() async {

    lots = await LotService().fetchLots();

    filteredLots = lots;
    for (int i = 0; i < filteredLots.length; i++) {
      print("hello");
      print(filteredLots[i].medicament.nom+filteredLots[i].medicament.forme.nom
      +filteredLots[i].medicament.dose.quantite);
    }
    
    print(filteredLots);
    selectedLot = filteredLots.isNotEmpty ? filteredLots[0] : null;
    setState(() {});
  }

  void filterLots(String query) {
    setState(() {
      filteredLots = lots
          .where((lot) => lot.medicament.nom.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (!filteredLots.contains(selectedLot)) {
        selectedLot = filteredLots.isNotEmpty ? filteredLots[0] : null;
        quantiteChoisie = 0;
      }
    });
  }

  /// Ajouter le lot au panier avec SharedPreferences
  Future<void> ajouterAuPanier(Lot lot, int quantite) async {
    if (quantite <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    final String? panierString = prefs.getString('panier');
    List<Map<String, dynamic>> panier = panierString != null
        ? List<Map<String, dynamic>>.from(jsonDecode(panierString))
        : [];

    // Vérifier si le lot existe déjà dans le panier
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

    // Notification rapide
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
      body: selectedLot == null
          ? const Center(child: CircularProgressIndicator())
          : StructurePage(
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
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                      color: MyColors.primaryColor, width: 2),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              onChanged: filterLots,
            ),
            SizedBox(height: screenHeight * 0.01),
            buildComboBox<Lot>(
              title: "Nom du produit",
              items: filteredLots.map((lot) {
                return DropdownMenuItem<Lot>(
                  value: lot,
                  child: Text(
                    "${lot.medicament.nom} "
                        "${lot.medicament.forme.nom} "
                        "${lot.medicament.dose.quantite} "
                        "${lot.medicament.dose.unite}",
                  ),
                );
              }).toList(),
              selectedItem: selectedLot,
              placeholder: "Choisissez un produit",
              onChanged: (Lot? value) {
                setState(() {
                  selectedLot = value;
                  quantiteChoisie = 0;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  min: 0,
                  divisions: selectedLot!.quantite,
                  label: quantiteChoisie.toInt().toString(),
                  activeColor: MyColors.primaryColor,
                  thumbColor: MyColors.primaryColor,
                ),
                Text("Quantité choisie : ${quantiteChoisie.toInt()}"),
              ],
            ),
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
        ),
      ).lancer(),
      bottomNavigationBar: BottomappVente(
        onNotif: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Pannier(), // ta page cible
            ),
          );
        }

      ).lancer(),
    );
  }
}
