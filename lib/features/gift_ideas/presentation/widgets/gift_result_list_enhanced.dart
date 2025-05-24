// lib/features/gift_ideas/presentation/widgets/gift_result_list_enhanced.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/golden_accents.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/recipients/domain/entities/recipient.dart';
import '../../../../features/recipients/presentation/pages/add_recipient_page.dart';
import '../../domain/entities/gift.dart';
import '../models/gift_wizard_data.dart';
import 'gift_card.dart';

class GiftResultListEnhanced extends StatefulWidget {
  final List<Gift> gifts;
  final GiftWizardData? wizardData;
  
  const GiftResultListEnhanced({
    Key? key,
    required this.gifts,
    this.wizardData,
  }) : super(key: key);

  @override
  State<GiftResultListEnhanced> createState() => _GiftResultListEnhancedState();
}

class _GiftResultListEnhancedState extends State<GiftResultListEnhanced> {
  int _displayedGifts = 4; // Mostra inizialmente 4 regali
  bool _showingAll = false;
  
  void _loadMoreGifts() {
    setState(() {
      _displayedGifts = widget.gifts.length; // Mostra tutti (8)
      _showingAll = true;
    });
  }
  
  void _showNoMoreResultsDialog() {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState is Authenticated;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icona triste
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              ),
              child: const Center(
                child: Text(
                  '😔',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceL),
            
            Text(
              'Non hai trovato il regalo perfetto?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spaceM),
            
            Text(
              isAuthenticated 
                  ? 'Vuoi salvare questo destinatario e fare una nuova ricerca con criteri diversi?'
                  : 'Vuoi fare una nuova ricerca con criteri diversi?',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No, rimani qui'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (isAuthenticated && widget.wizardData != null) {
                _saveRecipientAndSearch();
              } else {
                _startNewSearch();
              }
            },
            child: Text(isAuthenticated ? 'Sì, salva e riprova' : 'Sì, nuova ricerca'),
          ),
        ],
      ),
    );
  }
  
  void _saveRecipientAndSearch() {
    if (widget.wizardData == null) return;
    
    final recipient = Recipient(
      id: -1,
      name: widget.wizardData!.name ?? 'Destinatario',
      gender: widget.wizardData!.gender ?? 'N',
      birthDate: DateTime(DateTime.now().year - (widget.wizardData!.age ?? 30)),
      relation: widget.wizardData!.relation ?? 'altro',
      interests: widget.wizardData!.interests,
      favoriteColors: [],
      notes: '',
    );
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AddRecipientPage(
          initialData: recipient,
        ),
      ),
    );
  }
  
  void _startNewSearch() {
    Navigator.of(context).pop(); // Chiude la pagina risultati
    Navigator.of(context).pushReplacementNamed('/gift-wizard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleGifts = widget.gifts.take(_displayedGifts).toList();
    final isAuthenticated = context.read<AuthBloc>().state is Authenticated;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idee Regalo'),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            tooltip: 'Torna alla Home',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con info destinatario
          if (widget.wizardData != null)
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer.withOpacity(0.3),
                    theme.colorScheme.secondaryContainer.withOpacity(0.2),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: AppTheme.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Regalo per ${widget.wizardData!.name ?? "destinatario"}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Budget: €${widget.wizardData!.minPrice ?? 0} - €${widget.wizardData!.maxPrice ?? 100}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isAuthenticated)
                    TextButton.icon(
                      onPressed: () {
                        if (widget.wizardData != null) {
                          final recipient = Recipient(
                            id: -1,
                            name: widget.wizardData!.name ?? 'Destinatario',
                            gender: widget.wizardData!.gender ?? 'N',
                            birthDate: DateTime(DateTime.now().year - (widget.wizardData!.age ?? 30)),
                            relation: widget.wizardData!.relation ?? 'altro',
                            interests: widget.wizardData!.interests,
                            favoriteColors: [],
                            notes: '',
                          );
                          
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddRecipientPage(
                                initialData: recipient,
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.person_add, size: 20),
                      label: const Text('Salva'),
                    ),
                ],
              ),
            ),
          
          // Contatore risultati
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            child: Text(
              'Mostrando $_displayedGifts di ${widget.gifts.length} risultati',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Lista regali
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceM),
              itemCount: visibleGifts.length + (_showingAll ? 0 : 1),
              itemBuilder: (context, index) {
                // Bottone "Mostra altri"
                if (index == visibleGifts.length && !_showingAll) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceL),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: _loadMoreGifts,
                        icon: const Icon(Icons.expand_more),
                        label: Text('Mostra altri ${widget.gifts.length - _displayedGifts} regali'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spaceXL,
                            vertical: AppTheme.spaceM,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                
                // Card regalo
                final gift = visibleGifts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
                  child: GiftCard(
                    gift: gift,
                    onSave: isAuthenticated ? () {
                      // TODO: Implementare salvataggio regalo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funzionalità in arrivo!'),
                          backgroundColor: AppTheme.infoColor,
                        ),
                      );
                    } : null,
                  ),
                );
              },
            ),
          ),
          
          // Footer con azioni
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Bottone "Non hai trovato?" (solo quando sono mostrati tutti)
                if (_showingAll)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
                    child: TextButton.icon(
                      onPressed: _showNoMoreResultsDialog,
                      icon: const Icon(Icons.sentiment_dissatisfied),
                      label: const Text('Non hai trovato il regalo giusto?'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                
                // Bottone nuova ricerca
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _startNewSearch,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Nuova ricerca'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      padding: const EdgeInsets.all(AppTheme.spaceM),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}