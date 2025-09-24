import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestion_pharmacie_mobile/view/vente/pannier.dart';
import '../../ModelTampo/Lot.dart';
import '../../component/AppBar.dart';
import '../../component/AppBarTest.dart';
import '../../component/Colors.dart';
import '../../component/Combobox.dart';
import '../../component/rapport/VenteBlock.dart';
import '../../component/vente/BottomAppVente.dart';
import '../../component/vente/Prix.dart';
import '../../services/ApiService/ApiServiceLotTampo.dart';
import '../dashboard/viewDash.dart';
import '../layouts/StructurePage.dart';

class ViewRapport extends StatefulWidget {
  @override
  State<ViewRapport> createState() => _ViewRapportState();
}

class _ViewRapportState extends State<ViewRapport> {

  @override
  void initState() {
    super.initState();

  }
  
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppbarTest(title: "Rapport",pageDeRemplacement: ViewDash()).lancer(context),
      body: Column(
      mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 100,
                width: 40,
                color: Colors.red,
                child: Center(child: Text("Prix"),),

              ),
              Container(
                height: 100,
                width: 40,
                color: Colors.blue,
                child: Center(child: Text("Quantite"),),
              )
            ],
          ),
          Row(
            children: [
              VenteBlock().lancer()
            ],
          )
        ],
      )
    );
  }
}
