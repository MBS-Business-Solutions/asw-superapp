import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;
  bool? get isLogin => _token != null;

  UserProvider({String? token, bool? isMember}) {
    _token = token;
  }

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
