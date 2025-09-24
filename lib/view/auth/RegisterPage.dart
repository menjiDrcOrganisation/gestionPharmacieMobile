import 'dart:convert';
import 'package:gestion_pharmacie_mobile/utils/Utilis.dart';
import 'package:gestion_pharmacie_mobile/view/principal/portail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../../controller/AuthController.dart';
import '../../utils/navigation.dart';

// Mock AuthController for demonstration


// Custom colors
class AppColors {
  static const Color primary = Color(0xFF4361EE);
  static const Color secondary = Color(0xFF3A0CA3);
  static const Color accent = Color(0xFF7209B7);
  static const Color background = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color error = Color(0xFFE63946);
  static const Color success = Color(0xFF2A9D8F);
  static const Color warning = Color(0xFFF4A261);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inscription',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = AuthController();


  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  int _passwordStrength = 0;
  String _passwordFeedback = '';

  // Check password strength
  void _checkPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordStrength = 0;
        _passwordFeedback = '';
      });
      return;
    }

    int strength = 0;
    String feedback = '';

    if (value.length >= 8) strength++;
    if (value.contains(RegExp(r'[A-Z]'))) strength++;
    if (value.contains(RegExp(r'[a-z]'))) strength++;
    if (value.contains(RegExp(r'[0-9]'))) strength++;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    if (strength < 2) {
      feedback = 'Mot de passe faible';
    } else if (strength < 4) {
      feedback = 'Mot de passe moyen';
    } else {
      feedback = 'Mot de passe fort';
    }

    setState(() {
      _passwordStrength = strength;
      _passwordFeedback = feedback;
    });
  }

  // Get password strength color
  Color _getStrengthColor() {
    if (_passwordStrength < 2) return AppColors.error;
    if (_passwordStrength < 4) return AppColors.warning;
    return AppColors.success;
  }
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
  Future<void> _handleGoogleSignIn() async {
    try {
      // Initialise GoogleSignIn avec les clientId (Android et Web)
      await GoogleSignIn.instance.initialize(
        clientId: Utilise.clientId,
        serverClientId: Utilise.serverClientId,
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
          print({"loginnnnnnnnnnnnnnnnn::page google"});
          final user = await _authController
              .googleSignIn(
              googleAuth.idToken
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
          print('erreor lors google $e');
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
  // Validate and register
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

   /* if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: "Les mots de passe ne correspondent pas",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.error,
        textColor: Colors.white,
      );
      return;
    }*/

    setState(() => _isLoading = true);

    try {

        final user = await _authController.register(
        _nameController.text ,
        _emailController.text,
        _passwordController.text,

      );
        final success = user == null ? false : true;

        print(user);
        setState(() => _isLoading = false);

      if (success) {
        Fluttertoast.showToast(
          msg: "Compte créé avec succès 🎉",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.success,
          textColor: Colors.white,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Portail(),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Erreur lors de la création du compte",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.error,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(
        msg: "Erreur de connexion",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.error,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),

          child: SingleChildScrollView(

            child: Column(
              children: [
                const SizedBox(height: 50),
                // Animated header


                const SizedBox(height: 10),
                const Text(
                  "Créer un compte",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Rejoignez-nous et commencez votre voyage",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Form container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                       TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Nom complet",
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer votre nom";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer votre email";
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return "Veuillez entrer un email valide";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onChanged: _checkPassword,
                          decoration: InputDecoration(
                            labelText: "Mot de passe",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer un mot de passe";
                            }
                            if (value.length < 8) {
                              return "Le mot de passe doit contenir au moins 8 caractères";
                            }
                            return null;
                          },
                        ),
                        if (_passwordFeedback.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _passwordFeedback,
                                style: TextStyle(
                                  color: _getStrengthColor(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              LinearProgressIndicator(
                                value: _passwordStrength / 5,
                                backgroundColor: Colors.grey[300],
                                color: _getStrengthColor(),
                              ),
                            ],
                          ),
                        ],
                       // const SizedBox(height: 20),
                        /*TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: "Confirmer le mot de passe",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez confirmer votre mot de passe";
                            }
                            if (value != _passwordController.text) {
                              return "Les mots de passe ne correspondent pas";
                            }
                            return null;
                          },
                        ),*/
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                              "S'inscrire",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Ou continuez avec",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: _handleGoogleSignIn,
                            icon: Image.asset(
                              'images/google.png', // Add Google icon asset
                              height: 24,
                            ),
                            label: const Text("Google"),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Vous avez déjà un compte ?",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

      ),
    );
  }
}