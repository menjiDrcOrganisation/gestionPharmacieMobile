import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/view/vente/vendre.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/Button.dart';
import '../../component/Colors.dart';
import '../../component/Confirmation.dart';
import '../../component/vente/BottomAppVente.dart';
import '../../controller/VenteController.dart';
import '../../utils/navigation.dart';
import '../dashboard/viewDash.dart';
import '../layouts/StructurePage.dart';

class Pannier extends StatefulWidget {
  @override
  State<Pannier> createState() => _PannierState();
}

class _PannierState extends State<Pannier> {
  List<Map<String, dynamic>> panier = [];
  int coutPannier=0;

  @override
  void initState() {
    super.initState();
    loadPanier();
    getQuantite();
  }
  double calculePrixTotal() {
    double total = 0.0;

    for (var item in panier) {
      total += (item['prixUnitaire'] * item['quantite']);
    }

    return total;
  }


  getQuantite() async{

    final prefs = await SharedPreferences.getInstance();
    final String? panierString = prefs.getString('panier');
    if (panierString != null) {
      List<Map<String, dynamic>> panier = List<Map<String, dynamic>>.from(jsonDecode(panierString));
      setState(() {
        coutPannier=panier.length;
      });
    }else{
    }
  }

  /// Charger le panier depuis SharedPreferences
  Future<void> loadPanier() async {
    final prefs = await SharedPreferences.getInstance();
    final String? panierString = prefs.getString('panier');
    if (panierString != null) {
      setState(() {
        panier = List<Map<String, dynamic>>.from(jsonDecode(panierString));
        coutPannier=0;
      });
    }
  }

  /// Supprimer un article
  Future<void> removeItem(int index) async {
    panier.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('panier', jsonEncode(panier));
    getQuantite();
  }

  /// Supprimer tout le panier
  Future<void> clearPanier() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('panier');
    setState(() {
      panier = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Appbar(Title: "Espace Panier",pageDeRemplacement:Vendre()).lancer(context),
      body: StructurePage(
        contentBack: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Button(
              intitule: "Valider",
              colorText: Colors.white,
              colorButton: MyColors.primaryColor,
              onPressed: ()async {

                confirmation(context,"Vous confirmez l'ajout de cette vente?",
                    onOui: () async{
                      await VenteController.create(panier);
                      clearPanier();
                      goToPagePlacement(context,Vendre());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(" Vente effectue avec succes")),
                      );

                    }
                );

              },
            ).lancer(),

            Button(
              intitule: "Annuler",
              colorText: Colors.white,
              colorButton: Colors.red,
              onPressed: (){

              },
            ).lancer()
          ],
        ),
        screenHeight: screenHeight,
        sizeContent: 0.78,
        screenWidth: screenWidth,
        content: panier.isEmpty
            ? Center(child: Text("Le panier est vide"))
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              SizedBox(
                width: screenWidth, // largeur de l’écran
                child: ListView.builder(
                  shrinkWrap: true, // prend juste la place nécessaire
                  physics: const NeverScrollableScrollPhysics(), // pas de scroll vertical car parent scrollable
                  itemCount: panier.length,
                  itemBuilder: (context, index) {
                    final item = panier[index];
                    return  Dismissible(
                      key:  ValueKey("${item['medicament']} ${item['forme']}"),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        removeItem(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${item['medicament']} supprimé")),
                        );
                      },
                      child:  ListTile(
                          title: Text("${item['medicament']} ${item['forme']} ${item['dose']}"),
                          subtitle: Text("Qté: ${item['quantite']}  |  PU: ${item['prixUnitaire']} FC |  PT: ${item['prixUnitaire']*item['quantite']} FC"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeItem(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.green),
                                onPressed: () => print("Mettre à jour $index"),
                              ),
                            ],
                          ),
                        ),
              
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // espace à l'intérieur
                    decoration: BoxDecoration(
                      color: Colors.green.shade100, // couleur de fond
                      borderRadius: BorderRadius.circular(12), // bordure arrondie
                      border: Border.all(color: Colors.green, width: 2), // bordure verte
                    ),
                    child: Text(
                      "Montant total : ${calculePrixTotal().toStringAsFixed(2)} FC",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // couleur du texte
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
        ,
      ).lancer(),
      bottomNavigationBar: BottomappVente(
        notifCount: coutPannier,

          onAccueil: (){
            Navigator.pop(context);

          },
          onNotif: (){

            setState(() {

            });
          }

      ).lancer(),
    );
  }
}
