// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_loading_enhanced.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/golden_accents.dart';

class StepLoadingEnhanced extends StatefulWidget {
  const StepLoadingEnhanced({Key? key}) : super(key: key);

  @override
  State<StepLoadingEnhanced> createState() => _StepLoadingEnhancedState();
}

class _StepLoadingEnhancedState extends State<StepLoadingEnhanced> 
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _sparkleController;
  int _currentTextIndex = 0;
  
  final List<String> _loadingTexts = [
    'Consultando il database dei regali perfetti...',
    'Analizzando le preferenze...',
    'Cercando idee creative...',
    'Applicando la magia di Donatello...',
    'Quasi fatto, preparo le migliori proposte...',
  ];

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _startTextAnimation();
  }
  
  void _startTextAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _loadingTexts.length;
        });
        _startTextAnimation();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Illustrazione personalizzata o animazione
        Stack(
          alignment: Alignment.center,
          children: [
            // Cerchio di sfondo con gradiente
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.1),
                    theme.colorScheme.secondary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            
            // Immagine o Lottie centrale
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Prova prima con Lottie, poi fallback su immagine statica
                  Lottie.asset(
                    'assets/animations/gift_loading.json',
                    width: 180,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback: immagine statica con rotazione
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value * 2 * 3.14159,
                            child: Image.asset(
                              'assets/images/donatello_chisel.png',
                              width: 150,
                              height: 150,
                              errorBuilder: (context, error, stackTrace) {
                                // Ultimo fallback: icona animata
                                return _buildFallbackAnimation();
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  
                  // Particelle dorate animate intorno
                  ...List.generate(6, (index) {
                    return AnimatedBuilder(
                      animation: _sparkleController,
                      builder: (context, child) {
                        final angle = (index * 60) * 3.14159 / 180;
                        final radius = 90 + (10 * _sparkleController.value);
                        return Transform.translate(
                          offset: Offset(
                            radius * 1.0 * angle.round(),
                            radius * 1.0 * angle.round(),
                          ),
                          child: Transform.scale(
                            scale: 0.5 + (0.5 * _sparkleController.value),
                            child: GoldenAccents.goldenIcon(
                              Icons.auto_awesome,
                              size: 16,
                              withGlow: true,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppTheme.spaceXL),
        
        // Progress bar elegante
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 8),
            builder: (context, value, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: GoldenAccents.goldGradient,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: GoldenAccents.primary.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: AppTheme.spaceL),
        
        // Testo dinamico
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: Text(
            _loadingTexts[_currentTextIndex],
            key: ValueKey(_currentTextIndex),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: AppTheme.spaceM),
        
        // Suggerimento mentre carica
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceL,
            vertical: AppTheme.spaceM,
          ),
          margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceL),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spaceM),
              Expanded(
                child: Text(
                  'Suggerimento: più dettagli inserisci, più precisi saranno i risultati!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildFallbackAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.white,
              size: 60,
            ),
          ),
        );
      },
    );
  }
}