import 'dart:convert';
import 'package:gestion_pharmacie_mobile/utils/Utilis.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/userModel.dart';
import '../GetStorage/local_storage_service.dart';


class ApiService {
  //final String baseUrl = 'https://gotrans.menjidrc.com/api';
  final String baseUrl = Utilise.baseUrl;
  String? _token;

  // Méthode pour définir le token après la connexion
  void setToken(String token) {
    _token = token;
  }

  // Headers communs pour les requêtes authentifiées
  Map<String, String> get _authHeaders {
    return {
      //'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<Map<String, dynamic>> login(String email, String password) async {

    print([email,password]);
    print("${baseUrl}login");
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      body: {
        'email': email,
        'password': password,
      },
    );


    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      print(data);
      _token = data['token'];
      return {
        'user': User.fromJson(data['user']),
        'role': RoleInfo.fromJson(data['role']),
        'token': data['token'],
      };
    } else {
      print({"loginnnnnnnnnnnnnnnnn::${response.statusCode}"});
      throw Exception('Erreur de connexion');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String? role) async {

    final response = await http.post(
      Uri.parse('${baseUrl}register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'role': role
      },
    );
    print(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _token = data['token']; // Stocke le token après l'inscription
      return {
        'user': User.fromJson(data['user']),
        'roleInfo': RoleInfo.fromJson(data['role']),
        'token': data['token'],
      };
    } else {
      throw Exception('Erreur lors de l\'enregistrement : ${response.body}');
    }
  }

  // Récupérer les informations du profil utilisateur
  Future<User> getProfile() async {
    final response = await http.get(
      Uri.parse('${baseUrl}user/profile'),
      headers: _authHeaders,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['data']);
    } else {
      throw Exception('Erreur lors de la récupération du profil: ${response.body}');
    }
  }

  // Mettre à jour le profil utilisateur
  Future<User> updateProfile({
    required String name,
    // required String email,
    String? phone,
  })

  async {
    final prefs = await LocalStorageService();
    final User? user = await prefs.getUser()  ;
    final response = await http.put(
      Uri.parse('${baseUrl}user/profile'),
      headers: _authHeaders,
      body: jsonEncode({
        'name': name,
        'email': user?.email ,
        //'number_phone': phone,
      }),
    );
    print('objectprofillllllllllllllllllllllllllllllll');
    print(response.body);

    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = jsonDecode(response.body);
      return User.fromJson(data['data']);
    } else {
      throw Exception('Erreur lors de la mise à jour: ${response.body}');
    }
  }
  // Dans votre AuthController.dart
  Future<void> validateResetToken({
    required String email,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Invalid token or token expired');
      }

      final responseData = jsonDecode(response.body);
      if (responseData['valid'] != true) {
        throw Exception(responseData['message'] ?? 'Invalid token');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Changer le mot de passe
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('${baseUrl}user/change-password'),
      headers: _authHeaders,
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        //'new_password_confirmation': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Erreur lors du changement de mot de passe');
    }
  }

  // Mettre à jour la photo de profil
  Future<String> updateProfilePhoto(String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}user/profile-photo'),
    )..headers.addAll(_authHeaders)
      ..files.add(await http.MultipartFile.fromPath('photo', imagePath));

    var response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseData);
      return data['photo_url'];
    } else {
      throw Exception('Erreur lors de la mise à jour de la photo: $responseData');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('${baseUrl}logout'),
      headers: _authHeaders,
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la déconnexion: ${response.body}');
    }
    _token = null; // Supprime le token après déconnexion
  }
  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['message']); // Message de confirmation
    } else {
      throw Exception('Erreur lors de l’envoi de l’email de réinitialisation');
    }
  }
  Future<void> resetPassword({
    required String email,
    required String token, // token reçu par email
    required String password,
    required String confirmPassword,
  }) async {
    final response = await http.post(
      Uri.parse('${baseUrl}reset-password'),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': confirmPassword,
      },
    );

    if (response.statusCode == 200) {
      print('Mot de passe mis à jour avec succès');
    } else {
      throw Exception('Échec de la réinitialisation du mot de passe');
    }


  }
  Future<Map<String, dynamic>> googleAuth({required String? idToken}) async {
    final url = Uri.parse('${baseUrl}google-login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_token': idToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return {
        'user': User.fromJson(data['user']),
        //'roleInfo': RoleInfo.fromJson(data['roleInfo']),
        'token': data['token'],
      };
    } else {
      throw Exception('Échec de l\'authentification Google');
    }
  }
}