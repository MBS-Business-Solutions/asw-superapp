import 'dart:convert';

import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  late final FlutterSecureStorage secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  String? _token;
  String? get token => _token;
  String testv = 'test';
  bool get isAuthenticated => _token != null;
  UserInformation? _userInformation;
  UserInformation? get userInformation => _userInformation;

  UserProvider({String? token, bool? isMember}) {
    _token = token;
    initApp();
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);

  Future<bool> login(String userId) async {
    final tokenResponse = await AwUserService().login(userId);
    if (tokenResponse != null) {
      _token = tokenResponse.token;
      _userInformation = tokenResponse.userInformation;

      await secureStorage.write(key: 'SESSION_TOKEN', value: _token);
      await secureStorage.write(key: 'USER_INFO', value: _userInformation!.toJson());
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loginNewUser({required String type, required String phone, required String email, required String firstName, required String lastName}) async {
    final tokenResponse = await AwUserService().loginNewUser(type: type, phone: phone, email: email, firstName: firstName, lastName: lastName);
    if (tokenResponse != null) {
      _token = tokenResponse.token;
      _userInformation = tokenResponse.userInformation;

      await secureStorage.write(key: 'SESSION_TOKEN', value: _token);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> initApp() async {
    _token = await secureStorage.read(key: 'SESSION_TOKEN');
    final userJson = await secureStorage.read(key: 'USER_INFO');
    if (userJson != null) {
      _userInformation = UserInformation.fromJson(jsonDecode(userJson));
    }
    notifyListeners();

    // send FCM Token to server
  }

  Future<bool> submitConsents(String consentId, Map<String, bool> consents) async {
    final response = await AwUserService.submitConsents(_token!, consentId, consents);
    return response;
  }

  Future<void> setPin(String pin) async {
    await secureStorage.write(key: 'PIN', value: pin);
  }

  Future<bool> validatePin(String pin) async {
    final savedPin = await secureStorage.read(key: 'PIN');
    return savedPin == pin;
  }

  Future<void> setPreferedLanguage(String language) async {
    if (token == null) return;
    await AwUserService.setPreferedLanguage(_token!, language);
  }

  Future<void> logout() async {
    _token = null;
    _userInformation = null;
    await secureStorage.deleteAll();
    notifyListeners();
  }
}
