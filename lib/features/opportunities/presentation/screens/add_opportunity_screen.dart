import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/opportunity_provider.dart';

class AddOpportunityScreen extends ConsumerStatefulWidget {
  const AddOpportunityScreen({super.key});

  @override
  ConsumerState<AddOpportunityScreen> createState() => _AddOpportunityScreenState();
}

class _AddOpportunityScreenState extends ConsumerState<AddOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController(); // Séparés par des virgules

  String _selectedType = 'Part-time';
  String _selectedLocation = 'Remote';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Découpage des tags saisis par virgule
    List<String> tagsList = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    try {
      await ref.read(opportunityRepositoryProvider).createOpportunity(
            title: _titleController.text.trim(),
            companyName: _companyController.text.trim(),
            type: _selectedType,
            location: _selectedLocation,
            duration: _durationController.text.trim(),
            description: _descriptionController.text.trim(),
            tags: tagsList,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opportunity published successfully! 🎉'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6C63FF);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post an Opportunity', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Job Title (e.g. Flutter Developer)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _companyController,
                      decoration: InputDecoration(labelText: 'Venture Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your startup name' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: InputDecoration(labelText: 'Job Type', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      items: const [DropdownMenuItem(value: 'Part-time', child: Text('Part-time')), DropdownMenuItem(value: 'Full-time', child: Text('Full-time'))],
                      onChanged: (val) => setState(() => _selectedType = val!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedLocation,
                      decoration: InputDecoration(labelText: 'Location', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      items: const [DropdownMenuItem(value: 'Remote', child: Text('Remote')), DropdownMenuItem(value: 'On-campus', child: Text('On-campus')), DropdownMenuItem(value: 'Kigali', child: Text('Kigali'))],
                      onChanged: (val) => setState(() => _selectedLocation = val!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _durationController,
                      decoration: InputDecoration(labelText: 'Duration/Hours (e.g. 8-10 hrs/week)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tagsController,
                      decoration: InputDecoration(labelText: 'Skills required (comma separated: Flutter, Dart, UI)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(labelText: 'Role Description', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Publish Opportunity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
