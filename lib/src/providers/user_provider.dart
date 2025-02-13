import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  late final FlutterSecureStorage storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  String? _token;
  String? get token => _token;
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

      await storage.write(key: 'SESSION_TOKEN', value: _token);
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

      await storage.write(key: 'SESSION_TOKEN', value: _token);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> initApp() async {
    _token = await storage.read(key: 'SESSION_TOKEN');
    notifyListeners();

    // send FCM Token to server
  }

  Future<bool> submitConsents(String consentId, Map<String, bool> consents) async {
    final response = await AwUserService.submitConsents(_token!, consentId, consents);
    return response;
  }

  Future<void> setPin(String pin) async {
    await storage.write(key: 'PIN', value: pin);
  }

  Future<bool> validatePin(String pin) async {
    final savedPin = await storage.read(key: 'PIN');
    return savedPin == pin;
  }
}
