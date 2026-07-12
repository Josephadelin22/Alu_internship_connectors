class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // 'student' ou 'startup_owner'
  final List<String> skills;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.skills = const [],
  });

  // Convertir un document Firestore (Map) en objet UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'student',
      skills: List<String>.from(map['skills'] ?? []),
    );
  }

  // Convertir notre objet UserModel en Map pour l'enregistrer dans Firestore
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'role': role, 'skills': skills};
  }
}
