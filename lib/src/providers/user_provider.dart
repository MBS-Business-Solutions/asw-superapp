import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  bool? _isMember;
  String? get token => _token;
  bool? get isLogin => _token != null;
  bool? get isMember => _isMember;

  UserProvider({String? token, bool? isMember}) {
    _token = token;
    _isMember = isMember;
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
