import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../component/Colors.dart';

class MotDePasseOublie extends StatefulWidget {
  const MotDePasseOublie({super.key});

  @override
  State<MotDePasseOublie> createState() => _MotDePasseOublieState();
}

class _MotDePasseOublieState extends State<MotDePasseOublie> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _codeSent = false;

  void _showToast(String message, {bool isError = true}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _handlePasswordReset() async {
    if (_emailController.text.isEmpty) {
      _showToast('Veuillez entrer votre adresse e-mail');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simuler l'envoi du code (à remplacer par l'appel API réel)
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _codeSent = true;
        _isLoading = false;
      });

      _showToast('Code envoyé à ${_emailController.text}', isError: false);
    } catch (e) {
      _showToast('Erreur lors de l\'envoi du code');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      _showToast('Veuillez entrer le code reçu');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simuler la vérification du code (à remplacer par l'appel API réel)
      await Future.delayed(const Duration(seconds: 2));

      _showToast('Code vérifié avec succès', isError: false);
      // Naviguer vers la page de réinitialisation du mot de passe
      Navigator.pop(context);
    } catch (e) {
      _showToast('Code incorrect');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mot de passe oublié'),
        backgroundColor: MyColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Réinitialisation du mot de passe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Entrez votre adresse e-mail pour recevoir un code de vérification',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  enabled: !_codeSent,
                  decoration: InputDecoration(
                    hintText: 'Adresse e-mail',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 8),
                  ),
                ),
                const SizedBox(height: 20),
                if (_codeSent) ...[
                  TextField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      hintText: 'Code de vérification',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.primary, width: 1.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.primary, width: 2.0),
                      ),
                      contentPadding: const EdgeInsets.only(bottom: 8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Un code de vérification a été envoyé à votre adresse e-mail',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _codeSent ? _verifyCode : _handlePasswordReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    _codeSent ? 'Vérifier le code' : 'Envoyer le code',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                if (_codeSent)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _codeSent = false;
                        _codeController.clear();
                      });
                    },
                    child: const Text(
                      "Modifier l'adresse e-mail",
                      style: TextStyle(
                        color: MyColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}