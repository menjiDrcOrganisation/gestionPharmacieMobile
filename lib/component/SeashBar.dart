import 'package:flutter/material.dart';

class SeashBar {
  // l’action prend un texte en paramètre
  lancer() {
    return Container(
      // laisse la hauteur

    height: 50,
      alignment: Alignment.center,

      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(234, 234, 234, 1),
        borderRadius: BorderRadius.circular(50),

      ),
      child: Expanded(child:Row(
        children: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 35),
            onPressed: () {
            },
          ),
          Container(
            height: 30,
            width: 250,
            alignment: Alignment.center,
            child: TextField(
              onChanged: (value) {
              },
              decoration: const InputDecoration(
                hintText: 'Rechercher...',
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
