import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giftai/blocs/gift/gift_bloc.dart';
import 'package:giftai/blocs/gift/gift_event.dart';
import 'package:giftai/blocs/gift/gift_state.dart';
import 'package:giftai/services/firebase_service.dart';
import 'package:giftai/screens/wizard/steps/budget_step.dart';
import 'package:giftai/screens/wizard/steps/category_step.dart';
import 'package:giftai/screens/wizard/steps/interests_step.dart';
import 'package:giftai/screens/wizard/steps/recipient_info_step.dart';
import 'package:giftai/screens/wizard/steps/results_step.dart';
import 'package:giftai/widgets/common/primary_button.dart';

class WizardScreen extends StatefulWidget {
  final bool isEmbedded;
  
  const WizardScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isGenerating = false;
  
  // Dati del wizard
  String? name;
  int? age;
  String gender = 'maschio';
  String relation = 'amico';
  List<String> interests = [];
  String category = 'Tech';
  String budget = '50-100€';
  
  @override
  void initState() {
    super.initState();
    // FirebaseService.setCurrentScreen('wizard_screen');
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _generateResults();
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
    }
  }
  
  void _generateResults() {
    setState(() {
      _isGenerating = true;
    });
    
    // FirebaseService.logEvent(
    //   name: 'generate_gift_ideas',
    //   parameters: {
    //     'gender': gender,
    //     'relation': relation,
    //     'category': category,
    //     'budget': budget,
    //     'interests_count': interests.length,
    //   },
    // );
    
    context.read<GiftBloc>().add(
      GiftGenerateRequested(
        name: name,
        age: age?.toString(),
        gender: gender,
        relation: relation,
        interests: interests,
        category: category,
        budget: budget,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea Regalo'),
        leading: widget.isEmbedded
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: BlocListener<GiftBloc, GiftState>(
        listener: (context, state) {
          if (state is GiftGenerateSuccess) {
            setState(() {
              _isGenerating = false;
              _currentStep = 4;
            });
            _pageController.animateToPage(
              4, // Results step
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else if (state is GiftGenerateFailure) {
            setState(() {
              _isGenerating = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          children: [
            // Stepper Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Recipient Info
                  RecipientInfoStep(
                    name: name,
                    age: age,
                    gender: gender,
                    relation: relation,
                    onNameChanged: (value) => setState(() => name = value),
                    onAgeChanged: (value) => setState(() => age = value),
                    onGenderChanged: (value) => setState(() => gender = value),
                    onRelationChanged: (value) => setState(() => relation = value),
                  ),
                  
                  // Step 2: Interests
                  InterestsStep(
                    selectedInterests: interests,
                    onInterestsChanged: (value) => setState(() => interests = value),
                  ),
                  
                  // Step 3: Budget
                  BudgetStep(
                    selectedBudget: budget,
                    onBudgetChanged: (value) => setState(() => budget = value),
                  ),
                  
                  // Step 4: Category
                  CategoryStep(
                    selectedCategory: category,
                    onCategoryChanged: (value) => setState(() => category = value),
                  ),
                  
                  // Step 5: Results
                  BlocBuilder<GiftBloc, GiftState>(
                    builder: (context, state) {
                      if (state is GiftGenerateSuccess) {
                        return ResultsStep(
                          gifts: state.gifts,
                          onBackToHome: () {
                            if (widget.isEmbedded) {
                              // Torna alla Home tab
                              Navigator.of(context).pop();
                            } else {
                              // Torna alla schermata precedente
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      }
                      
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Bottom Navigation
            if (_currentStep < 4 || _isGenerating)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                        ),
                        child: const Text('Indietro'),
                      ),
                    if (_currentStep > 0)
                      const SizedBox(width: 16),
                    Expanded(
                      child: PrimaryButton(
                        text: _currentStep == 3 ? 'Genera Idee' : 'Avanti',
                        isLoading: _isGenerating,
                        onPressed: _nextStep,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}