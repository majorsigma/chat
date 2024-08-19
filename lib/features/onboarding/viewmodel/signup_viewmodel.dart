import 'package:flutter/material.dart';
import 'package:gchat/features/onboarding/repository/auth_repository.dart';
import 'package:gchat/features/user/models/user.dart';

/// A view model for handling authentication operations.
class AuthViewModel extends ChangeNotifier {
  /// Indicates whether the  process is currently loading.
  bool isProcessLoading = false;

  get currentAuthUser => AuthRepository.instance.currentAuthUser;

  /// Signs up a user with the provided name, email, and password.
  ///
  /// Notifies the listeners when the  process starts and ends.
  ///
  /// @param name The user's full name.
  /// @param email The user's email address.
  /// @param password The user's password.
  Future<void> signup(String name, String email, String password) async {
    // Indicate that the registration process has started.
    isProcessLoading = true;
    notifyListeners();

    try {
      // Attempt to sign up the user using the AuthRepository.
      await AuthRepository.instance.signup(name, email, password);

      // Indicate that the process has completed successfully.
      isProcessLoading = false;
      notifyListeners();
    } catch (e) {
      // Indicate that the process has failed.
      isProcessLoading = false;
      notifyListeners();

      // Rethrow the exception to allow it to be handled upstream.
      rethrow;
    }
  }

  /// Signs in a user with the provided email and password.
  ///
  /// Notifies the listeners when the sign in process starts and ends.
  ///
  /// @param email The user's email address.
  /// @param password The user's password.
  Future<void> signIn(String email, String password) async {
    // Indicate that the sign in process has started.
    isProcessLoading = true;
    notifyListeners();

    try {
      // Attempt to sign in the user using the AuthRepository.
      /// Calls the signIn method of the AuthRepository to authenticate the user.
      await AuthRepository.instance.signIn(email, password);

      // Indicate that the sign in process has completed successfully.
      isProcessLoading = false;
      notifyListeners();
    } catch (e) {
      // Indicate that the sign in process has failed.
      isProcessLoading = false;
      notifyListeners();

      // Rethrow the exception to allow it to be handled upstream.
      rethrow;
    }
  }

  /// Signs out the current user from the application.
  ///
  /// This method is used to log out the user from the application.
  /// It utilizes the `AuthRepository` to perform the sign out operation.
  ///
  /// @return A future that completes when the sign out operation is done.
  Future<void> signOut() async {
    // Call the signOut method of the AuthRepository to log out the user.
    await AuthRepository.instance.signOut();
  }

  /// Retrieves the current user's profile information.
  ///
  /// This method communicates with the AuthRepository to fetch the user's profile data.
  /// It notifies the listeners when the retrieval process starts and ends.
  ///
  /// @return A Future that completes with the user's profile information.
  Future<GChatUser> getUserProfile() async {
    // // Indicate that the profile retrieval process has started.
    // // We set isProcessLoading to true to notify the UI that a operation is in progress.
    // isProcessLoading = true;
    // notifyListeners();

    try {
      // Call the getUserProfile method of the AuthRepository to fetch the user's profile.
      // This method returns a GChatUser object containing the user's profile information.
      final GChatUser user = await AuthRepository.instance.getUserProfile();

      // // Indicate that the profile retrieval process has completed successfully.
      // // We set isProcessLoading to false to notify the UI that the operation has finished.
      // isProcessLoading = false;
      // notifyListeners();

      // Return the user's profile information.
      return user;
    } catch (e) {
      // Indicate that the profile retrieval process has failed.
      // We set isProcessLoading to false to notify the UI that the operation has failed.
      // isProcessLoading = false;
      // notifyListeners();

      // Rethrow the exception to allow it to be handled upstream.
      rethrow;
    }
  }
}
