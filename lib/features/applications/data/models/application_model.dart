import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String id;
  final String opportunityId;
  final String applicantId;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime appliedAt;

  ApplicationModel({
    required this.id,
    required this.opportunityId,
    required this.applicantId,
    required this.status,
    required this.appliedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'applicantId': applicantId,
      'status': status,
      'appliedAt': appliedAt,
    };
  }

  factory ApplicationModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ApplicationModel(
      id: id,
      opportunityId: data['opportunityId'] ?? '',
      applicantId: data['applicantId'] ?? '',
      status: data['status'] ?? 'pending',
      appliedAt: (data['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
