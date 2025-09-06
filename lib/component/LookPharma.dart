

import 'package:flutter/material.dart';

class LookPharma{

  Function action;
  String title;
  String subtitle;

  LookPharma({required this.action, required this.title, required this.subtitle});



  lancer(){
    return InkWell(
      onTap: (){
        action();
      },
      child: Card(
        elevation: 0.4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[

              CircleAvatar(
                radius: 24,
                child: Text('PB', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
              const SizedBox(width: 12),

              // Informations pharmacie
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.inventory_2, size: 16),
                        const SizedBox(width: 4),
                        const Text('120 produits'),
                        const SizedBox(width: 6),
                        Text(subtitle),
                        const SizedBox(width: 4),
                        const Row(
                          children: const [
                            Icon(Icons.notifications, size: 20),
                            SizedBox(width: 4),
                            Text('3'),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

              Icon(Icons.arrow_back_ios,)
              ,
            ],
          ),
        ),
      ),
    ) ;
}
}