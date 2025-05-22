import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/generate_gift_ideas.dart';
import '../../domain/repositories/gift_ideas_repository.dart'; // ✅ Aggiunto per accesso diretto
import 'gift_ideas_event.dart';
import 'gift_ideas_state.dart';

class GiftIdeasBloc extends Bloc<GiftIdeasEvent, GiftIdeasState> {
  final GenerateGiftIdeas generateGiftIdeas;
  final GiftIdeasRepository giftIdeasRepository; // ✅ Aggiunto repository diretto
  
  GiftIdeasBloc({
    required this.generateGiftIdeas,
    required this.giftIdeasRepository, // ✅ Dependency injection
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
      // ✅ FIXED: Ora implementa correttamente la chiamata al repository
      final gifts = await giftIdeasRepository.generateGiftIdeasForRecipient(
        event.recipientId,
        category: event.category,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
      );
      emit(GiftIdeasGenerated(gifts));
    } catch (e) {
      emit(GiftIdeasError('Errore nella generazione regali per destinatario: ${e.toString()}'));
    }
  }
  
  void _onClearGiftIdeasRequested(
    ClearGiftIdeasRequested event,
    Emitter<GiftIdeasState> emit,
  ) {
    emit(GiftIdeasInitial());
  }
}