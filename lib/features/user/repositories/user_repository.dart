import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gchat/features/user/models/user.dart';

/// A repository class that handles user authentication and user data storage.
class UserRepository {
  /// An instance of Firebase Authentication for handling user authentication.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// An instance of Firebase Firestore for storing user data.
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  /// A private constructor to ensure the singleton pattern.
  UserRepository._();

  /// A static instance of the UserRepository class, following the singleton pattern.
  static UserRepository instance = UserRepository._();

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
          .where("uid",
              isEqualTo: _firebaseAuth.currentUser?.uid) // Filter by UID
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

  /// Retrieves a list of all users in the "users" collection, excluding the current user.
  ///
  /// This method fetches all documents from the "users" collection in Firebase Firestore,
  /// filters out the current user's document, and returns a list of [GChatUser] objects.
  ///
  /// @return A list of [GChatUser] objects representing all users except the current user
  Future<List<GChatUser>> getAllUsers() async {
    try {
      // Query the "users" collection in Firebase Firestore to retrieve all user documents
      // except the current user's document, using the current user's UID as a filter
      final query = await _firebaseFirestore
          .collection("users")
          .where(
            "uid",
            isNotEqualTo: _firebaseAuth.currentUser?.uid,
          ) // Filter out the current user
          .get();

      // Map each document in the query result to a GChatUser object
      final users = query.docs.map((document) {
        // Extract the document data and create a new GChatUser object
        final userData = document.data();
        return GChatUser.fromMap(userData);
      }).toList();

      // Return the list of GChatUser objects
      return users;
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

  /// Retrieves a list of all users in the "users" collection, excluding the current user.
  ///
  /// This method fetches all documents from the "users" collection in Firebase Firestore,
  /// filters out the current user's document, and returns a list of [GChatUser] objects.
  ///
  /// @return A list of [GChatUser] objects representing all users except the current user
  Stream<List<GChatUser>> getAllUsersStream() {
    try {
      // Query the "users" collection in Firebase Firestore to retrieve all user documents
      // except the current user's document, using the current user's UID as a filter
      final query = _firebaseFirestore
          .collection("users")
          .where(
            "uid",
            isNotEqualTo: _firebaseAuth.currentUser?.uid,
          ) // Filter out the current user
          .get()
          .asStream();

      // Map each document in the query result to a GChatUser object
      // final users = query.docs.map((document) {
      //   // Extract the document data and create a new GChatUser object
      //   final userData = document.data();
      //   return GChatUser.fromMap(userData);
      // }).toList();
      StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<GChatUser>>
          streamTransformer = StreamTransformer.fromHandlers(
        handleData: (
          QuerySnapshot<Map<String, dynamic>> data,
          EventSink<List<GChatUser>> sink,
        ) {
          final users = data.docs.map((document) {
            // Extract the document data and create a new GChatUser object
            final userData = document.data();
            return GChatUser.fromMap(userData);
          }).toList();
          sink.add(users);
        },
        handleError: (error, stackTrace, sink) {
          // Handle any errors that occur during the stream transformation
          // You can log the error, emit a custom error event, or perform any other necessary actions
          // For example, you can emit a custom error event to notify the UI about the error
          sink.addError(error.toString());
        },
      );

      final userStream = query.transform(streamTransformer);

      // Return the list of GChatUser objects
      return userStream;
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
