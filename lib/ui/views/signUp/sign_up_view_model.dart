//lib\ui\views\signUp\sign_up_view_model.dart
import 'package:flutter/material.dart';

import 'package:noti_chat/core/services/auth_service.dart';

class SignUpViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  AuthService authService = AuthService();
  Future<void> signUpUser(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await authService.saveUserToFirestore(name, email, password);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
