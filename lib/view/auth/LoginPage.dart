import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:lottie/lottie.dart';

import '../../component/Colors.dart';
import '../../controller/AuthController.dart';
import '../../utils/navigation.dart';
import '../dashboard/viewDash.dart';
import '../principal/portail.dart';
import 'RegisterPage.dart';



class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connexion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = AuthController();
  bool _obscurePassword = true;

   final GoogleSignIn _googleSignIn = GoogleSignIn.instance ;

  bool _isLoading = false;
  bool _isGoogleLoading = false;

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
  Widget _connexion(){
    if(_isLoading){
      return Lottie.asset(
        'login.json',
        width: 100,
        height: 100,
        fit: BoxFit.contain,

      );
    }else
    {
      return  Text(
        'Connexion',
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 37,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }


  }
  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showToast('Veuillez remplir tous les champs');
      return;
    }

    setState(() => _isLoading = true);

    try {
      print({"loginnnnnnnnnnnnnnnnn::page"});
      final user = await _authController
          .login(
        _emailController.text,
        _passwordController.text,
      )
          .timeout(const Duration(seconds: 10));

      _showToast('Bienvenue, ${user.name}', isError: false);
      goToPagePlacement(context,Portail());


    /*  Future.delayed(
        const Duration(milliseconds: 1500),
            () async {
          context.go('/login');
        },
      );*/
    } catch (e) {
      String errorMessage = 'Impossible de se connecter. Vérifiez que votre adresse e-mail et votre mot de passe sont corrects.';
      print(e);
      if (e.toString().contains('email')) {
        errorMessage = 'Le champ e-mail est requis.';
      } else if (e.toString().contains('password')) {
        errorMessage = 'Le champ mot de passe est requis.';
      } else if (e.toString().contains('credentials')) {
        errorMessage = 'Identifiants incorrects. Veuillez réessayer.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Vérifiez votre connexion internet.';
      }

      _showToast(errorMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  Future<void> _handleGoogleSignIn() async {
    try {
      // Initialise GoogleSignIn avec les clientId (Android et Web)
      await GoogleSignIn.instance.initialize(
        clientId: "1084287883351-m7vtn5gae1ngqicv8r47qgketl2cneho.apps.googleusercontent.com",
        serverClientId: "1084287883351-5eu60ndaq3c6d2e999d5a04trcf9fecd.apps.googleusercontent.com",
      );

      // Vérifie si authenticate() est supporté
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        // Demande à l'utilisateur de se connecter
        final GoogleSignInAccount? googleUser =
        await GoogleSignIn.instance.authenticate();

        if (googleUser == null) {
          print("❌ Connexion annulée par l’utilisateur");
          return;
        }

        // Récupère les tokens d'authentification
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        print("✅ ID Token : ${googleAuth.idToken}");
        try {
          print({"loginnnnnnnnnnnnnnnnn::page"});
          final user = await _authController
              .googleSignIn(
              googleAuth.idToken
          )
              .timeout(const Duration(seconds: 10));

          _showToast('Bienvenue, ${user.name}', isError: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Portail(),
            ),
          );

          /*  Future.delayed(
        const Duration(milliseconds: 1500),
            () async {
          context.go('/login');
        },
      );*/
        } catch (e) {
          String errorMessage = 'Impossible de se connecter. Vérifiez que votre adresse e-mail et votre mot de passe sont corrects.';
          print(e);
          if (e.toString().contains('email')) {
            errorMessage = 'Le champ e-mail est requis.';
          } else if (e.toString().contains('password')) {
            errorMessage = 'Le champ mot de passe est requis.';
          } else if (e.toString().contains('credentials')) {
            errorMessage = 'Identifiants incorrects. Veuillez réessayer.';
          } else if (e.toString().contains('SocketException')) {
            errorMessage = 'Vérifiez votre connexion internet.';
          }

          _showToast(errorMessage);
        } finally {
          if (mounted) setState(() => _isLoading = false);
        }

      } else {
        print("⚠️ authenticate() n’est pas supporté sur cette plateforme");
      }
    } catch (e) {
      print("Erreur Google Sign-In : $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 20),

                _connexion(),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'E-mail ',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color:MyColors.primary, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 8),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary, width: 1.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primary, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 8),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: MyColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 10),
                 TextButton(
                      onPressed: () => Navigator.push(
                        context,
                       MaterialPageRoute(
                            builder: (context) => RegisterPage()),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Mots de passe ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: ' oublié',
                              style: TextStyle(color: MyColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                 /*   TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MotDePasseOublie()),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Mot de passe ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: 'oublié ?',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed:  _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 115, vertical: 15),
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
                      : const Text(
                    'Connexion',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Divider(color: MyColors.primary, thickness: 0.7)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Ou continuer avec",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Divider(color: MyColors.primary, thickness: 0.7)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildGoogleSignInButton(),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterPage()),
            ),
            child: const Text(
              "Vous n’avez pas de compre ? Cliquez ici ",
              style: TextStyle(
                color: MyColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return GestureDetector(
      onTap:  _handleGoogleSignIn,
      child: Container(

        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: MyColors.primary, width: 0.7),
        ),
        padding: const EdgeInsets.all(10),
        child: _isGoogleLoading
            ? const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/google.png',
              height: 24,
            ),
            const SizedBox(width: 10),
            const Text(
              'Continuer avec Google',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {

      await _googleSignIn.initialize(
        serverClientId: '1084287883351-5eu60ndaq3c6d2e999d5a04trcf9fecd.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      if (googleUser == null) return; // l’utilisateur a annulé

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final idToken = googleAuth.idToken;

      // Envoi au backend Laravel
      print('Authentification ID: $idToken');

      final response = await http.post(
        Uri.parse("https://ton-api.com/api/google-login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_token": idToken}),
      );

      if (response.statusCode == 200) {
        print("Utilisateur enregistré/connecté !");
        print(response.body); // ton token Laravel
      } else {
        print("Erreur backend : ${response.body}");
      }
    } catch (error) {
      print(error);
    }
  }

}








