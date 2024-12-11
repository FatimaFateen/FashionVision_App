import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/models/app_user.dart';
import 'package:fyp/services/firestore_services.dart';

class AuthServices {
  AuthServices._();

  static final instance = AuthServices._();

  Future<void> createUser({
    required String email,
    required String password,
    required String username,
    required String role,
    int? tailorPrice,
  }) async {
    UserCredential cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = cred.user;
    if (user != null) {
      await user.updateDisplayName(username);
      AppUser appUser = AppUser(
          username: username,
          uid: user.uid,
          role: role,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          tailorPrice: tailorPrice ?? 0);
      await FirestoreServices.instance.addUserDataToFirestore(appUser);
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
