import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application_model.dart';

class ApplicationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer une nouvelle candidature (Create)
  Future<void> applyForOpportunity({
    required String opportunityId,
    required String applicantId,
  }) async {
    try {
      // 1. Vérifier si l'utilisateur n'a pas déjà postulé
      final existingApp = await _firestore
          .collection('applications')
          .where('opportunityId', isEqualTo: opportunityId)
          .where('applicantId', isEqualTo: applicantId)
          .get();

      if (existingApp.docs.isNotEmpty) {
        throw Exception('Vous avez déjà postulé pour cette opportunité.');
      }

      // 2. Ajouter la nouvelle candidature
      await _firestore.collection('applications').add({
        'opportunityId': opportunityId,
        'applicantId': applicantId,
        'status': 'pending', // Par défaut
        'appliedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Lire les candidatures d'un utilisateur en temps réel (Read en continu)
  Stream<List<ApplicationModel>> getUserApplications(String userId) {
    return _firestore
        .collection('applications')
        .where('applicantId', isEqualTo: userId)
        // Note: orderBy a été retiré pour éviter l'erreur d'index Firestore.
        // Le tri est fait manuellement ci-dessous.
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return ApplicationModel.fromFirestore(doc.data(), doc.id);
      }).toList();
      
      // Tri manuel du plus récent au plus ancien pour contourner l'erreur Firebase
      list.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
      
      return list;
    });
  }
}
