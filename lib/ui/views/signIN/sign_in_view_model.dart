//lib\ui\views\signIN\sign_in_view_model.dart
import 'package:flutter/material.dart';
import 'package:noti_chat/core/services/auth_service.dart';

class SignInViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  AuthService authService = AuthService();
  Future<void> signInUser(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await authService.signInUser(email, password);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
