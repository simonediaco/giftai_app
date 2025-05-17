import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/recipients_bloc.dart';
import '../bloc/recipients_event.dart';
import '../bloc/recipients_state.dart';
import '../widgets/recipient_card.dart';
import 'add_recipient_page.dart';

class RecipientsPage extends StatefulWidget {
  static const routeName = '/recipients';
  
  const RecipientsPage({Key? key}) : super(key: key);

  @override
  State<RecipientsPage> createState() => _RecipientsPageState();
}

class _RecipientsPageState extends State<RecipientsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecipientsBloc>().add(FetchRecipients());
  }

  void _showDeleteConfirmation(BuildContext context, int recipientId, String recipientName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: Text('Sei sicuro di voler eliminare $recipientName dalla tua lista di destinatari?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Chiudi il dialog
            },
            child: const Text('Annulla'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              // Chiudi il dialog e procedi con l'eliminazione
              Navigator.of(ctx).pop();
              context.read<RecipientsBloc>().add(DeleteRecipientEvent(recipientId));
            },
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('I miei Destinatari'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementare ricerca
            },
          ),
        ],
      ),
      body: BlocBuilder<RecipientsBloc, RecipientsState>(
        builder: (context, state) {
          if (state is RecipientsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipientsLoaded) {
            final recipients = state.recipients;
            
            if (recipients.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    Text(
                      'Nessun destinatario',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    const Text(
                      'Aggiungi i tuoi amici, familiari e colleghi\nper trovare regali personalizzati',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spaceXL),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddRecipientPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Aggiungi Destinatario'),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              itemCount: recipients.length,
              itemBuilder: (context, index) {
                final recipient = recipients[index];
                return RecipientCard(
                  recipient: recipient,
                  onTap: () {
                    // Apri dettaglio destinatario o modifica
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddRecipientPage(recipient: recipient),
                      ),
                    );
                  },
                  onDelete: () {
                    // Mostra dialog di conferma prima di eliminare
                    _showDeleteConfirmation(context, recipient.id, recipient.name);
                  },
                );
              },
            );
          } else if (state is RecipientsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: AppTheme.spaceM),
                  Text('Errore: ${state.message}'),
                  const SizedBox(height: AppTheme.spaceL),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<RecipientsBloc>().add(FetchRecipients());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Riprova'),
                  ),
                ],
              ),
            );
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddRecipientPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}