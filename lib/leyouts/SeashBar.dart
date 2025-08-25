import 'package:flutter/material.dart';

class SeashBar {
// l’action prend un texte en paramètre


  lancer() {
    String query = "";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(234, 234, 234, 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 35),
            onPressed: () {
               // on déclenche l’action avec la valeur tapée
            },
          ),
          Expanded(
            child: TextField(
              onChanged: (value) {
                query = value; // on stocke la recherche
              },
              decoration: const InputDecoration(
                hintText: 'Rechercher...',
                border: InputBorder.none,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
