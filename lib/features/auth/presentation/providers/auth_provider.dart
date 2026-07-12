import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

// Fournisseur unique du dépôt d'authentification
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Flux en temps réel qui écoute si un utilisateur est connecté ou non
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Fournisseur qui récupère les données de l'utilisateur connecté depuis Firestore
final userDetailsProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider).value;
  if (authState != null) {
    return ref.watch(authRepositoryProvider).getUserDetails(authState.uid);
  }
  return null;
});
