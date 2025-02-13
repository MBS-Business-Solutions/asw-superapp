import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_user_service.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  UserInformation? _userInformation;
  UserInformation? get userInformation => _userInformation;

  UserProvider({String? token, bool? isMember}) {
    _token = token;
    // _token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2YTg3NDhhOC03ODM5LTQ1ZTgtYjNiNy1mYjljMjkyNGI1NDciLCJlbWFpbCI6ImhkZXYxQG1ic2Jpei5jby50aCIsImlhdCI6MTczOTE3NzA2OCwiZXhwIjoxNzQxNzY5MDY4fQ.40sglfJA_eQpzBEQ3mL-ycKa_7LFsPeIfbakCKmhzfs';
  }

  Future<bool> login(String userId) async {
    final tokenResponse = await AwUserService().login(userId);
    if (tokenResponse != null) {
      _token = tokenResponse.token;
      _userInformation = tokenResponse.userInformation;
      notifyListeners();
      return true;
    }
    return false;
  }
}
