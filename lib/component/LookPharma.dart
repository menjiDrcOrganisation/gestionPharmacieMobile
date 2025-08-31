

import 'package:flutter/material.dart';

class LookPharma{

  Function action;

  LookPharma({required this.action});



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
                      'Pharmacie Bien-Être',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.inventory_2, size: 16),
                        SizedBox(width: 4),
                        Text('120 produits'),
                        SizedBox(width: 6),
                        Text('Gombe, Kinshasa'),
                        SizedBox(width: 4),
                        Row(
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