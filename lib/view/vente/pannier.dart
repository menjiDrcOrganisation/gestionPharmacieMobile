import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_pharmacie_mobile/view/vente/vendre.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/Button.dart';
import '../../component/Colors.dart';
import '../../component/vente/BottomAppVente.dart';
import '../../controller/VenteController.dart';
import '../../utils/navigation.dart';
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
    setState(() {});
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
      appBar: Appbar(Title: "Espace Panier").lancer(),
      body: StructurePage(
        contentBack: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Button(
              intitule: "Valider",
              colorText: Colors.white,
              colorButton: MyColors.primaryColor,
              onPressed: ()async {
                await VenteController.create(panier);
                clearPanier();
                goToPagePlacement(context,Vendre());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(" Vente effectue avec succes")),
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
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Produit")),

              DataColumn(label: Text("Quantité")),
              DataColumn(label: Text("Prix Unitaire")),
              DataColumn(label: Text("Prix Total")),
              DataColumn(label: Text("Action")),
            ],
            rows: List.generate(
              panier.length,
                  (index) {
                final item = panier[index];
                return DataRow(cells: [
                  DataCell(Text(item['medicament'] + item['forme']+item['dose'])),

                  DataCell(Text(item['quantite'].toString())),
                  DataCell(Text("${item['prixUnitaire']} FC")),
                  DataCell(Text(
                      "${item['prixUnitaire'] * item['quantite']} FC")),
                  DataCell(IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => removeItem(index),
                  )),
                ]);
              },
            ),
          ),
        ),
      ).lancer(),
      bottomNavigationBar: BottomappVente(
        notifCount: coutPannier,

          onAccueil: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Vendre(), // ta page cible
              ),
            );

          },

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
