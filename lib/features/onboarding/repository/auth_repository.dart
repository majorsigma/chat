import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gchat/features/user/models/user.dart';
import 'package:gchat/utils.dart';

class AuthRepository {
  final _logger = GChatUtils.getLogger("AuthRepository");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static AuthRepository instance = AuthRepository._();

  AuthRepository._();

  Future<void> signup(String name, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      
      final user = GChatUser(
        uid: credential.user?.uid ?? "",
        name: name,
        email: email,
      );

      final document =
          await _firebaseFirestore.collection("users").add(user.toMap());
      _logger.i("User document created with id: ${document.id}");
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }
}
