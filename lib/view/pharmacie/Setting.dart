import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../ModelTampo/Pharmacie.dart';
import '../../component/AppBar.dart';
import '../../component/AppBarTest.dart';
import '../../component/Colors.dart';
import '../../controller/PharmacieController.dart';
import '../../utils/navigation.dart';
import '../principal/portail.dart';

class Setting extends StatefulWidget {
  final Pharmacie pharmacie;

  const Setting({super.key, required this.pharmacie});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isEditing = false;

  late TextEditingController nomController;
  late TextEditingController adresseController;
  late TextEditingController telephoneController;
  late TextEditingController indiceController;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.pharmacie.nom);
    adresseController = TextEditingController(text: widget.pharmacie.adresse);
    telephoneController = TextEditingController(text: widget.pharmacie.telephone);
    indiceController = TextEditingController(text: widget.pharmacie.indice.toString());
  }

  @override
  void dispose() {
    nomController.dispose();
    adresseController.dispose();
    telephoneController.dispose();
    indiceController.dispose();
    super.dispose();
  }

  void toggleEdit() => setState(() => isEditing = !isEditing);

  void updatePharmacie() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      Pharmacie updated = Pharmacie(
        id: widget.pharmacie.id,
        nom: nomController.text,
        adresse: adresseController.text,
        telephone: telephoneController.text,
        indice: int.parse(indiceController.text),
        idGerant: widget.pharmacie.idGerant,
        statut: widget.pharmacie.statut,
      );

      final result = await ControllerPharmacie.update(updated);
      setState(() => isLoading = false);

      if (result != null) {
        Fluttertoast.showToast(
          msg: "Pharmacie mise à jour avec succès",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        goToPage(context, Portail());
        setState(() => isEditing = false);
      }
    }
  }

  void deletePharmacie() async {

    bool result = await ControllerPharmacie.delete(widget.pharmacie.id);

    if (result) {
      Fluttertoast.showToast(
        msg: "Pharmacie supprimée avec succès",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      goToPage(context, Portail());
    } else {
      Fluttertoast.showToast(
        msg: "Erreur lors de la suppression",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      readOnly: !isEditing,
      decoration: InputDecoration(
        labelText: label,
       contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        filled: true,
        fillColor: isEditing ? Colors.white : Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTest(title: "Detail Pharmacie",pageDeRemplacement: Portail()).lancer(context),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 25),
                buildContainerField(label: "Statut", value: "Valide"),

                const SizedBox(height: 12),
                buildContainerField(label: "Abonnement", value: "Fin : Le 20/08/2026"),
                const SizedBox(height: 6),
                Divider(),
                const SizedBox(height: 6),


                buildTextField(controller: nomController, label: "Nom de la pharmacie", icon: Icons.local_pharmacy),
                const SizedBox(height: 12),
                buildTextField(controller: adresseController, label: "Adresse complète(Rue,Quartier,Ville)", icon: Icons.location_on),
                const SizedBox(height: 12),
                buildTextField(controller: telephoneController, label: "Téléphone", icon: Icons.phone, type: TextInputType.phone),
                const SizedBox(height: 12),
                buildTextField(controller: indiceController, label: "Indice", icon: Icons.format_list_numbered, type: TextInputType.number),
                const SizedBox(height: 12),


                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isEditing ? (isLoading ? null : updatePharmacie) : toggleEdit,
                        icon: Icon(isEditing ? Icons.save : Icons.edit),
                        label: Text(isEditing ? "Enregistrer" : "Modifier"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : deletePharmacie,
                        icon: const Icon(Icons.delete),
                        label: const Text("Supprimer"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContainerField({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColors.primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}
