

import 'package:flutter/material.dart';

import '../../component/Colors.dart';

class StructurePage {

  double screenHeight;
  double screenWidth;
  Widget content;
  Widget contentBack;
  double sizeContent;
  

  StructurePage({
    required this.screenHeight,
    required this.screenWidth,
    required this.content,
    required this.contentBack,
    double? sizeContent,
  }) : sizeContent = sizeContent ??  0.72;

  lancer(){
    return Stack(
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
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            child:
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: screenHeight * sizeContent,
            width: screenWidth * 0.9,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: SingleChildScrollView(
                    child:this.content ,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: contentBack,
                  ),
                ),
              ],
            ),
          ) ,
        )
        )

       ,

      ],
    );


  }


}