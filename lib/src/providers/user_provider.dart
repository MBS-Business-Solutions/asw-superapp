import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;

  UserProvider({String? token}) : _token = token;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void revokeToken() {
    _token = null;
    notifyListeners();
  }

  bool get isAuthenticated => _token != null;
}
