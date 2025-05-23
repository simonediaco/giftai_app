// lib/features/gift_ideas/presentation/widgets/gift_result_list_enhanced.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/golden_accents.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../../features/recipients/domain/entities/recipient.dart';
import '../../../../features/recipients/presentation/bloc/recipients_bloc.dart';
import '../../../../features/recipients/presentation/bloc/recipients_event.dart';
import '../../../../features/recipients/presentation/pages/add_recipient_page.dart';
import '../../domain/entities/gift.dart';
import '../bloc/gift_ideas_bloc.dart';
import '../bloc/gift_ideas_event.dart';
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
  int _displayedGifts = 5; // Inizia mostrando 5 regali
  bool _isLoadingMore = false;
  
  void _loadMoreGifts() async {
    if (_displayedGifts >= widget.gifts.length) {
      // Se abbiamo già mostrato tutti i regali disponibili
      _showNoMoreResultsDialog();
      return;
    }
    
    setState(() {
      _isLoadingMore = true;
    });
    
    // Simula un piccolo delay per mostrare il loading
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _displayedGifts = (_displayedGifts + 5).clamp(0, widget.gifts.length);
      _isLoadingMore = false;
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
        title: Row(
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppTheme.spaceM),
            const Expanded(
              child: Text('Non hai trovato il regalo perfetto?'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mi dispiace che non abbia ancora trovato l\'idea giusta! 🎨',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: AppTheme.spaceM),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
              ),
              child: Text(
                'Suggerimento: Prova ad aggiungere più dettagli come interessi specifici, '
                'hobbies o passioni particolari per ottenere risultati più mirati!',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            if (isAuthenticated && widget.wizardData != null) ...[
              const SizedBox(height: AppTheme.spaceM),
              const Text(
                'Vuoi salvare questo destinatario e riprovare con più informazioni?',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Rimani qui'),
          ),
          if (isAuthenticated && widget.wizardData != null)
            GoldenAccents.premiumButton(
              text: 'Nuova ricerca',
              icon: Icons.refresh,
              onPressed: () {
                Navigator.of(ctx).pop();
                _startNewSearchWithRecipient();
              },
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(); // Torna al wizard
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Riprova'),
            ),
        ],
      ),
    );
  }
  
  void _startNewSearchWithRecipient() {
    if (widget.wizardData == null) return;
    
    // Crea un destinatario temporaneo con i dati del wizard
    final tempRecipient = Recipient(
      id: -1, // ID temporaneo
      name: widget.wizardData!.name ?? 'Destinatario',
      gender: widget.wizardData!.gender,
      birthDate: DateTime(DateTime.now().year - (widget.wizardData!.age ?? 30)),
      relation: widget.wizardData!.relation,
      interests: widget.wizardData!.interests,
    );
    
    // Naviga alla pagina di aggiunta destinatario
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AddRecipientPage(
          initialData: tempRecipient,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleGifts = widget.gifts.take(_displayedGifts).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le tue idee regalo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: 'Nuova ricerca',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con risultati e animazione
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer.withOpacity(0.3),
                  theme.colorScheme.secondaryContainer.withOpacity(0.2),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppTheme.borderRadiusXL),
                bottomRight: Radius.circular(AppTheme.borderRadiusXL),
              ),
            ),
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spaceM),
                            decoration: BoxDecoration(
                              gradient: GoldenAccents.goldGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: GoldenAccents.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.celebration,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spaceM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ecco le mie proposte!',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Ho selezionato ${widget.gifts.length} idee regalo per te',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                // Contatore regali visualizzati
                const SizedBox(height: AppTheme.spaceM),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceM,
                    vertical: AppTheme.spaceS,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppTheme.spaceS),
                      Text(
                        'Stai visualizzando $_displayedGifts di ${widget.gifts.length} risultati',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Banner salvataggio destinatario (se applicabile)
                if (widget.wizardData != null && context.read<AuthBloc>().state is Authenticated)
                  Container(
                    margin: const EdgeInsets.only(top: AppTheme.spaceM),
                    padding: const EdgeInsets.all(AppTheme.spaceM),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                      border: Border.all(
                        color: GoldenAccents.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        GoldenAccents.goldenIcon(Icons.person_add, size: 24),
                        const SizedBox(width: AppTheme.spaceM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Salva questo destinatario',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Per generare altri regali in futuro',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => _showSaveRecipientDialog(context),
                          child: const Text('Salva'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Lista regali con animazione
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              itemCount: visibleGifts.length + (_displayedGifts < widget.gifts.length ? 1 : 0),
              itemBuilder: (context, index) {
                // Bottone "Carica altri"
                if (index == visibleGifts.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceL),
                    child: Center(
                      child: _isLoadingMore
                          ? const CircularProgressIndicator()
                          : GoldenAccents.premiumButton(
                              text: 'Mostra altri regali',
                              icon: Icons.expand_more,
                              onPressed: _loadMoreGifts,
                            ),
                    ),
                  );
                }
                
                // Card regalo con animazione di entrata
                return TweenAnimationBuilder<double>(
                  key: ValueKey(visibleGifts[index].id),
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: GiftCard(gift: visibleGifts[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      
      // FAB per salvare tutti
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funzionalità in arrivo! Salveremo tutti i regali preferiti'),
              backgroundColor: AppTheme.infoColor,
            ),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.favorite_border),
        label: const Text('Salva preferiti'),
      ),
    );
  }
  
  void _showSaveRecipientDialog(BuildContext context) {
    if (widget.wizardData == null) return;
    
    final initialData = Recipient(
      id: -1,
      name: widget.wizardData!.name ?? 'Destinatario',
      gender: widget.wizardData!.gender,
      birthDate: DateTime(DateTime.now().year - (widget.wizardData!.age ?? 30)),
      relation: widget.wizardData!.relation,
      interests: widget.wizardData!.interests,
    );
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
        ),
        title: Row(
          children: [
            GoldenAccents.goldenIcon(Icons.person_add),
            const SizedBox(width: AppTheme.spaceM),
            const Text('Salvare destinatario?'),
          ],
        ),
        content: const Text(
          'Salvando questo destinatario potrai generare nuove idee regalo in futuro senza dover reinserire tutti i dati.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Dopo'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddRecipientPage(
                    initialData: initialData,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text('Salva ora'),
          ),
        ],
      ),
    );
  }
}