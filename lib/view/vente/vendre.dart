import 'package:flutter/material.dart';

import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/Colors.dart';
import '../../component/Combobox.dart';
import '../../component/LookPharma.dart';
import '../../component/Option.dart';
import '../../component/SeashBar.dart';
import '../../component/vente/Prix.dart';

class Vendre extends StatefulWidget {
  @override
  State<Vendre> createState() => _VendreState();
}

class _VendreState extends State<Vendre> {
  String selected = "Option 1";

  @override
  Widget build(BuildContext context) {
    // Récupérer les dimensions de l'écran
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: Appbar(Title: "Espace vente").lancer(),
      body: Stack(
        children: [
          // Barre supérieure et inférieure
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: screenHeight * 0.05,
                width: double.infinity,
                color: ColorsApp.primaryColor,
              ),
              Container(
                width: double.infinity,
                height: screenHeight * 0.020,
                color: ColorsApp.primaryColor,
              ),
            ],
          ),
          Center(
            child: SizedBox(
              height: screenHeight * 0.8,
              width: screenWidth * 0.9,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.03),
                          buildComboBox(
                            title: "Nom du produit",
                            items: ["Option 1", "Option 2", "Option 3"],
                            selectedItem: selected,
                            onChanged: (value) {
                              setState(() {
                                selected = value!;
                              });
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            children: [
                              Expanded(
                                child: buildComboBox(
                                  title: "Forme",
                                  items: ["Option 1", "Option 2", "Option 3"],
                                  selectedItem: selected,
                                  onChanged: (value) {
                                    setState(() {
                                      selected = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: buildComboBox(
                                  title: "Dose",
                                  items: ["Option 1", "Option 2", "Option 3"],
                                  selectedItem: selected,
                                  onChanged: (value) {
                                    setState(() {
                                      selected = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Quantite"),
                                  Text("0-100"),
                                ],
                              ),
                              Slider(
                                value: 2,
                                onChanged: (double value) {},
                                max: 10,
                                min: 2,
                                thumbColor: ColorsApp.primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Prix().lancer(),
                          SizedBox(height: screenHeight * 0.02),
                          Prix().lancer(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.17,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          color: ColorsApp.primaryColor,
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: screenWidth * 0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Bottomapp().lancer(),
    );
  }
}
