import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/gift/gift_bloc.dart';
import 'package:giftai/blocs/gift/gift_event.dart';
import 'package:giftai/blocs/recipient/recipient_bloc.dart';
import 'package:giftai/blocs/recipient/recipient_event.dart';
import 'package:giftai/blocs/recipient/recipient_state.dart';
import 'package:giftai/models/recipient_model.dart';
import 'package:giftai/screens/recipient/recipient_form_screen.dart';
import 'package:giftai/screens/wizard/wizard_screen.dart';
import 'package:intl/intl.dart';

class RecipientDetailScreen extends StatefulWidget {
  final int recipientId;

  const RecipientDetailScreen({
    super.key,
    required this.recipientId,
  });

  @override
  State<RecipientDetailScreen> createState() => _RecipientDetailScreenState();
}

class _RecipientDetailScreenState extends State<RecipientDetailScreen> {
  @override
  void initState() {
    super.initState();
    
    // Carica i dettagli del destinatario
    context.read<RecipientBloc>().add(
      RecipientDetailRequested(id: widget.recipientId),
    );
  }
  
  void _deleteRecipient(RecipientModel recipient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina destinatario'),
        content: Text('Sei sicuro di voler eliminare ${recipient.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<RecipientBloc>().add(
                RecipientDeleteRequested(id: recipient.id!),
              );
              Navigator.pop(context); // Chiudi il dialog
              Navigator.pop(context); // Torna alla pagina precedente
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }
  
  void _generateGifts(int recipientId) {
    // Naviga alla schermata del wizard semplificata
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WizardScreen(),
      ),
    );
    
    // Oppure, genera direttamente idee regalo con un budget e categoria predefiniti
    // context.read<GiftBloc>().add(
    //   GiftGenerateForRecipientRequested(
    //     recipientId: recipientId,
    //     category: 'Tech',
    //     budget: '50-100€',
    //   ),
    // );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Destinatario'),
        actions: [
          BlocBuilder<RecipientBloc, RecipientState>(
            builder: (context, state) {
              if (state is RecipientDetailSuccess) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipientFormScreen(
                            recipient: state.recipient,
                          ),
                        ),
                      );
                    } else if (value == 'delete') {
                      _deleteRecipient(state.recipient);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Modifica'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Elimina', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<RecipientBloc, RecipientState>(
        builder: (context, state) {
          if (state is RecipientLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is RecipientDetailFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Errore: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RecipientBloc>().add(
                        RecipientDetailRequested(id: widget.recipientId),
                      );
                    },
                    child: const Text('Riprova'),
                  ),
                ],
              ),
            );
          }
          
          if (state is RecipientDetailSuccess) {
            final recipient = state.recipient;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intestazione
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: Text(
                          recipient.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Nome e info principali
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipient.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recipient.relation,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recipient.age != null
                                  ? '${recipient.age} anni'
                                  : recipient.birthDate != null
                                      ? '${DateTime.now().year - recipient.birthDate!.year} anni'
                                      : 'Età non specificata',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Pulsante per generare idee regalo
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _generateGifts(recipient.id!),
                      icon: const Icon(Icons.card_giftcard),
                      label: const Text('Genera Idee Regalo'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Dettagli destinatario
                  const Text(
                    'Informazioni',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Genere
                  _buildInfoRow(
                    context,
                    icon: Icons.person,
                    title: 'Genere',
                    value: recipient.gender,
                  ),
                  
                  // Data di nascita
                  if (recipient.birthDate != null)
                    _buildInfoRow(
                      context,
                      icon: Icons.cake,
                      title: 'Data di nascita',
                      value: DateFormat.yMMMMd().format(recipient.birthDate!),
                    ),
                  
                  // Età
                  if (recipient.age != null)
                    _buildInfoRow(
                      context,
                      icon: Icons.cake,
                      title: 'Età',
                      value: '${recipient.age} anni',
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Interessi
                  if (recipient.interests.isNotEmpty) ...[
                    const Text(
                      'Interessi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recipient.interests.map((interest) {
                        return Chip(
                          label: Text(interest),
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                  
                  // Colori preferiti
                  if (recipient.favoriteColors.isNotEmpty) ...[
                    const Text(
                      'Colori preferiti',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recipient.favoriteColors.map((color) {
                        return Chip(
                          label: Text(color),
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                  
                  // Non graditi
                  if (recipient.dislikes.isNotEmpty) ...[
                    const Text(
                      'Non graditi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recipient.dislikes.map((dislike) {
                        return Chip(
                          label: Text(dislike),
                          backgroundColor: Colors.red[100],
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                  
                  // Note
                  if (recipient.notes != null && recipient.notes!.isNotEmpty) ...[
                    const Text(
                      'Note',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(recipient.notes!),
                    ),
                  ],
                ],
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
  
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}