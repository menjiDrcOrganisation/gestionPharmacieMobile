import 'package:flutter/material.dart';

import '../component/AppBar.dart';
import '../component/BottomApp.dart';

class LayoutPrincipal extends StatefulWidget {
  final String titre;       // donnée à injecter
  final int compteurInitial;
  final contenu;// donnée à injecter

  const LayoutPrincipal({
    super.key,
    required this.titre,
    this.compteurInitial = 0,
    this.contenu
  });

  @override
  State<LayoutPrincipal> createState() => _LayoutPrincipalState();
}

class _LayoutPrincipalState extends State<LayoutPrincipal> {

  late Widget contenu;
  @override
  void initState() {
    super.initState();
    contenu=widget.contenu;// récupération de la donnée injectée
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(Title: "Portail").lancer(),
      body: Container(
          child: widget.contenu,
        ),
      bottomNavigationBar: Bottomapp().lancer(),
    );
  }
}
