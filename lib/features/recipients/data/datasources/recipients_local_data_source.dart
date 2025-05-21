
import 'package:hive/hive.dart';
import '../models/recipient_model.dart';

class RecipientsLocalDataSource {
  static const String boxName = 'recipients';
  
  Future<Box<RecipientModel>> get _box async => 
    await Hive.openBox<RecipientModel>(boxName);

  Future<List<RecipientModel>> getRecipients() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> saveRecipients(List<RecipientModel> recipients) async {
    final box = await _box;
    await box.clear();
    await box.addAll(recipients);
  }
}
