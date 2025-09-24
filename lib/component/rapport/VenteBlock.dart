import 'package:flutter/material.dart';

class VenteBlock {
  Widget lancer() {
    return Card(
      elevation: 0.4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green,
              child: Text(
                "F",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "cc",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(Icons.info, size: 35),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "vvv",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.library_add_check_outlined, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Actif",
                        style: TextStyle(color: Colors.green),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.notifications, size: 16),
                      SizedBox(width: 4),
                      Text('3'),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
