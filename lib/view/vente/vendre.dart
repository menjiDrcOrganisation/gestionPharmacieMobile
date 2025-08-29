import 'package:flutter/material.dart';

import '../../component/AppBar.dart';
import '../../component/BottomApp.dart';
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
                height: 618,
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
                          buildComboBox(title: "Nom du produit",
                            items: ["Option 1", "Option 2", "Option 3"],
                            selectedItem: selected,
                            onChanged: (value) {
                              setState(() {
                                selected = value!;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: buildComboBox(title: "Forme",
                                  items: ["Option 1", "Option 2", "Option 3"],
                                  selectedItem: selected,
                                  onChanged: (value) {
                                    setState(() {
                                      selected = value!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 20),
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
                          )
                          ,
                          SizedBox(height: 20),
                          Container(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Quantite"),
                                    Text("0-100")
                                  ],
                                )
                                ,

                                Slider(value: 2, onChanged: (double value) { },
                                  max: 10,
                                  min: 2,thumbColor:Color.fromRGBO(40, 167, 69, 1) ,

                                )
                              ],
                            ),

                          ),
                          SizedBox(height: 20),
                          Prix().lancer(),
                          SizedBox(height: 20),
                          Prix().lancer(),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,   // distance du bas
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(500),
                            color: Color.fromRGBO(40, 167, 69, 1),
                          ),

                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.add,color: Colors.white,size: 40,),
                        ),
                      ),
                    )



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
