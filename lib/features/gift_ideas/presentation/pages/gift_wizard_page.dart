// lib/features/gift_ideas/presentation/pages/gift_wizard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../recipients/domain/entities/recipient.dart';
import '../bloc/gift_ideas_bloc.dart';
import '../bloc/gift_ideas_event.dart';
import '../bloc/gift_ideas_state.dart';
import '../models/gift_wizard_data.dart';
import '../widgets/gift_result_list_enhanced.dart';
import '../widgets/wizard_steps/step_gender_enhanced.dart';
import '../widgets/wizard_steps/step_interests_enhanced.dart';
import '../widgets/wizard_steps/step_intro.dart';
import '../widgets/wizard_steps/step_age.dart';
import '../widgets/wizard_steps/step_gender.dart';
import '../widgets/wizard_steps/step_budget.dart';
import '../widgets/wizard_steps/step_category.dart';
import '../widgets/wizard_steps/step_interests.dart';
import '../widgets/wizard_steps/step_loading_enhanced.dart';
import '../widgets/wizard_steps/step_relation.dart';
import '../widgets/wizard_steps/step_relation_enhanced.dart';

class GiftWizardPage extends StatefulWidget {
  static const routeName = '/gift-wizard';

  const GiftWizardPage({Key? key, Recipient? initialRecipient}) : super(key: key);

  @override
  State<GiftWizardPage> createState() => _GiftWizardPageState();
}

class _GiftWizardPageState extends State<GiftWizardPage> with SingleTickerProviderStateMixin {
  final _wizardData = GiftWizardData();
  int _currentStep = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 7) { // Aumentato a 7 per includere intro
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Se siamo all'ultimo step, avviamo la generazione
      if (_currentStep == 7) { // Aggiornato a 7
        context.read<GiftIdeasBloc>().add(
          GenerateGiftIdeasRequested(
            name: _wizardData.name,
            gender: _wizardData.gender,
            age: _wizardData.age?.toString(),
            relation: _wizardData.relation,
            interests: _wizardData.interests,
            category: _wizardData.category,
            minPrice: _wizardData.minPrice,
            maxPrice: _wizardData.maxPrice,
          ),
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return ''; // Nessun titolo per l'intro
      case 1:
        return 'Quanti anni ha il destinatario?';
      case 2:
        return 'Qual è il genere del destinatario?';
      case 3:
        return 'Che tipo di relazione avete?';
      case 4:
        return 'Quali sono i suoi interessi?';
      case 5:
        return 'Quale categoria preferisci?';
      case 6:
        return 'Quanto vorresti spendere?';
      case 7:
        return ''; // Nessun titolo per il loading
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GiftIdeasBloc, GiftIdeasState>(
        listener: (context, state) {
          if (state is GiftIdeasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            // Torniamo al passo precedente in caso di errore
            _previousStep();
          }
        },
        builder: (context, state) {
          if (state is GiftIdeasGenerated) {
            // Mostriamo la lista dei regali generati con la versione migliorata
            return GiftResultListEnhanced(
              gifts: state.gifts,
              wizardData: _wizardData,
            );
          }

          return SafeArea(
            child: Column(
              children: [
                // App Bar personalizzata (nascosta per intro e loading)
                if (_currentStep > 0 && _currentStep < 7)
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spaceM),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded),
                          onPressed: _previousStep,
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _currentStep / 7, // Aggiornato a 7
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spaceM),
                        Text(
                          '${_currentStep}/7', // Aggiornato
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                // Titolo dello step corrente
                if (_getStepTitle().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceL,
                      vertical: AppTheme.spaceM,
                    ),
                    child: Text(
                      _getStepTitle(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Contenuto dello step
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Step 0: Introduzione
                      StepIntro(
                        onComplete: _nextStep,
                      ),

                      // Step 1: Età
                      StepAge(
                        wizardData: _wizardData,
                        onComplete: _nextStep,
                      ),

                      // Step 2: Genere
                      StepGenderEnhanced(
                        wizardData: _wizardData,
                        onComplete: _nextStep,
                      ),

                      // Step 3: Relazione
                      StepRelationEnhanced(
                        wizardData: _wizardData,
                        onComplete: _nextStep,
                      ),

                      // Step 4: Interessi
                      StepInterestsEnhanced(
                        wizardData: _wizardData,
                        onComplete: _nextStep,
                      ),

                      // Step 5: Categoria
                      StepCategory(
                        wizardData: _wizardData,
                        onComplete: _nextStep,
                      ),

                      // Step 6: Budget
                      StepBudget(
                        wizardData: _wizardData,
                        onComplete: _nextStep,
                      ),

                      // Step 7: Loading migliorato
                      const StepLoadingEnhanced(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}