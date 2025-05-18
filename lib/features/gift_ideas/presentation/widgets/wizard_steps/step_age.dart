// lib/features/gift_ideas/presentation/widgets/wizard_steps/step_age.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/app_text_field.dart';
import '../../models/gift_wizard_data.dart';

class StepAge extends StatefulWidget {
  final GiftWizardData wizardData;
  final VoidCallback onComplete;

  const StepAge({
    Key? key,
    required this.wizardData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<StepAge> createState() => _StepAgeState();
}

class _StepAgeState extends State<StepAge> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.wizardData.name ?? '';
    _ageController.text = widget.wizardData.age?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome (opzionale)
          AppTextField(
            label: 'Nome (opzionale)',
            hint: 'Inserisci il nome del destinatario',
            controller: _nameController,
            onChanged: (value) {
              widget.wizardData.name = value.isNotEmpty ? value : null;
            },
          ),
          const SizedBox(height: AppTheme.spaceXL),

          // Età (richiesta)
          Text(
            'Età (approssimativa)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spaceM),
          
          // Selettore età grafico
          SizedBox(
            height: 120,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceL),
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        final currentAge = int.tryParse(_ageController.text) ?? 30;
                        if (currentAge > 1) {
                          setState(() {
                            _ageController.text = (currentAge - 1).toString();
                            widget.wizardData.age = currentAge - 1;
                          });
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _ageController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          final age = int.tryParse(value);
                          if (age != null) {
                            widget.wizardData.age = age;
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        final currentAge = int.tryParse(_ageController.text) ?? 30;
                        if (currentAge < 120) {
                          setState(() {
                            _ageController.text = (currentAge + 1).toString();
                            widget.wizardData.age = currentAge + 1;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spaceM),
          
          // Fascie d'età rapide
          Center(
            child: Wrap(
              spacing: AppTheme.spaceM,
              children: [
                _buildQuickAgeButton(18),
                _buildQuickAgeButton(25),
                _buildQuickAgeButton(30),
                _buildQuickAgeButton(40),
                _buildQuickAgeButton(50),
                _buildQuickAgeButton(65),
              ],
            ),
          ),
          
          const SizedBox(height: AppTheme.spaceXL),

          // Pulsante per continuare
          Center(
            child: AppButton(
              text: 'Continua',
              icon: const Icon(Icons.arrow_forward),
              onPressed: widget.wizardData.isStepOneComplete
                  ? widget.onComplete
                  : null,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAgeButton(int age) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _ageController.text = age.toString();
          widget.wizardData.age = age;
        });
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(AppTheme.spaceM),
      ),
      child: Text(
        age.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}