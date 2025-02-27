import 'dart:convert';

import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  late final FlutterSecureStorage secureStorage =
      FlutterSecureStorage(aOptions: _getAndroidOptions());
  String? _token;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool _isPinSet = false;
  bool get isPinSet => _isPinSet;
  bool get shouldValidatePin {
    return _isPinSet && isAuthenticated;
  }

  UserInformation? _userInformation;
  UserInformation? get userInformation => _userInformation;
  String? _userId;
  String? get userId => _userId;

  UserProvider({String? token, bool? isMember}) {
    _token = token;
  }

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  Future<bool> login(String userId) async {
    final tokenResponse = await AwUserService().login(userId);
    if (tokenResponse != null) {
      _token = tokenResponse.token;
      _userInformation = tokenResponse.userInformation;
      _userId = userId;
      await Future.wait([
        secureStorage.delete(key: 'LOGOUT'),
        secureStorage.write(key: 'SESSION_TOKEN', value: _token),
        secureStorage.write(key: 'USER_ID', value: _userId),
      ]);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loginNewUser(
      {required String type,
      required String phone,
      required String email,
      required String firstName,
      required String lastName}) async {
    final tokenResponse = await AwUserService().loginNewUser(
        type: type,
        phone: phone,
        email: email,
        firstName: firstName,
        lastName: lastName);
    if (tokenResponse != null) {
      _token = tokenResponse.token;
      _userInformation = tokenResponse.userInformation;

      await secureStorage.delete(key: 'LOGOUT');
      await secureStorage.write(
          key: 'USER_INFO', value: _userInformation!.toJson());
      await secureStorage.write(key: 'SESSION_TOKEN', value: _token);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> reloginUsingPin() async {
    // get new token if needed
    await secureStorage.delete(key: 'LOGOUT');
    await _loadPreviousData();
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _userInformation = null;
    await secureStorage.write(key: 'LOGOUT', value: 'true');
    // await secureStorage.deleteAll();
    notifyListeners();
  }

  Future<void> initApp() async {
    _isPinSet = await secureStorage.read(key: 'PIN') != null;
    if (await secureStorage.read(key: 'LOGOUT') == null) {
      // reload data from secure storage

      await _loadPreviousData();
      notifyListeners();
    }
  }

  Future<void> _loadPreviousData() async {
    _token = await secureStorage.read(key: 'SESSION_TOKEN');
    _isPinSet = await secureStorage.read(key: 'PIN') != null;
    _userId = await secureStorage.read(key: 'USER_ID');
    if (_userId != null && _token != null) {
      // fetch last updated user information
      fetchUserInformation();
    } else {
      // if login anonymously, fetch user information from secure storage instead
      final userJson = await secureStorage.read(key: 'USER_INFO');
      if (userJson != null) {
        _userInformation = UserInformation.fromJson(json.decode(userJson));
      }
    }
  }

  Future<bool> submitConsents(
      String consentId, Map<String, bool> consents) async {
    final response =
        await AwUserService.submitConsents(_token!, consentId, consents);
    return response;
  }

  Future<void> setPin(String? pin) async {
    _isPinSet = pin != null;
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

  Future<bool> changeEmail(String newValue) async {
    if (token == null) return false;
    return await AwUserService.changeEmail(_token!, newValue);
  }

  Future<bool> changePhone(String newValue) async {
    if (token == null) return false;

    return await AwUserService.changePhone(_token!, newValue);
  }

  Future<UserInformation?> fetchUserInformation() async {
    if (token == null) return null;
    final userInformation =
        await AwUserService.getUserInformation(_token!, _userId!);
    if (userInformation != null) {
      _userInformation = userInformation;
      await secureStorage.write(
          key: 'USER_INFO', value: _userInformation!.toJson());
    }
    return _userInformation;
  }
}
