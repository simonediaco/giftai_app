import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InterestsStep extends StatefulWidget {
  final List<String> selectedInterests;
  final Function(List<String>) onInterestsChanged;

  const InterestsStep({
    super.key,
    required this.selectedInterests,
    required this.onInterestsChanged,
  });

  @override
  State<InterestsStep> createState() => _InterestsStepState();
}

class _InterestsStepState extends State<InterestsStep> {
  late List<String> _selectedInterests;
  final TextEditingController _customInterestController = TextEditingController();
  
  final List<String> _commonInterests = [
    'Musica',
    'Film',
    'Sport',
    'Lettura',
    'Cucina',
    'Tecnologia',
    'Videogiochi',
    'Viaggi',
    'Arte',
    'Moda',
    'Fotografia',
    'Giardinaggio',
    'Animali',
    'Fitness',
    'Auto',
    'Bellezza',
    'Fai da te',
  ];

  @override
  void initState() {
    super.initState();
    _selectedInterests = List.from(widget.selectedInterests);
  }
  
  @override
  void dispose() {
    _customInterestController.dispose();
    super.dispose();
  }
  
  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
      widget.onInterestsChanged(_selectedInterests);
    });
  }
  
  void _addCustomInterest() {
    final interest = _customInterestController.text.trim();
    if (interest.isNotEmpty && !_selectedInterests.contains(interest)) {
      setState(() {
        _selectedInterests.add(interest);
        widget.onInterestsChanged(_selectedInterests);
        _customInterestController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quali sono i suoi interessi?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Seleziona gli interessi del destinatario per un regalo più personalizzato',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Interessi selezionati
          if (_selectedInterests.isNotEmpty) ...[
            const Text(
              'Interessi selezionati',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedInterests.map((interest) {
                return Chip(
                  label: Text(interest),
                  onDeleted: () => _toggleInterest(interest),
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  deleteIconColor: Theme.of(context).colorScheme.primary,
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
          ],
          
          // Campo per aggiungere interessi personalizzati
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'custom_interest',
                  controller: _customInterestController,
                  decoration: const InputDecoration(
                    labelText: 'Aggiungi interesse personalizzato',
                    hintText: 'Es. Pittura, Vela, ecc.',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _addCustomInterest,
                icon: const Icon(Icons.add_circle),
                color: Theme.of(context).colorScheme.primary,
                tooltip: 'Aggiungi interesse',
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Interessi comuni
          const Text(
            'Interessi comuni',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _commonInterests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (_) => _toggleInterest(interest),
                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}