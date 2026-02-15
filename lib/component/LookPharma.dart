import 'package:flutter/material.dart';


class LookPharma {
  Function action;
  Function ?viewSetting;
  BuildContext ? context;
  String title;
  String subtitle;
  LookPharma({required this.action, required this.title, required this.subtitle,
    this.viewSetting,
    this.context
  });
  Widget lancer() {
    String abreviation = title.length >= 2
        ? title.substring(0, 2).toUpperCase()
        : title.toUpperCase();
    return InkWell(
      onTap: () {
        action();
      },
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    viewSetting!();
                  },
                  child:CircleAvatar(
                    radius: 24,
                    child: Text(abreviation, style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.green,
                  ) ,
                )
                ,
                const SizedBox(width: 12),
                // Informations pharmacie - CORRECTION SIMPLIFIÉE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                          capitalize(this.title),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Schyler',
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        ],
                      )
                      ,
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 16,
                            color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,

                      ),

                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}