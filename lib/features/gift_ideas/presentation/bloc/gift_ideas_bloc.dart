import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/generate_gift_ideas.dart';
import 'gift_ideas_event.dart';
import 'gift_ideas_state.dart';

class GiftIdeasBloc extends Bloc<GiftIdeasEvent, GiftIdeasState> {
  final GenerateGiftIdeas generateGiftIdeas;
  
  GiftIdeasBloc({
    required this.generateGiftIdeas,
  }) : super(GiftIdeasInitial()) {
    on<GenerateGiftIdeasRequested>(_onGenerateGiftIdeasRequested);
    on<GenerateGiftIdeasForRecipientRequested>(_onGenerateGiftIdeasForRecipientRequested);
    on<ClearGiftIdeasRequested>(_onClearGiftIdeasRequested);
  }
  
  Future<void> _onGenerateGiftIdeasRequested(
    GenerateGiftIdeasRequested event,
    Emitter<GiftIdeasState> emit,
  ) async {
    emit(GiftIdeasLoading());
    try {
      final gifts = await generateGiftIdeas(
        name: event.name,
        age: event.age,
        gender: event.gender,
        relation: event.relation,
        interests: event.interests,
        category: event.category,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      );
      emit(GiftIdeasGenerated(gifts));
    } catch (e) {
      emit(GiftIdeasError(e.toString()));
    }
  }
  
  Future<void> _onGenerateGiftIdeasForRecipientRequested(
    GenerateGiftIdeasForRecipientRequested event,
    Emitter<GiftIdeasState> emit,
  ) async {
    emit(GiftIdeasLoading());
    try {
      // Per ora, gestiremo questa funzionalità più avanti quando implementeremo i destinatari
      emit(GiftIdeasError("Funzionalità non ancora implementata"));
    } catch (e) {
      emit(GiftIdeasError(e.toString()));
    }
  }
  
  void _onClearGiftIdeasRequested(
    ClearGiftIdeasRequested event,
    Emitter<GiftIdeasState> emit,
  ) {
    emit(GiftIdeasInitial());
  }
}