import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/models/app_user.dart';
import 'package:fyp/models/chat.dart';

final class FirestoreServices {
  FirestoreServices._();

  static final instance = FirestoreServices._();
  final String users = "users";
  final String chats = "chats";

  Future<void> addUserDataToFirestore(AppUser user) async {
    await FirebaseFirestore.instance
        .collection(users)
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<AppUser?> getAppUserFromFirestore() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot document = await FirebaseFirestore.instance
          .collection(users)
          .doc(user.uid)
          .get();
      if (document.exists) {
        return AppUser.fromMap(document.data() as Map<String, dynamic>);
      } else {
        throw Exception('User does not exist in firestore');
      }
    } else {
      return null;
    }
  }

  Future<void> addMessageToChat(String id, {required Messages message}) async {
    await FirebaseFirestore.instance.collection(chats).doc(id).update({
      "messages": FieldValue.arrayUnion(
        [message.toMap()],
      )
    });
  }

  Future<void> startANewChat({
    required Chat chat,
    required String receiverId,
  }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(chats)
        .where("receiver", isEqualTo: receiverId)
        .get();
    if (snapshot.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection(chats)
          .doc(chat.id)
          .set(chat.toMap());
    }
  }

  Stream<List<Chat>> getTailorChat() {
    return FirebaseFirestore.instance
        .collection(chats)
        .where("receiver", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((e) {
      return e.docs.map((chat) => Chat.fromMap(chat.data())).toList();
    });
  }

  Future<List<AppUser>> getAllTailors() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(users)
        .where("role", isEqualTo: "Tailor")
        .get();
    return snapshot.docs.map((doc) => AppUser.fromMap(doc.data())).toList();
  }

  Stream<Chat> singleUserChatStreamForUser(String uid) {
    return FirebaseFirestore.instance
        .collection(chats)
        .where("receiver", isEqualTo: uid)
        .snapshots()
        .map((e) {
      return Chat.fromMap(e.docs.first.data());
    });
  }

  Stream<Chat> singleUserChatStreamForTailor(String uid) {
    return FirebaseFirestore.instance
        .collection(chats)
        .where("sender", isEqualTo: uid)
        .snapshots()
        .map((e) {
      return Chat.fromMap(e.docs.first.data());
    });
  }
}
