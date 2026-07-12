import 'package:cloud_firestore/cloud_firestore.dart';

class OpportunityModel {
  final String id;
  final String title;
  final String companyName;
  final String type; // 'Part-time', 'Full-time'
  final String location; // 'Remote', 'On-campus', 'Kigali'
  final String duration; // e.g., '4-6 hrs/week'
  final List<String> tags;
  final String description;
  final DateTime postedAt;

  OpportunityModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.type,
    required this.location,
    required this.duration,
    required this.tags,
    required this.description,
    required this.postedAt,
  });

  // Convertit un document Firestore en objet Dart
  factory OpportunityModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return OpportunityModel(
      id: documentId,
      title: data['title'] ?? '',
      companyName: data['companyName'] ?? '',
      type: data['type'] ?? 'Part-time',
      location: data['location'] ?? 'Remote',
      duration: data['duration'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      description: data['description'] ?? '',
      postedAt: (data['postedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
