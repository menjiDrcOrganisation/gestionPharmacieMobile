import 'package:flutter/material.dart';

class Block {
  final String montant;
  final String text;
  final Function action;
  final String src;

  Block({
    required this.src,
    required this.action,
    required this.montant,
    required this.text,
  });

  Widget lancer(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // tailles proportionnelles
    final double blockWidth = screenWidth * 0.45; // 45% de la largeur écran
    final double blockHeight = screenHeight * 0.13; // 13% de la hauteur écran

    return InkWell(
      onTap: () => action(),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: blockWidth,
        height: blockHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(234, 234, 234, 1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: blockHeight * 0.5,
              width: blockWidth * 0.2,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(40, 167, 69, 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  src,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: blockHeight * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatMontant(montant),
                    style: TextStyle(
                      fontSize: blockWidth * 0.1, // taille texte adaptative
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(40, 167, 69, 1),
                    ),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: blockWidth * 0.07,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(107, 101, 101, 1),
                    ),
                  ),
                  const Icon(Icons.access_time_rounded, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour convertir le montant en K si >= 1000
  String _formatMontant(String montant) {
    int? value = int.tryParse(montant.replaceAll(RegExp(r'[^0-9]'), ''));
    if (value == null) return montant; // si non numérique
    if (value >= 1000) {
      double valK = value / 1000;
      return valK.toStringAsFixed(1) + 'K';
    }
    return value.toString();
  }
}
