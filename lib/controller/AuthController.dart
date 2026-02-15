import 'package:shared_preferences/shared_preferences.dart';
import '../model/userModel.dart';
import '../services/ApiService/apiServiceUser.dart';
import '../services/GetStorage/local_storage_service.dart';

class AuthController {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorage = LocalStorageService();

  Future<User> login(String email, String password) async {
    final result = await _apiService.login(email, password);


    final token = result['token'];
    final user = result['user'] as User;

   final roleInfo = result['role'] ;

    await _localStorage.saveToken(token);
    await _localStorage.saveUser(user);
    await _localStorage.saveRoleInfo(roleInfo);
    return user;
  }

  Future<String?> getToken() async {
    return await _localStorage.getToken();
  }
  Future<User?> getUser() async {
    return await _localStorage.getUser();
  }

  Future setUser(User user) async {
    await _localStorage.saveUser(user);
  }

  Future<RoleInfo?> getRole() async {
    return await _localStorage.getRoleInfo();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // supprime toutes les clés et valeurs

  }

  Future<User> register(
      String name, String email, String password) async {
    String role = 'gerant';
    print([name, email, password, role]);
    final result =
    await _apiService.register(name, email, password, role);

    final token = result['token'];
    final user = result['user'] as User;
    final roleInfo = result['roleInfo'] as RoleInfo;

    await _localStorage.saveToken(token);
    await _localStorage.saveUser(user);
    await _localStorage.saveRoleInfo(roleInfo);

    return user;
  }
  forgotPassword(String email) async {
    await _apiService.forgotPassword(email);

  }
  resetPassword ({
    required String email,
    required String token, // token reçu par email
    required String password,
    required String confirmPassword,
  }
      ){
    _apiService.resetPassword(email: email,token:
    token,password:password,
        confirmPassword:confirmPassword);


  }
  Future<User> googleSignIn(String? idToken) async {
    try {


      final result = await _apiService.googleAuth(idToken: idToken);
      final token = result['token'];
      final user = result['user'] as User;
     final roleInfo = result['roleInfo'] as RoleInfo;

      await _localStorage.saveToken(token);
      await _localStorage.saveUser(user);
     await _localStorage.saveRoleInfo(roleInfo);
      return user;

    } catch (e) {
      print('Erreur de connexion Google : $e');
      rethrow;
    }
  }

}
