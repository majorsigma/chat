import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gchat/features/user/models/user.dart';
import 'package:gchat/utils.dart';

/// A repository class that handles user authentication and user data storage.
class AuthRepository {
  /// A logger instance for debugging and logging purposes.
  final _logger = GChatUtils.getLogger("AuthRepository");

  /// An instance of Firebase Authentication for handling user authentication.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// An instance of Firebase Firestore for storing user data.
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  /// A private constructor to ensure the singleton pattern.
  AuthRepository._();

  /// A static instance of the AuthRepository class, following the singleton pattern.
  static AuthRepository instance = AuthRepository._();

  /// A getter for the current authenticated user.
  get currentAuthUser => _firebaseAuth.currentUser;

  /// Creates a new user account with the provided credentials and
  /// adds the user to the Firebase Firestore database.
  ///
  /// @param name The user's full name
  /// @param email The user's email address
  /// @param password The user's password
  Future<void> signup(String name, String email, String password) async {
    try {
      // Create a new user account using Firebase Authentication
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a new GChatUser object with the user's details
      final user = GChatUser(
        uid: credential.user?.uid ?? "", // Use the Firebase Authentication UID
        name: name,
        email: email,
        isOnline: true,
      );

      // Add the user to the Firebase Firestore database
      final document = await _firebaseFirestore.collection("users").add(
            user.toMap(),
          );
      _logger.i("User document created with id: $document");
    } on FirebaseException catch (e) {
      // Catch any Firebase-specific exceptions and rethrow as a general Exception
      throw Exception(e.message);
    } catch (e) {
      // Rethrow any other exceptions
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final query = await _firebaseFirestore
          .collection("users")
          .where("uid", isEqualTo: userCredential.user?.uid)
          .get();

      final userDoc = query.docs.first;
      await userDoc.reference.update({"isOnline": true});
      _logger.i("Logged in with ${userDoc.data()}");
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out the current user from Firebase Authentication.
  ///
  /// This method signs out the user from Firebase Authentication, effectively
  /// ending their session.
  Future<void> signOut() async {
    try {
      // Attempt to sign out the user from Firebase Authentication
      // Check if a user is currently signed in
      if (_firebaseAuth.currentUser != null) {
        // Get the current user's UID
        final uid = _firebaseAuth.currentUser!.uid;
        final userQuery = await _firebaseFirestore
            .collection("users")
            .where('uid', isEqualTo: uid)
            .get();
        // Check if any documents were found
        if (userQuery.docs.isNotEmpty) {
          // Get the first document (assuming there's only one user with the given UID)
          final userDoc = userQuery.docs.first;
          // Update the 'isOnline' field to false
          await userDoc.reference.update({'isOnline': false});
          await _firebaseAuth.signOut();
        }
      }
    } on FirebaseException catch (e) {
      // Catch any Firebase-specific exceptions, such as network errors or
      // invalid configuration, and rethrow as a general Exception
      throw Exception(e.message);
    } catch (e) {
      // Rethrow any other exceptions, such as programming errors or unexpected
      // errors, to allow for further error handling and debugging
      rethrow;
    }
  }

  /// Retrieves the current user's profile information from Firebase Firestore.
  ///
  /// This method fetches the user's document from the "users" collection
  /// in Firebase Firestore, using the current user's UID as a filter.
  ///
  /// @return A [GChatUser] object representing the current user's profile
  Future<GChatUser> getUserProfile() async {
    try {
      // Query the "users" collection in Firebase Firestore to retrieve the user's document
      final query = await _firebaseFirestore
          .collection("users")
          .where("uid", isEqualTo: _firebaseAuth.currentUser?.uid) // Filter by UID
          .get();

      // Extract the first document from the query result (assuming there's only one matching document)
      final userMap = query.docs.first.data();

      // Create a new GChatUser object from the user's document data
      final user = GChatUser.fromMap(userMap);

      // Return the user profile object
      return user;
    } on FirebaseAuthException catch (e) {
      // Catch any Firebase Authentication-specific exceptions and rethrow as a general Exception
      throw Exception(e.message);
    } on FirebaseException catch (e) {
      // Catch any other Firebase-specific exceptions and rethrow as a general Exception
      throw Exception(e.message);
    } catch (e) {
      // Rethrow any other exceptions for further error handling and debugging
      rethrow;
    }
  }
}
