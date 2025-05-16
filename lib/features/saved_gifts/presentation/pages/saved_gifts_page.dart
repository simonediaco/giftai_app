// lib/features/saved_gifts/presentation/pages/saved_gifts_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/saved_gifts_bloc.dart';
import '../bloc/saved_gifts_event.dart';
import '../bloc/saved_gifts_state.dart';
import '../widgets/saved_gift_card.dart';
import '../widgets/empty_saved_gifts.dart';

class SavedGiftsPage extends StatefulWidget {
  static const routeName = '/saved-gifts';
  
  const SavedGiftsPage({Key? key}) : super(key: key);

  @override
  State<SavedGiftsPage> createState() => _SavedGiftsPageState();
}

class _SavedGiftsPageState extends State<SavedGiftsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SavedGiftsBloc>().add(FetchSavedGifts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regali Salvati'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementare filtri
            },
          ),
        ],
      ),
      body: BlocBuilder<SavedGiftsBloc, SavedGiftsState>(
        builder: (context, state) {
          if (state is SavedGiftsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SavedGiftsLoaded) {
            if (state.gifts.isEmpty) {
              return const EmptySavedGifts();
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              itemCount: state.gifts.length,
              itemBuilder: (context, index) {
                final gift = state.gifts[index];
                return SavedGiftCard(
                  gift: gift,
                  onDelete: () {
                    context.read<SavedGiftsBloc>().add(RemoveSavedGift(gift.id));
                  },
                );
              },
            );
          } else if (state is SavedGiftsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Text(
                    'Si è verificato un errore',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spaceL),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<SavedGiftsBloc>().add(FetchSavedGifts());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Riprova'),
                  ),
                ],
              ),
            );
          }
          
          return const Center(
            child: Text('Qualcosa è andato storto'),
          );
        },
      ),
    );
  }
}