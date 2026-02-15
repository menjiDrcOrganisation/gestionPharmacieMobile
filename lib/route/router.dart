import 'package:gestion_pharmacie_mobile/view/auth/RegisterPage.dart';
import 'package:go_router/go_router.dart';
import '../services/GetStorage/local_storage_service.dart';
import '../view/auth/LoginPage.dart';
import '../view/auth/ProfilPage.dart';
import '../view/dashboard/viewDash.dart';
import '../view/principal/portail.dart';


final GoRouter router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final loggedIn = await LocalStorageService.isLoggedIn();
    final currentPath = state.uri.toString();

    // Si non connecté, rediriger tout sauf login/register vers login
    if (!loggedIn && currentPath != '/login' && currentPath != '/register') {
      return '/login';
    }

    // Si connecté, empêcher accès à login/register
    if (loggedIn && (currentPath == '/login' || currentPath == '/register')) {
      return '/home';
    }
    return null; // Pas de redirection
  },

  routes: [
    // Authentification
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(),
    ),

    // Client uniquement
    GoRoute(
      path: '/home',
      builder: (context, state) => Portail(),
    ),
    GoRoute(
      path: '/logout',
      builder: (context, state) => LoginPage(),
    ),

    // Livreur uniquement
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => ViewDash(),
    ),

    // GoRoute(
    //   path: '/commander',
    //   builder: (context, state) {
    //     final params = state.extra as Map<String, dynamic>?;
    //
    //     if (params == null) {
    //       throw Exception("Paramètres requis pour PageCommander");
    //     }
    //     return PageCommander(
    //       id_type_livraison: params['id_type_livraison'].toString(),
    //       id_type_vehicule: params['id_type_vehicule'].toString(),
    //     );
    //   },
    // ),

    // Routes accessibles par les deux
    GoRoute(
      path: '/profil',
      builder: (context, state) => ProfilePage(),
    ),

  ],
);
