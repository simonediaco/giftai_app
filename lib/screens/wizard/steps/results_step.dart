import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/auth/auth_bloc.dart';
import 'package:giftai/blocs/auth/auth_state.dart';
import 'package:giftai/blocs/gift/gift_bloc.dart';
import 'package:giftai/blocs/gift/gift_event.dart';
import 'package:giftai/models/gift_model.dart';
import 'package:giftai/screens/auth/login_screen.dart';
import 'package:giftai/services/firebase_service.dart';
import 'package:giftai/widgets/gift/gift_result_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultsStep extends StatefulWidget {
  final List<Gift> gifts;
  final VoidCallback onBackToHome;

  const ResultsStep({
    super.key,
    required this.gifts,
    required this.onBackToHome,
  });

  @override
  State<ResultsStep> createState() => _ResultsStepState();
}

class _ResultsStepState extends State<ResultsStep> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  @override
  void initState() {
    super.initState();
    // FirebaseService.logEvent(
    //   name: 'view_gift_results',
    //   parameters: {'results_count': widget.gifts.length},
    // );
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Future<void> _launchAmazonUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossibile aprire Amazon')),
        );
      }
    }
  }
  
  void _shareGift(Gift gift) {
    Share.share(
      'Ho trovato questo regalo con GiftAI: ${gift.name}\n\nVedi su Amazon: ${gift.getAmazonUrl()}',
      subject: 'Idea regalo da GiftAI',
    );
    
    // FirebaseService.logEvent(
    //   name: 'share_gift',
    //   parameters: {'gift_name': gift.name},
    // );
  }
  
  void _saveGift(Gift gift) {
    // Verifica se l'utente è autenticato
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      // Salva il regalo
      // context.read<GiftBloc>().add(GiftSaveRequested(gift: gift));
      
      // FirebaseService.logEvent(
      //   name: 'save_gift',
      //   parameters: {'gift_name': gift.name},
      // );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Regalo salvato con successo')),
      );
    } else {
      // Mostra dialog per invitare l'utente a registrarsi
      _showLoginRequiredDialog();
    }
  }
  
  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accesso richiesto'),
        content: const Text(
          'Per salvare i regali devi essere registrato. Vuoi accedere o registrarti ora?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non ora'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Accedi'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.gifts.isEmpty) {
      return _buildEmptyResults();
    }
    
    return Column(
      children: [
        // Indicatore pagina
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.gifts.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[300],
                ),
              );
            }),
          ),
        ),
        
        // Card regali
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.gifts.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final gift = widget.gifts[index];
              return GiftResultCard(
                gift: gift,
                onSave: () => _saveGift(gift),
                onShare: () => _shareGift(gift),
                onViewOnAmazon: () => _launchAmazonUrl(gift.getAmazonUrl()),
              );
            },
          ),
        ),
        
        // Pulsanti footer
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back_ios),
                    color: _currentPage > 0 ? null : Colors.grey[400],
                  ),
                  const SizedBox(width: 24),
                  Text(
                    '${_currentPage + 1} di ${widget.gifts.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: _currentPage < widget.gifts.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: _currentPage < widget.gifts.length - 1 ? null : Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Pulsante per tornare alla home
              OutlinedButton(
                onPressed: widget.onBackToHome,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Torna alla Home'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Nessun risultato trovato',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Prova a modificare i filtri o ampliare i tuoi interessi per ottenere più risultati',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: widget.onBackToHome,
              child: const Text('Torna alla Home'),
            ),
          ],
        ),
      ),
    );
  }
}