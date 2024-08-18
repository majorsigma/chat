import 'package:flutter/material.dart';
import 'package:gchat/features/onboarding/repository/auth_repository.dart';

class SignUpViewModel extends ChangeNotifier {
  bool isRegistrationLoading = false;

  Future<void> signup(String name, String email, String password) async {
    isRegistrationLoading = true;
    notifyListeners();
    try {
      await AuthRepository.instance.signup(name, email, password);

      isRegistrationLoading = false;
      notifyListeners();
    } catch (e) {
      isRegistrationLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
