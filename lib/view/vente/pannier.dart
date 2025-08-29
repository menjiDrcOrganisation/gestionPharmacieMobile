import 'package:flutter/material.dart';

import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
import '../../component/Button.dart';
import '../../component/Combobox.dart';
import '../../component/LookPharma.dart';
import '../../component/Option.dart';
import '../../component/SeashBar.dart';
import '../../component/vente/Prix.dart';
import '../../component/vente/Table.dart';

class Pannier extends StatefulWidget {

  @override
  State<Pannier> createState() => _PannierState();
}

class _PannierState extends State<Pannier> {
  String selected = "Option 1";

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(Title: "Espace vente").lancer(),
      body:Stack(
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 20,
                width: double.infinity,
                color:Color.fromRGBO(40, 167, 69, 1),

              ),

              Container(
                width: double.infinity,
                height:10,
                color:Color.fromRGBO(40, 167, 69, 1),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 645,
                child:Stack(
                  children: [
                    Container(
                      width: 380,
                      height: 580,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),

                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          tableau().lancer()
                        ],
                      ),
                    ),
                Positioned(
                  bottom: 0,   // distance du bas
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Button(
                          intitule: "Valider",
                          colorButton:Color.fromRGBO(40, 167, 69, 1),
                      colorText: Colors.white)
                          .lancer(),

                      Button(
                          intitule: "Annuller",
                          colorButton:Color.fromRGBO(217, 217, 217, 1)
                      ).lancer()
                    ],
                  ) )

                  ],
                ) ,
              )
              ,
            ],
          )
        ],
      )
      ,
      bottomNavigationBar:Bottomapp().lancer() ,
    );
  }
}
