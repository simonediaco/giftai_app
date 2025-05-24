import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/recipient.dart';
import '../bloc/recipients_bloc.dart';
import '../bloc/recipients_event.dart';
import '../bloc/recipients_state.dart';

class AddRecipientPage extends StatefulWidget {
  final Recipient? recipient;
  final Recipient? initialData;

  
  const AddRecipientPage({
    Key? key,
    this.recipient,
    this.initialData,

  }) : super(key: key);

  @override
  State<AddRecipientPage> createState() => _AddRecipientPageState();
}

class _AddRecipientPageState extends State<AddRecipientPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  String _selectedGender = 'X'; // Valore di default
  DateTime _birthDate = DateTime(2000, 1, 1); // Valore di default
  String? _selectedRelation;
  final List<String> _selectedInterests = [];
  final _notesController = TextEditingController();
  
  // Opzioni disponibili - aggiornate con valori accettati dall'API
  final List<Map<String, String>> _genderOptions = [
    // {'value': 'X', 'label': 'Non specificato'},
    {'value': 'M', 'label': 'Uomo'},
    {'value': 'F', 'label': 'Donna'},
    {'value': 'N', 'label': 'Non binario'},
    {'value': 'O', 'label': 'Altro'},
  ];
  
  // Valori accettati dall'API per la relazione - in minuscolo
  final List<String> _relationOptions = ['amico', 'familiare', 'partner', 'collega', 'altro'];
    
  // Mapping per la visualizzazione in italiano
  final Map<String, String> _relationLabels = {
    'amico': 'Amico',
    'familiare': 'Familiare',
    'partner': 'Partner',
    'collega': 'Collega',
    'altro': 'Altro',
  };

  final List<String> _interests = [
    'Musica', 'Sport', 'Lettura', 'Tecnologia', 'Cucina', 
    'Viaggi', 'Arte', 'Moda', 'Gaming', 'Film'
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Pre-compila i campi se stiamo modificando un destinatario esistente
    if (widget.recipient != null) {
      _nameController.text = widget.recipient!.name;
      _selectedGender = widget.recipient!.gender;
      _birthDate = widget.recipient!.birthDate;
      _selectedRelation = widget.recipient!.relation;
      _selectedInterests.addAll(widget.recipient!.interests);
      _notesController.text = widget.recipient!.notes ?? '';
    } 
    // Pre-compila con dati iniziali se forniti
    else if (widget.initialData != null) {
      _nameController.text = widget.initialData!.name;
      _selectedGender = widget.initialData!.gender;
      _birthDate = widget.initialData!.birthDate;
      _selectedRelation = widget.initialData!.relation;
      _selectedInterests.addAll(widget.initialData!.interests);
      _notesController.text = widget.initialData!.notes ?? '';
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipient == null ? 'Nuovo Destinatario' : 'Modifica Destinatario'),
      ),
      body: BlocListener<RecipientsBloc, RecipientsState>(
        listener: (context, state) {
          if (state is RecipientSaved) {
            // Mostra messaggio di successo e torna indietro
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Destinatario ${widget.recipient == null ? 'aggiunto' : 'aggiornato'} con successo'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is RecipientsError) {
            // Mostra messaggio di errore
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome (obbligatorio)
                AppTextField(
                  label: 'Nome',
                  hint: 'Inserisci il nome del destinatario',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Il nome è obbligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spaceL),
                
                // Genere (obbligatorio)
                Text(
                  'Genere',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.spaceS),
                Wrap(
                  spacing: AppTheme.spaceS,
                  children: _genderOptions.map((option) {
                    return ChoiceChip(
                      label: Text(option['label']!),
                      selected: _selectedGender == option['value'],
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedGender = option['value']!;
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppTheme.spaceL),
                
                // Data di nascita (obbligatoria)
                Text(
                  'Data di nascita',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.spaceS),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _birthDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    
                    if (date != null) {
                      setState(() {
                        _birthDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spaceM),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: AppTheme.spaceM),
                        Text(
                          '${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceL),
                
                // Relazione
                Text(
                  'Relazione',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.spaceS),
                Wrap(
                  spacing: AppTheme.spaceS,
                  children: _relationOptions.map((relation) {
                    return ChoiceChip(
                      label: Text(_relationLabels[relation] ?? relation),
                      selected: _selectedRelation == relation,
                      onSelected: (selected) {
                        setState(() {
                          _selectedRelation = selected ? relation : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppTheme.spaceL),
                
                // Interessi
                Text(
                  'Interessi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.spaceS),
                Wrap(
                  spacing: AppTheme.spaceS,
                  children: _interests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return FilterChip(
                      label: Text(interest),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedInterests.add(interest);
                          } else {
                            _selectedInterests.remove(interest);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppTheme.spaceL),
                
                // Note
                AppTextField(
                  label: 'Note',
                  hint: 'Aggiungi note o promemoria su questo destinatario',
                  controller: _notesController,
                  maxLines: 3,
                ),
                const SizedBox(height: AppTheme.spaceXL),
                
                // Pulsante Salva
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<RecipientsBloc, RecipientsState>(
                    builder: (context, state) {
                      return AppButton(
                        text: widget.recipient == null ? 'Aggiungi' : 'Salva Modifiche',
                        isLoading: state is RecipientsLoading,
                        onPressed: _saveRecipient,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _saveRecipient() {
    if (_formKey.currentState?.validate() ?? false) {
      final recipient = Recipient(
        id: widget.recipient?.id ?? -1, // Il backend assegnerà un ID valido
        name: _nameController.text,
        gender: _selectedGender,
        birthDate: _birthDate,
        relation: _selectedRelation,
        interests: _selectedInterests,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null, favoriteColors: [],
      );
      
      if (widget.recipient == null) {
        // Aggiungi nuovo destinatario
        context.read<RecipientsBloc>().add(AddRecipientEvent(recipient));
      } else {
        // Aggiorna destinatario esistente
        context.read<RecipientsBloc>().add(UpdateRecipientEvent(recipient));
      }
    }
  }
}