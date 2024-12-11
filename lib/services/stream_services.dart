import 'package:fyp/models/chat.dart';
import 'package:fyp/services/firestore_services.dart';

final class StreamServices {
  StreamServices._();

  static final instance = StreamServices._();

  Stream<List<Chat>> getTailorSteam() {
    return FirestoreServices.instance.getTailorChat();
  }
}
