import 'package:flutter/material.dart';

class LookPharma {
  Function action;
  Function ?viewSetting;
  String title;
  String subtitle;
  LookPharma({required this.action, required this.title, required this.subtitle,this.viewSetting});
  Widget lancer() {
    String abreviation = title.length >= 2
        ? title.substring(0, 2).toUpperCase()
        : title.toUpperCase();
    return InkWell(
      onTap: () {
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
                child: Text(abreviation, style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
              const SizedBox(width: 12),

              // Informations pharmacie - CORRECTION SIMPLIFIÉE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(
                        this.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                        onTap: (){
                          viewSetting!();
                        },
                        child: Text("Setting",
                          style: TextStyle(
                              color: Colors.red
                          ),

                        ),
                      )
                      ],
                    )
                    ,
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.library_add_check_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text("Actif",
                          style: TextStyle(
                              color: Colors.green
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.notifications, size: 16),
                        const SizedBox(width: 4),
                        const Text('3'),
                      ],
                    ),
                  ],
                ),
              ),

              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}