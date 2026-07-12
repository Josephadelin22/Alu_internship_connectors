import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/opportunity_model.dart';

class OpportunityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer toutes les opportunités triées par date en temps réel
  Stream<List<OpportunityModel>> watchOpportunities() {
    return _firestore
        .collection('opportunities')
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return OpportunityModel.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<void> createOpportunity({
    required String title,
    required String companyName,
    required String type,
    required String location,
    required String duration,
    required String description,
    required List<String> tags,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Must be logged in to post an opportunity");

      await _firestore.collection('opportunities').add({
        'ownerId': user.uid, // Permet de savoir quelle startup a publié l'offre
        'title': title,
        'companyName': companyName,
        'type': type,
        'location': location,
        'duration': duration,
        'description': description,
        'tags': tags,
        'postedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
