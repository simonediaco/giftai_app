import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:giftai/blocs/recipient/recipient_bloc.dart';
import 'package:giftai/blocs/recipient/recipient_event.dart';
import 'package:giftai/blocs/recipient/recipient_state.dart';
import 'package:giftai/models/recipient_model.dart';
import 'package:giftai/widgets/common/primary_button.dart';
import 'package:intl/intl.dart';

class RecipientFormScreen extends StatefulWidget {
  final Recipient? recipient;

  const RecipientFormScreen({
    super.key,
    this.recipient,
  });

  @override
  State<RecipientFormScreen> createState() => _RecipientFormScreenState();
}

class _RecipientFormScreenState extends State<RecipientFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  
  // Lista interessi
  final List<String> _allInterests = [
    'Musica', 'Film', 'Lettura', 'Sport', 'Cucina', 'Tecnologia',
    'Videogiochi', 'Viaggi', 'Arte', 'Moda', 'Fotografia', 'Giardinaggio',
    'Animali', 'Fitness', 'Auto', 'Bellezza', 'Fai da te',
  ];
  
  // Lista colori
  final List<String> _allColors = [
    'Rosso', 'Blu', 'Verde', 'Giallo', 'Arancione',
    'Viola', 'Rosa', 'Nero', 'Bianco', 'Grigio', 'Marrone',
  ];
  
  // Controller per input di testo personalizzati
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _dislikeController = TextEditingController();
  
  @override
  void dispose() {
    _interestController.dispose();
    _colorController.dispose();
    _dislikeController.dispose();
    super.dispose();
  }
  
  void _addCustomInterest() {
    final interest = _interestController.text.trim();
    if (interest.isEmpty) return;
    
    setState(() {
      final currentInterests = _formKey.currentState?.fields['interests']?.value as List<String>? ?? [];
      if (!currentInterests.contains(interest)) {
        _formKey.currentState?.fields['interests']?.didChange([...currentInterests, interest]);
      }
      _interestController.clear();
    });
  }
  
  void _addCustomColor() {
    final color = _colorController.text.trim();
    if (color.isEmpty) return;
    
    setState(() {
      final currentColors = _formKey.currentState?.fields['favorite_colors']?.value as List<String>? ?? [];
      if (!currentColors.contains(color)) {
        _formKey.currentState?.fields['favorite_colors']?.didChange([...currentColors, color]);
      }
      _colorController.clear();
    });
  }
  
  void _addCustomDislike() {
    final dislike = _dislikeController.text.trim();
    if (dislike.isEmpty) return;
    
    setState(() {
      final currentDislikes = _formKey.currentState?.fields['dislikes']?.value as List<String>? ?? [];
      if (!currentDislikes.contains(dislike)) {
        _formKey.currentState?.fields['dislikes']?.didChange([...currentDislikes, dislike]);
      }
      _dislikeController.clear();
    });
  }
  
  void _onSave() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      
      setState(() {
        _isLoading = true;
      });
      
      final recipientModel = Recipient(
        id: widget.recipient?.id,
        name: data['name'],
        gender: data['gender'],
        relation: data['relation'],
        age: data['use_age'] == true ? int.tryParse(data['age']) : null,
        birthDate: data['use_age'] != true ? data['birth_date'] : null,
        interests: List<String>.from(data['interests'] ?? []),
        favoriteColors: List<String>.from(data['favorite_colors'] ?? []),
        dislikes: List<String>.from(data['dislikes'] ?? []),
        notes: data['notes'],
      );
      
      if (widget.recipient != null) {
        // Aggiorna destinatario esistente
        context.read<RecipientBloc>().add(
          RecipientUpdateRequested(recipient: recipientModel),
        );
      } else {
        // Crea nuovo destinatario
        context.read<RecipientBloc>().add(
          RecipientCreateRequested(recipient: recipientModel),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.recipient != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifica Destinatario' : 'Nuovo Destinatario'),
      ),
      body: BlocListener<RecipientBloc, RecipientState>(
        listener: (context, state) {
          if (state is RecipientCreateSuccess || state is RecipientUpdateSuccess) {
            setState(() {
              _isLoading = false;
            });
            
            Navigator.pop(context);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEditing
                      ? 'Destinatario aggiornato con successo'
                      : 'Destinatario creato con successo',
                ),
              ),
            );
          } else if (state is RecipientCreateFailure || state is RecipientUpdateFailure) {
            setState(() {
              _isLoading = false;
            });
            
            final message = state is RecipientCreateFailure
                ? state.message
                : (state as RecipientUpdateFailure).message;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Errore: $message')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'name': widget.recipient?.name ?? '',
              'gender': widget.recipient?.gender ?? 'maschio',
              'relation': widget.recipient?.relation ?? 'amico',
              'interests': widget.recipient?.interests ?? [],
              'favorite_colors': widget.recipient?.favoriteColors ?? [],
              'dislikes': widget.recipient?.dislikes ?? [],
              'notes': widget.recipient?.notes ?? '',
              'use_age': widget.recipient?.age != null || widget.recipient?.birthDate == null,
              'age': widget.recipient?.age?.toString() ?? '',
              'birth_date': widget.recipient?.birthDate,
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informazioni di base',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Nome
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Il nome è obbligatorio'),
                  ]),
                ),
                
                const SizedBox(height: 16),
                
                // Genere
                FormBuilderRadioGroup(
                  name: 'gender',
                  decoration: const InputDecoration(
                    labelText: 'Genere',
                  ),
                  options: const [
                    FormBuilderFieldOption(value: 'M', child: Text('Maschio')),
                    FormBuilderFieldOption(value: 'F', child: Text('Femmina')),
                    FormBuilderFieldOption(value: 'NB', child: Text('Non binario')),
                    FormBuilderFieldOption(value: 'O', child: Text('Altro')),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Relazione
                FormBuilderDropdown(
                  name: 'relation',
                  decoration: const InputDecoration(
                    labelText: 'Relazione',
                    prefixIcon: Icon(Icons.people),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'amico', child: Text('Amico/a')),
                    DropdownMenuItem(value: 'partner', child: Text('Partner')),
                    DropdownMenuItem(value: 'genitore', child: Text('Genitore')),
                    DropdownMenuItem(value: 'figlio', child: Text('Figlio/a')),
                    DropdownMenuItem(value: 'fratello', child: Text('Fratello/Sorella')),
                    DropdownMenuItem(value: 'nonno', child: Text('Nonno/a')),
                    DropdownMenuItem(value: 'collega', child: Text('Collega')),
                    DropdownMenuItem(value: 'altro', child: Text('Altro')),
                  ],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'La relazione è obbligatoria'),
                  ]),
                ),
                
                const SizedBox(height: 16),
                
                // Switcher età/data nascita
                FormBuilderSwitch(
                  name: 'use_age',
                  title: const Text('Specifica l\'età invece della data di nascita'),
                  initialValue: widget.recipient?.age != null || widget.recipient?.birthDate == null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Età o data nascita
                FormBuilderField<bool>(
                  name: 'age_or_date',
                  builder: (FormFieldState field) {
                    final useAge = _formKey.currentState?.fields['use_age']?.value as bool? ?? true;
                    
                    return Column(
                      children: [
                        if (useAge)
                          FormBuilderTextField(
                            name: 'age',
                            decoration: const InputDecoration(
                              labelText: 'Età',
                              prefixIcon: Icon(Icons.cake),
                            ),
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.numeric(errorText: 'Inserisci un numero valido'),
                              FormBuilderValidators.min(0, errorText: 'L\'età non può essere negativa'),
                              FormBuilderValidators.max(120, errorText: 'L\'età non può superare 120 anni'),
                            ]),
                          )
                        else
                          FormBuilderDateTimePicker(
                            name: 'birth_date',
                            inputType: InputType.date,
                            decoration: const InputDecoration(
                              labelText: 'Data di nascita',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            format: DateFormat('dd/MM/yyyy'),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Interessi
                const Text(
                  'Interessi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo per aggiungere interesse personalizzato
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _interestController,
                        decoration: const InputDecoration(
                          labelText: 'Aggiungi interesse personalizzato',
                          hintText: 'Es. Ciclismo, Cucina, ecc.',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: _addCustomInterest,
                      icon: const Icon(Icons.add_circle),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Selezione interessi
                FormBuilderFilterChip(
                  name: 'interests',
                  decoration: const InputDecoration(
                    labelText: 'Seleziona gli interessi',
                  ),
                  options: _allInterests.map((interest) => FormBuilderChipOption(
                    value: interest,
                    child: Text(interest),
                  )).toList(),
                ),
                
                const SizedBox(height: 24),
                
                // Colori preferiti
                const Text(
                  'Colori preferiti',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo per aggiungere colore personalizzato
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _colorController,
                        decoration: const InputDecoration(
                          labelText: 'Aggiungi colore personalizzato',
                          hintText: 'Es. Turchese, Beige, ecc.',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: _addCustomColor,
                      icon: const Icon(Icons.add_circle),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Selezione colori
                FormBuilderFilterChip(
                  name: 'favorite_colors',
                  decoration: const InputDecoration(
                    labelText: 'Seleziona i colori preferiti',
                  ),
                  options: _allColors.map((color) => FormBuilderChipOption(
                    value: color,
                    child: Text(color),
                  )).toList(),
                ),
                
                const SizedBox(height: 24),
                
                // Non graditi
                const Text(
                  'Non graditi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo per aggiungere dislike personalizzato
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dislikeController,
                        decoration: const InputDecoration(
                          labelText: 'Aggiungi cosa non gradisce',
                          hintText: 'Es. Horror, Pesce, ecc.',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: _addCustomDislike,
                      icon: const Icon(Icons.add_circle),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Lista dislikes
                FormBuilderField<List<String>>(
                  name: 'dislikes',
                  builder: (FormFieldState field) {
                    final dislikes = field.value as List<String>? ?? [];
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: dislikes.map((dislike) {
                            return Chip(
                              label: Text(dislike),
                              onDeleted: () {
                                final newList = List<String>.from(dislikes);
                                newList.remove(dislike);
                                field.didChange(newList);
                              },
                              backgroundColor: Colors.red[100],
                              deleteIconColor: Colors.red,
                            );
                          }).toList(),
                        ),
                        if (dislikes.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Nessuna preferenza negativa specificata',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Note
                const Text(
                  'Note',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                FormBuilderTextField(
                  name: 'notes',
                  decoration: const InputDecoration(
                    labelText: 'Note aggiuntive',
                    hintText: 'Inserisci eventuali note o appunti...',
                  ),
                  maxLines: 4,
                ),
                
                const SizedBox(height: 32),
                
                // Pulsante salva
                PrimaryButton(
                  text: isEditing ? 'Aggiorna Destinatario' : 'Crea Destinatario',
                  isLoading: _isLoading,
                  onPressed: _onSave,
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}