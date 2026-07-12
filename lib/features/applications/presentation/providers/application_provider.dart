import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/application_repository.dart';
import '../../data/models/application_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Fournit l'instance unique du dépôt
final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepository();
});

// StreamProvider : suit l'état des candidatures de l'utilisateur connecté en temps réel
final userApplicationsProvider = StreamProvider<List<ApplicationModel>>((ref) {
  final authState = ref.watch(authStateProvider).value;
  
  if (authState != null) {
    return ref.watch(applicationRepositoryProvider).getUserApplications(authState.uid);
  }
  
  // Retourne un flux vide si aucun utilisateur n'est connecté
  return Stream.value([]);
});
