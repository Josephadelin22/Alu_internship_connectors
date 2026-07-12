import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenir le flux de l'état d'authentification (connecté ou non)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Inscription
  Future<UserCredential?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String role, // 'student' ou 'startup_owner'
  }) async {
    try {
      // Validation stricte du domaine de l'email pour l'écosystème ALU
      if (!email.endsWith('@alueducation.com')) {
        throw Exception("Seuls les e-mails de l'ALU (@alueducation.com) sont autorisés.");
      }

      // 1. Création de l'utilisateur dans Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Création du profil utilisateur correspondant dans Firestore
      if (userCredential.user != null) {
        UserModel newUser = UserModel(
          uid: userCredential.user!.uid,
          name: name,
          email: email,
          role: role,
        );
        
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toMap());
      }
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Connexion
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Récupérer les détails d'un utilisateur depuis Firestore
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
