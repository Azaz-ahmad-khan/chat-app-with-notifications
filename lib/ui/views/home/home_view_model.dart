//lib\ui\views\home\home_view_model.dart
import 'package:flutter/material.dart';
import 'package:noti_chat/core/services/auth_service.dart';

class HomeViewModel extends ChangeNotifier {
  String? errorMessage;
  AuthService authService = AuthService();
  Future<bool> logOut() async {
    try {
      await authService.signOUt();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Stream<List<Map<String, dynamic>>> getUsers() {
    return authService.getUsers();
  }
}
