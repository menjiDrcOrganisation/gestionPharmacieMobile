import 'package:flutter/material.dart';

class CreationCompteStep2 extends StatelessWidget {
  const CreationCompteStep2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header vert
              Container(
                width: double.infinity,
                color: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Center(
                  child: Text(
                    "Opharma",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Titre
              const Text(
                "Creation de compte",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Icône profil circulaire
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, size: 50, color: Colors.grey),
              ),

              const SizedBox(height: 15),

              // Stepper
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const Text("2 sur 2", style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 1.0, // 100%
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                      minHeight: 3,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField("Email",
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 20),

                    const Text(
                      "Pièces justificatives à uploader",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "- Licence d’exploitation délivrée par le Ministère de la Santé\n"
                          "- Numéro d’enregistrement officiel\n"
                          "- Copie d’une pièce d’identité du responsable",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 15),

                    // Champ d'upload simulé
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Uploader un fichier",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.attach_file,
                              color: Colors.grey),
                          onPressed: () {
                            // Ici tu pourras intégrer file picker
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Bouton Créer
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action pour soumettre le formulaire
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Créer",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Champ de texte réutilisable
  Widget _buildTextField(String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
