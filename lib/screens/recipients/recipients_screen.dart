import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/gift/gift_bloc.dart';
import '../../blocs/gift/gift_event.dart';
import '../../models/recipient_model.dart';
import '../../utils/translations.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/home/recipient_card.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_message.dart';
import '../gifts/gift_generation_wizard.dart';
import '../gifts/quick_gift_generation_screen.dart';

class RecipientsScreen extends StatefulWidget {
  const RecipientsScreen({Key? key}) : super(key: key);

  @override
  State<RecipientsScreen> createState() => _RecipientsScreenState();
}

class _RecipientsScreenState extends State<RecipientsScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  List<Recipient> _recipients = [];

  @override
  void initState() {
    super.initState();
    _loadRecipients();
  }

  Future<void> _loadRecipients() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    // TODO: Implementare il repository per i destinatari
    // Per ora usiamo dati di esempio
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simula una chiamata API
      
      // Genera dati di esempio
      final dummyRecipients = [
        Recipient(
          id: 1,
          name: "Marco",
          relation: RelationshipTranslations.getAllUiValues()[0], // Amico
          gender: "male",
          age: 28,
          interests: ["Tecnologia", "Musica", "Sport"],
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Recipient(
          id: 2,
          name: "Laura",
          relation: RelationshipTranslations.getAllUiValues()[1], // Familiare
          gender: "female",
          age: 35,
          interests: ["Libri", "Arte", "Viaggi"],
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        Recipient(
          id: 3,
          name: "Giovanni",
          relation: RelationshipTranslations.getAllUiValues()[2], // Partner
          gender: "male",
          age: 42,
          interests: ["Cucina", "Cinema", "Sport"],
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ];

      setState(() {
        _recipients = dummyRecipients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _onGenerateIdeasForRecipient(Recipient recipient) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuickGiftGenerationScreen(recipient: recipient),
      ),
    );
  }

  void _onAddNewRecipient() {
    // Naviga alla schermata di creazione destinatario
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GiftGenerationWizard(),
      ),
    );
  }

  void _onEditRecipient(Recipient recipient) {
    // TODO: Implementare la logica di modifica destinatario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modifica ${recipient.name} - Funzionalità in arrivo')),
    );
  }

  void _onDeleteRecipient(Recipient recipient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina destinatario'),
        content: Text('Sei sicuro di voler eliminare ${recipient.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementare la logica di eliminazione
              Navigator.of(context).pop();
              setState(() {
                _recipients.removeWhere((r) => r.id == recipient.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${recipient.name} eliminato con successo')),
              );
            },
            child: const Text('Elimina'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: LoadingIndicator(
          message: 'Caricamento destinatari...',
        ),
      );
    }

    if (_hasError) {
      return ErrorMessage(
        message: _errorMessage ?? 'Errore nel caricamento dei destinatari',
        onRetry: _loadRecipients,
      );
    }

    if (_recipients.isEmpty) {
      return EmptyState(
        icon: Icons.people,
        title: 'Nessun destinatario',
        message: 'Aggiungi un destinatario per iniziare a generare idee regalo personalizzate',
        actionText: 'Aggiungi destinatario',
        onActionPressed: _onAddNewRecipient,
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadRecipients,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _recipients.length,
          itemBuilder: (context, index) {
            final recipient = _recipients[index];
            return RecipientCard(
              recipient: recipient,
              onTap: () => _onGenerateIdeasForRecipient(recipient),
              onEdit: () => _onEditRecipient(recipient),
              onDelete: () => _onDeleteRecipient(recipient),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddNewRecipient,
        child: const Icon(Icons.person_add),
        tooltip: 'Aggiungi destinatario',
      ),
    );
  }
}