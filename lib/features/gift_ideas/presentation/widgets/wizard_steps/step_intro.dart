// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_intro.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/golden_accents.dart';

class StepIntro extends StatefulWidget {
  final VoidCallback onComplete;

  const StepIntro({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepIntro> createState() => _StepIntroState();
}

class _StepIntroState extends State<StepIntro> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: screenHeight,
          padding: const EdgeInsets.all(AppTheme.spaceL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              
              // Logo/Illustrazione compatta
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 80,
                          color: theme.colorScheme.primary,
                        ),
                        // Sparkle in alto a destra
                        Positioned(
                          top: 20,
                          right: 20,
                          child: GoldenAccents.goldenIcon(
                            Icons.auto_awesome,
                            size: 24,
                            withGlow: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppTheme.spaceXL),
              
              // Titolo
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Trova il regalo perfetto',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: AppTheme.spaceM),
              
              // Sottotitolo breve
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Rispondi a poche domande e ti suggerirò\nidee regalo personalizzate',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Bottone prominente
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXL),
                      ),
                      elevation: 8,
                      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Inizia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spaceM),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppTheme.spaceXL),
            ],
          ),
        );
      },
    );
  }
}