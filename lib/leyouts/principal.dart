import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text(widget.titre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )
        ),
          backgroundColor: Color.fromRGBO(40, 167, 69, 1)
        // utilisation du titre injecté
      ),
      body: Center(
        child: Container(
          child: widget.contenu,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 60, // hauteur de la barre
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // espace entre les icônes
            crossAxisAlignment: CrossAxisAlignment.center,     // centre verticalement
            children: [
              IconButton(
                icon: Image.asset("assets/Icone/accueil.png"),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset("assets/Icone/bell.png"),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset("assets/Icone/user.png"),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
