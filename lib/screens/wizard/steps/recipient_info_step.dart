import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class RecipientInfoStep extends StatelessWidget {
  final String? name;
  final int? age;
  final String gender;
  final String relation;
  final Function(String?) onNameChanged;
  final Function(int?) onAgeChanged;
  final Function(String) onGenderChanged;
  final Function(String) onRelationChanged;

  const RecipientInfoStep({
    super.key,
    this.name,
    this.age,
    required this.gender,
    required this.relation,
    required this.onNameChanged,
    required this.onAgeChanged,
    required this.onGenderChanged,
    required this.onRelationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Per chi è il regalo?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Inserisci alcune informazioni sulla persona a cui vuoi fare il regalo',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Nome (opzionale)
          FormBuilderTextField(
            name: 'name',
            initialValue: name,
            decoration: const InputDecoration(
              labelText: 'Nome (opzionale)',
              hintText: 'Inserisci il nome del destinatario',
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: onNameChanged,
          ),
          
          const SizedBox(height: 20),
          
          // Età
          FormBuilderTextField(
            name: 'age',
            initialValue: age?.toString(),
            decoration: const InputDecoration(
              labelText: 'Età',
              hintText: 'Inserisci l\'età',
              prefixIcon: Icon(Icons.cake),
            ),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.min(0),
              FormBuilderValidators.max(120),
            ]),
            onChanged: (value) {
              if (value != null && value.isNotEmpty) {
                onAgeChanged(int.tryParse(value));
              } else {
                onAgeChanged(null);
              }
            },
          ),
          
          const SizedBox(height: 20),
          
          // Genere
          const Text(
            'Genere',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Wrap(
            spacing: 10,
            children: [
              _buildGenderChip(context, 'Maschio', 'maschio'),
              _buildGenderChip(context, 'Femmina', 'femmina'),
              _buildGenderChip(context, 'Altro', 'altro'),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Relazione
          const Text(
            'Relazione',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildRelationChip(context, 'Amico/a', 'amico'),
              _buildRelationChip(context, 'Partner', 'partner'),
              _buildRelationChip(context, 'Genitore', 'genitore'),
              _buildRelationChip(context, 'Figlio/a', 'figlio'),
              _buildRelationChip(context, 'Fratello/Sorella', 'fratello'),
              _buildRelationChip(context, 'Nonno/a', 'nonno'),
              _buildRelationChip(context, 'Collega', 'collega'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Campo personalizzato per la relazione
          if (relation != 'amico' && relation != 'partner' && relation != 'genitore' &&
              relation != 'figlio' && relation != 'fratello' && relation != 'nonno' &&
              relation != 'collega')
            FormBuilderTextField(
              name: 'custom_relation',
              initialValue: relation,
              decoration: const InputDecoration(
                labelText: 'Relazione personalizzata',
                hintText: 'Specificare la relazione',
              ),
              onChanged: (value) {
                if (value != null && value.isNotEmpty) {
                  onRelationChanged(value);
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildGenderChip(BuildContext context, String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: gender.toLowerCase() == value.toLowerCase(),
      onSelected: (selected) {
        if (selected) {
          onGenderChanged(value);
        }
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }

  Widget _buildRelationChip(BuildContext context, String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: relation.toLowerCase() == value.toLowerCase(),
      onSelected: (selected) {
        if (selected) {
          onRelationChanged(value);
        }
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
}