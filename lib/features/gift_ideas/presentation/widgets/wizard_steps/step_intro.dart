// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_intro.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/golden_accents.dart';
import '../../../../../shared/widgets/app_button.dart';

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
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
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
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceL),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spaceXL),
                  
                  // Illustrazione o Lottie animation
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Immagine statica o Lottie
                        Image.asset(
                          'assets/images/gift_wizard_intro.png',
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback se l'immagine non esiste
                            return Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary.withOpacity(0.3),
                                    theme.colorScheme.secondary.withOpacity(0.3),
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.card_giftcard,
                                size: 80,
                                color: theme.colorScheme.primary,
                              ),
                            );
                          },
                        ),
                        
                        // Particelle dorate animate
                        ...List.generate(3, (index) {
                          return Positioned(
                            top: 50 + (index * 40).toDouble(),
                            right: 40 + (index * 30).toDouble(),
                            child: _buildSparkle(index * 0.3),
                          );
                        }),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spaceXL),
                  
                  // Titolo con effetto oro
                  Text(
                    '🎨 Benvenuto nel laboratorio di Donatello!',
                    style: GoldenAccents.goldenText(
                      theme.textTheme.headlineSmall!,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppTheme.spaceL),
                  
                  // Descrizione
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spaceL),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                      border: Border.all(
                        color: GoldenAccents.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Creeremo insieme il regalo perfetto!',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spaceM),
                        Text(
                          'Ti farò alcune domande per conoscere meglio la persona a cui vuoi fare un regalo.',
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spaceL),
                        
                        // Lista dei passi con icone
                        _buildStepItem(
                          context,
                          icon: Icons.cake,
                          title: 'Età e genere',
                          description: 'Per capire le preferenze generali',
                        ),
                        _buildStepItem(
                          context,
                          icon: Icons.favorite,
                          title: 'Relazione',
                          description: 'Per scegliere il tono giusto',
                        ),
                        _buildStepItem(
                          context,
                          icon: Icons.interests,
                          title: 'Interessi',
                          description: 'Per personalizzare le idee',
                        ),
                        _buildStepItem(
                          context,
                          icon: Icons.euro,
                          title: 'Budget',
                          description: 'Per trovare il prezzo perfetto',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spaceXL),
                  
                  // Info privacy
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceM,
                      vertical: AppTheme.spaceS,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppTheme.spaceS),
                        Expanded(
                          child: Text(
                            'I tuoi dati sono al sicuro e non verranno condivisi',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spaceXL),
                  
                  // Bottone per iniziare
                  GoldenAccents.premiumButton(
                    text: 'Iniziamo!',
                    icon: Icons.arrow_forward,
                    onPressed: widget.onComplete,
                  ),
                  
                  const SizedBox(height: AppTheme.spaceL),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppTheme.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkle(double delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1500 + (delay * 1000).toInt()),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GoldenAccents.goldenIcon(
            Icons.auto_awesome,
            size: 16,
            withGlow: true,
          ),
        );
      },
    );
  }
}