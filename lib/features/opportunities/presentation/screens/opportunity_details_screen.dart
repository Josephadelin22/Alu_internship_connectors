import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/opportunity_model.dart';
import '../../../applications/presentation/providers/application_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class OpportunityDetailsScreen extends ConsumerWidget {
  final OpportunityModel opportunity;

  const OpportunityDetailsScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black87),
            onPressed: () {
              // Action pour sauvegarder l'opportunité
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Entreprise et Titre
            Text(
              opportunity.companyName,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),

            // Métadonnées (Type, Location, Duration)
            Row(
              children: [
                _buildInfoChip(Icons.work_outline, opportunity.type),
                const SizedBox(width: 16),
                _buildInfoChip(
                  Icons.location_on_outlined,
                  opportunity.location,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoChip(Icons.access_time_outlined, opportunity.duration),

            const SizedBox(height: 32),

            // Description
            Text(
              "Description",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              opportunity.description,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),

            const SizedBox(height: 32),

            // Compétences / Tags
            Text(
              "Skills / Tags",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: opportunity.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),

            // Espace pour éviter que le bouton fixe ne cache du texte
            const SizedBox(height: 100),
          ],
        ),
      ),

      // Bouton fixe en bas
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () async {
              final user = ref.read(authStateProvider).value;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez vous connecter pour postuler.')),
                );
                return;
              }

              try {
                // Affiche un indicateur de chargement
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );

                // Envoie de la candidature
                await ref.read(applicationRepositoryProvider).applyForOpportunity(
                  opportunityId: opportunity.id,
                  applicantId: user.uid,
                );

                if (!context.mounted) return;

                // Ferme le dialogue de chargement
                Navigator.of(context).pop();

                // Message de succès
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Candidature envoyée avec succès ! 🎉'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;

                // Ferme le dialogue en cas d'erreur
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString().replaceAll('Exception: ', '')),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6200EE), // Gros bouton violet
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "Apply Now",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
