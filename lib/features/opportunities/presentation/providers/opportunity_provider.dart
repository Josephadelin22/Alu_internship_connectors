import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/opportunity_repository.dart';
import '../../data/models/opportunity_model.dart';

final opportunityRepositoryProvider = Provider<OpportunityRepository>((ref) {
  return OpportunityRepository();
});

// Le StreamProvider magique qui va alimenter l'UI de manière réactive
final opportunitiesStreamProvider = StreamProvider<List<OpportunityModel>>((
  ref,
) {
  return ref.watch(opportunityRepositoryProvider).watchOpportunities();
});
