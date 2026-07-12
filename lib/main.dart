import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/opportunities/presentation/screens/main_layout.dart';
import 'features/opportunities/presentation/screens/startup_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Note : L'initialisation plantera tant que le projet n'est pas lié sur Firebase Console.
  // Tu peux temporairement commenter la ligne ci-dessous si tu veux tester le build local immédiatement.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: AluInternshipApp()));
}

class AluInternshipApp extends ConsumerWidget {
  const AluInternshipApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On écoute le flux d'authentification en temps réel
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'ALU Internship Connector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
      ),
      // Gestion réactive des écrans grâce au pattern de filtrage de Riverpod (.when)
      home: authState.when(
        data: (user) {
          if (user != null) {
            // On écoute le fournisseur qui récupère les détails de l'utilisateur (rôle)
            final userDetails = ref.watch(userDetailsProvider).value;
            
            if (userDetails == null) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            
            // Redirection selon le rôle configuré lors de l'onboarding
            if (userDetails.role == 'startup_owner') {
              return const StartupDashboardScreen();
            }
            return const MainLayout(); // Pour les étudiants
          }
          return const AuthScreen(); // Pas connecté -> Formulaire
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => Scaffold(
          body: Center(child: Text('Erreur d\'authentification : $err')),
        ),
      ),
    );
  }
}
