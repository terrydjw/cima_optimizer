import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> submitForm(String email, String password, bool isLogin) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    String? error;
    if (isLogin) {
      error = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
    } else {
      error = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
    }

    _isLoading = false;
    if (error != null) {
      _errorMessage =
          error; // I'm now setting the specific Firebase error message.
    }
    notifyListeners();
  }
}
