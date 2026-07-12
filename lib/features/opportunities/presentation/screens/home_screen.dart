import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/opportunity_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/opportunity_card.dart';
import 'opportunity_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Color(0xFF6C63FF);
    // On écoute les données de Firebase en temps réel
    final opportunitiesAsync = ref.watch(opportunitiesStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Hello Amina
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Hello, Amina',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E24),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text('👋', style: TextStyle(fontSize: 22)),
                        ],
                      ),
                      Text(
                        'Find meaningful ways to contribute.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Badge(
                      label: Text('1', style: TextStyle(color: Colors.white)),
                      child: Icon(Icons.notifications_none_rounded, size: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search opportunities...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.tune_rounded, color: primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Categories
              const Text(
                'Browse by category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E24),
                ),
              ),
              const SizedBox(height: 16),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryCard(
                      icon: Icons.home_repair_service_outlined,
                      label: 'Design',
                    ),
                    CategoryCard(
                      icon: Icons.code_rounded,
                      label: 'Engineering',
                    ),
                    CategoryCard(
                      icon: Icons.campaign_outlined,
                      label: 'Marketing',
                    ),
                    CategoryCard(icon: Icons.analytics_outlined, label: 'Data'),
                    CategoryCard(icon: Icons.grid_view_rounded, label: 'Other'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Section Dynamique : Recent Opportunities de Firebase
              const Text(
                'Recent opportunities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E24),
                ),
              ),
              const SizedBox(height: 14),

              opportunitiesAsync.when(
                data: (opportunities) {
                  if (opportunities.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No opportunities found.\nAdd one in the Firebase Console to see it appear!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  // Génération de la liste en fonction des documents réels de Firebase
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: opportunities.length,
                    itemBuilder: (context, index) {
                      final op = opportunities[index];
                      return OpportunityCard(
                        title: op.title,
                        company: op.companyName,
                        type: op.type,
                        location: op.location,
                        icon: Icons.work_outline_rounded,
                        iconColor: primaryColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OpportunityDetailsScreen(
                                opportunity: op,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                ),
                error: (err, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Error loading data: $err',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
