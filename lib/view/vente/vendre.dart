import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_pharmacie_mobile/view/vente/pannier.dart';
import '../../ModelTampo/Lot.dart';
import '../../component/AppBar.dart';
import '../../component/AppBarTest.dart';
import '../../component/Colors.dart';
import '../../component/Combobox.dart';
import '../../component/vente/BottomAppVente.dart';
import '../../component/vente/Prix.dart';
import '../../services/ApiService/ApiServiceLotTampo.dart';
import '../dashboard/viewDash.dart';
import '../layouts/StructurePage.dart';

class Vendre extends StatefulWidget {
  @override
  State<Vendre> createState() => _VendreState();
}

class _VendreState extends State<Vendre> {
  Lot? selectedLot;
  double quantiteChoisie = 0;
  TextEditingController quantiteS = TextEditingController();
  List<Lot> lots = [];
  int coutPannier = 0;
  TextEditingController rechercheController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getQuantite();
    getLots();
  }

  Future<void> getLots() async {
    setState(() => isLoading = true);
    try {
      final allLots = await LotService().fetchLots();

      final Map<String, Lot> lotsParCle = {};
      for (var lot in allLots) {
        final key = "${lot.medicament.nom}-${lot.medicament.forme.nom}-${lot.medicament.dose.quantite}";
        if (lot.quantite <= 0) continue;
        if (!lotsParCle.containsKey(key)) {
          lotsParCle[key] = lot;
        }
      }

      setState(() {
        lots = lotsParCle.values.toList();
        selectedLot = lots.isNotEmpty ? lots.first : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Erreur lors de la récupération des lots : $e");
    }
  }

  Future<void> getQuantite() async {
    final prefs = await SharedPreferences.getInstance();
    final String? panierString = prefs.getString('panier');
    if (panierString != null) {
      List<Map<String, dynamic>> panier = List<Map<String, dynamic>>.from(jsonDecode(panierString));
      setState(() {
        coutPannier = panier.length;
      });
    }
  }

  Future<void> ajouterAuPanier(Lot lot, int quantite) async {
    if (quantite <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez choisir une quantité valide.")),
      );
      return;
    }

    if (quantite > lot.quantite) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quantité choisie (${quantite}) dépasse le stock disponible (${lot.quantite}).")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? panierString = prefs.getString('panier');
    List<Map<String, dynamic>> panier = panierString != null
        ? List<Map<String, dynamic>>.from(jsonDecode(panierString))
        : [];

    int index = panier.indexWhere((item) => item['idLot'] == lot.idLot);

    if (index >= 0) {
      int nouvelleQuantite = panier[index]['quantite'] + quantite;
      if (nouvelleQuantite > lot.quantite) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Stock insuffisant pour augmenter la quantité.")),
        );
        return;
      }
      panier[index]['quantite'] = nouvelleQuantite;
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
    setState(() => getQuantite());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${lot.medicament.nom} ajouté au panier !")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppbarTest(title: "Espace vente", pageDeRemplacement: ViewDash()).lancer(context),
      body: StructurePage(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        contentBack: InkWell(
          onTap: () {
            if (selectedLot == null) return;

            if (quantiteChoisie <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Veuillez choisir une quantité.")),
              );
              return;
            }

            if (quantiteChoisie > selectedLot!.quantite) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Stock insuffisant (max: ${selectedLot!.quantite})."),
                ),
              );
              return;
            }

            ajouterAuPanier(selectedLot!, quantiteChoisie.toInt());
            setState(() => quantiteChoisie = 0);
          },
          child: Container(
            height: screenWidth * 0.13,
            width: screenWidth * 0.13,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: MyColors.primaryColor,
            ),
            child: Icon(Icons.add, color: Colors.white, size: screenWidth * 0.1),
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: rechercheController,
              decoration: InputDecoration(
                labelText: "Rechercher un produit",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onChanged: (query) {
                final filteredLots = lots.where((lot) =>
                    lot.medicament.nom.toLowerCase().contains(query.toLowerCase())
                ).toList();
                setState(() {
                  selectedLot = filteredLots.isNotEmpty ? filteredLots.first : null;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.01),
            buildComboBox<int>(
              title: "Nom du produit",
              items: lots.map((lot) {
                return DropdownMenuItem<int>(
                  value: lot.idLot,
                  child: Text(
                    "${lot.medicament.nom} ${lot.medicament.forme.nom} ${lot.medicament.dose.quantite} ${lot.medicament.dose.unite}",
                  ),
                );
              }).toList(),
              selectedItem: selectedLot?.idLot,
              placeholder: "Choisissez un produit",
              onChanged: (int? id) {
                setState(() {
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
              Column(
                children: [
                  Slider(
                    value: quantiteChoisie.clamp(0, selectedLot!.quantite.toDouble()),
                    onChanged: (double value) {
                      setState(() {
                        quantiteChoisie = value;
                        quantiteS.text = quantiteChoisie.toString();
                      });
                    },
                    max: selectedLot!.quantite.toDouble(),
                    divisions: selectedLot!.quantite,
                    label: quantiteChoisie.toInt().toString(),
                    activeColor: MyColors.primaryColor,
                  ),
                  TextFormField(
                    controller: quantiteS,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: "",
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    onChanged: (value) {
                      final input = double.tryParse(value) ?? 0;

                      if (input > selectedLot!.quantite) {
                        quantiteS.text = selectedLot!.quantite.toString();
                        quantiteChoisie = selectedLot!.quantite.toDouble();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Quantité maximale autorisée : ${selectedLot!.quantite}"),
                          ),
                        );
                      } else {
                        setState(() => quantiteChoisie = input);
                      }
                    },
                    validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
                  ),
                ],
              ),
              Text("Quantité choisie : ${quantiteChoisie.toInt()}"),
              SizedBox(height: screenHeight * 0.02),
              Prix(intitule: "Prix unitaire", montant: "${selectedLot!.prixUnitaire} FC").lancer(),
              SizedBox(height: screenHeight * 0.02),
              Prix(
                intitule: "Prix total",
                montant: "${selectedLot!.prixUnitaire * quantiteChoisie.toInt()} FC",
              ).lancer(),
            ],
          ],
        ),
      ).lancer(),
      bottomNavigationBar: BottomappVente(
        notifCount: coutPannier,
        onNotif: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Pannier()),
          );
        },
      ).lancer(),
    );
  }
}
