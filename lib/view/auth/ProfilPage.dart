import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gestion_pharmacie_mobile/model/userModel.dart';
import 'package:gestion_pharmacie_mobile/utils/navigation.dart';
import 'package:gestion_pharmacie_mobile/view/auth/LoginPage.dart';

import '../../controller/AuthController.dart';
import '../../services/ApiService/apiServiceUser.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late Future<User> _userFuture;
  bool _isEditing = false;
  bool _showPasswordFields = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ApiService _apiService = ApiService();
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUserData();

    // Configuration des animations
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<User> _loadUserData() async {
    try {
      final token = await _authController.getToken();
      if (token == null) throw Exception('Utilisateur non connecté');

      _apiService.setToken(token);
      final user = await _authController.getUser();
      if (user == null) throw Exception('Profil non trouvé');

      return user;
    } catch (e) {
      debugPrint('Erreur de chargement: $e');
      rethrow;
    }
  }

  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> _toggleEdit() async {
    if (_isEditing && _formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final updatedUser = await _apiService.updateProfile(
          name: _nameController.text,
          phone: _phoneController.text,

        );
        _authController.setUser(updatedUser);

        _showToast("Profil mis à jour avec succès");
        setState(() {
          _userFuture = Future.value(updatedUser);
          _isEditing = false;
        });
      } catch (e) {
        String errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
        _showToast(errorMessage, isError: true);
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      setState(() => _isEditing = !_isEditing);
    }
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showToast("Les mots de passe ne correspondent pas", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _apiService.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      _showToast("Mot de passe changé avec succès");
      setState(() {
        _showPasswordFields = false;
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });
    } catch (e) {
      String errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
      _showToast(errorMessage, isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildProfileField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool _obscureText = obscureText;

        return TextFormField(
          controller: controller,
          enabled: isEditing,
          obscureText: _obscureText,
          keyboardType: keyboardType,
          style: TextStyle(color: Colors.grey[800]),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            suffixIcon: obscureText
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
            filled: true,
            fillColor: isEditing ? Colors.grey[50] : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
          validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
        );
      },
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    Color color = Colors.green,
    bool isFilled = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: isFilled
          ? ElevatedButton.icon(
        icon: Icon(icon, size: 20, color: Colors.white),
        label: Text(text, style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
      )
          : OutlinedButton.icon(
        icon: Icon(icon, size: 20, color: color),
        label: Text(text, style: TextStyle(color: color)),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: color, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Mon Profil',
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600
            )
        ),
        centerTitle: false,
        actions: [
          if (!_showPasswordFields)
            IconButton(
              icon: _isLoading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.green,
                ),
              )
                  : Icon(
                _isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
                color: Colors.green,
              ),
              onPressed: _isLoading ? null : _toggleEdit,
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    SizedBox(height: 16),
                    Text('Erreur de chargement',
                        style: TextStyle(color: Colors.grey[600])
                    ),
                    SizedBox(height: 8),
                    Text('${snapshot.error}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => setState(() => _userFuture = _loadUserData()),
                      child: Text('Réessayer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final user = snapshot.data!;
            if (!_isEditing) {
              _nameController.text = user.name;
              _phoneController.text = '' ?? '';
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Photo de profil
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        user.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Badge statut
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Compte vérifié',
                      style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // Formulaire
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProfileField(
                          label: 'Nom complet',
                          controller: _nameController,
                          isEditing: _isEditing && !_showPasswordFields,
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 16),
                        _buildProfileField(
                          label: 'Téléphone',
                          controller: _phoneController,
                          isEditing: _isEditing && !_showPasswordFields,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: user.email,
                          enabled: false,
                          style: TextStyle(color: Colors.grey[600]),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 32),

                        // Section mot de passe
                        if (_showPasswordFields) ...[
                          Text(
                            'Changer le mot de passe',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800]
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildProfileField(
                            label: 'Mot de passe actuel',
                            controller: _currentPasswordController,
                            isEditing: true,
                            icon: Icons.lock_outline,
                            obscureText: true,
                          ),
                          SizedBox(height: 16),
                          _buildProfileField(
                            label: 'Nouveau mot de passe',
                            controller: _newPasswordController,
                            isEditing: true,
                            icon: Icons.lock_reset,
                            obscureText: true,
                          ),
                          SizedBox(height: 16),
                          _buildProfileField(
                            label: 'Confirmer le mot de passe',
                            controller: _confirmPasswordController,
                            isEditing: true,
                            icon: Icons.lock_outline,
                            obscureText: true,
                          ),
                          SizedBox(height: 24),
                          _buildActionButton(
                            text: 'Valider le changement',
                            icon: Icons.check_circle_outline,
                            onPressed: _changePassword,
                            color: Colors.green,
                            isFilled: true,
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () => setState(() => _showPasswordFields = false),
                            child: Text('Annuler',
                                style: TextStyle(color: Colors.grey[600])
                            ),
                          ),
                          SizedBox(height: 24),
                        ],

                        // Boutons d'action
                        if (!_isEditing && !_showPasswordFields) ...[
                          _buildActionButton(
                            text: 'Changer le mot de passe',
                            icon: Icons.lock_outlined,
                            onPressed: () => setState(() => _showPasswordFields = true),
                            color: Colors.green,
                          ),
                          SizedBox(height: 16),
                          _buildActionButton(
                            text: 'Déconnexion',
                            icon: Icons.logout,
                            color: Colors.red,
                            onPressed: () => _authController.logout().then((_) {
                              goToPagePlacement(context, LoginPage());
                            }),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Classes factices pour la compilation




