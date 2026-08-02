import 'package:flutter/material.dart';
import 'package:noti_chat/core/services/auth_service.dart';

class SignUpViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  AuthService authService = AuthService();
  Future<void> signUpUser(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await authService.saveUserToFirestore(email, password);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
