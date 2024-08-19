import 'package:flutter/material.dart';
import 'package:gchat/features/user/models/user.dart';
import 'package:gchat/features/user/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  /// Retrieves the current user's profile information.
  ///
  /// This method communicates with the AuthRepository to fetch the user's profile data.
  /// It notifies the listeners when the retrieval process starts and ends.
  ///
  /// @return A Future that completes with the user's profile information.
  Future<GChatUser> getUserProfile() async {
    // Indicate that the profile retrieval process has started.
    // We set isProcessLoading to true to notify the UI that a operation is in progress.

    try {
      // Call the getUserProfile method of the AuthRepository to fetch the user's profile.
      // This method returns a GChatUser object containing the user's profile information.
      final GChatUser user = await UserRepository.instance.getUserProfile();

      // Return the user's profile information.
      return user;
    } catch (e) {
      // Rethrow the exception to allow it to be handled upstream.
      rethrow;
    }
  }

  /// Retrieves a list of all users in the system.
  ///
  /// This method communicates with the UserRepository to fetch a list of all users.
  /// It notifies the listeners when the retrieval process starts and ends.
  ///
  /// @return A Future that completes with a list of GChatUser objects.
  Future<List<GChatUser>> getAllUsers() async {
    // Start the retrieval process.
    // We don't set isProcessLoading to true here, as it's not implemented in this method.

    try {
      // Call the getAllUsers method of the UserRepository to fetch a list of all users.
      // This method returns a list of GChatUser objects containing the users' profile information.
      final List<GChatUser> users = await UserRepository.instance.getAllUsers();

      debugPrint("User's: ${users}");

      // Return the list of users.
      return users;
    } catch (e) {
      // Rethrow the exception to allow it to be handled upstream.
      rethrow;
    }
  }

  /// Retrieves a stream of all users in the system.
  ///
  /// This method communicates with the UserRepository to fetch a stream of all users.
  ///
  /// @return A Stream that emits a list of GChatUser objects.
  Stream<List<GChatUser>> getAllUsersStream() async* {
    try {
      // Yield a stream of all users from the UserRepository.
      yield* UserRepository.instance.getAllUsersStream();
    } catch (e) {
      // Rethrow the exception to allow it to be handled upstream.
      rethrow;
    }
  }
}
