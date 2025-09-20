


import 'package:flutter/material.dart';

void goToPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}


void goToPagePlacement(BuildContext context, Widget page) {

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => page!),
  );
}
