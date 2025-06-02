import 'dart:convert';
import 'dart:io';

import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  late final FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: _getAndroidOptions(),
    iOptions: _getIosOptions(),
  );
  String? _token;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool _isPinSet = false;
  bool get isPinSet => _isPinSet;
  bool get shouldValidatePin {
    return _isPinSet && isAuthenticated;
  }

  String _language = 'th';
  String get language => _language;

  bool get shouldValidateOTP {
    return !_isPinSet && isAuthenticated;
  }

  UserInformation? _userInformation;
  UserInformation? get userInformation => _userInformation;

  UserProvider({String? token, bool? isMember}) {
    _token = token;
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
  IOSOptions _getIosOptions() => const IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device);

  Future<bool> login(String userId) async {
    final tokenResponse = await AwUserService().login(userId);
    if (tokenResponse != null) {
      _token = tokenResponse.token;
      // _userInformation = tokenResponse.userInformation;
      await fetchUserInformation();

      await Future.wait([
        secureStorage.delete(key: 'LOGOUT'),
        secureStorage.write(key: 'SESSION_TOKEN', value: _token),
      ]);
      await reloadIsar(_userInformation?.code);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loginNewUser({required String type, required String phone, required String email, required String firstName, required String lastName}) async {
    final tokenResponse = await AwUserService().loginNewUser(type: type, phone: phone, email: email, firstName: firstName, lastName: lastName);
    if (tokenResponse != null) {
      _token = tokenResponse.token;
      // _userInformation = tokenResponse.userInformation;
      await fetchUserInformation();

      await secureStorage.delete(key: 'LOGOUT');
      await secureStorage.write(key: 'USER_INFO', value: _userInformation!.toJson());
      await secureStorage.write(key: 'SESSION_TOKEN', value: _token);

      await reloadIsar(_userInformation?.code);
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
    _isPinSet = false;
    _userInformation = null;
    if (token != null) await AwUserService().logout(_token!, _language);
    await secureStorage.deleteAll();
    // await isar.writeTxn(() async {
    //   await isar.clear();
    // });
    await reloadIsar();

    notifyListeners();
  }

  Future<void> initApp({String? testToken}) async {
    _isPinSet = await secureStorage.read(key: 'PIN') != null;
    if (await secureStorage.read(key: 'LOGOUT') == null) {
      // reload data from secure storage

      await _loadPreviousData(testToken: testToken);
      notifyListeners();
    }
  }

  Future<void> _loadPreviousData({String? testToken}) async {
    final sharedPref = await SharedPreferences.getInstance();
    final isFirstLoad = sharedPref.getBool('FIRST_LOAD') ?? true;
    if (isFirstLoad) {
      final secureStorageUnlock = FlutterSecureStorage(
        aOptions: _getAndroidOptions(),
        iOptions: const IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device),
      );
      await secureStorageUnlock.deleteAll();
      await secureStorage.deleteAll();
      await sharedPref.setBool('FIRST_LOAD', false);
    }

    _token = await secureStorage.read(key: 'SESSION_TOKEN');
    if (testToken != null) {
      _token = testToken;
    }
    if (kDebugMode) {
      print('Token: $_token');
    }
    _isPinSet = await secureStorage.read(key: 'PIN') != null;
    if (_token != null) {
      // fetch last updated user information
      await fetchUserInformation();
    } else {
      // if login anonymously, fetch user information from secure storage instead
      final userJson = await secureStorage.read(key: 'USER_INFO');
      if (userJson != null) {
        _userInformation = UserInformation.fromJson(json.decode(userJson));
      }
    }
    await reloadIsar(_userInformation?.code);
  }

  Future<bool> submitConsents(String consentId, Map<String, bool> consents) async {
    final response = await AwUserService().submitConsents(_token!, consentId, consents);
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
    _language = language;
    await AwUserService().setPreferedLanguage(_token!, language);
    notifyListeners();
  }

  Future<bool> changeEmail(String newValue) async {
    if (token == null) return false;
    return await AwUserService().changeEmail(_token!, newValue);
  }

  Future<bool> changePhone(String newValue) async {
    if (token == null) return false;

    return await AwUserService().changePhone(_token!, newValue);
  }

  Future<UserInformation?> fetchUserInformation() async {
    if (token == null) return null;
    final userInformation = await AwUserService().getUserInformation(_token!);
    if (userInformation != null) {
      _userInformation = userInformation;
      await secureStorage.write(key: 'USER_INFO', value: _userInformation!.toJson());
    }
    return _userInformation;
  }

  Future<List<PersonalConsent>> fetchPersonalConsents() async {
    if (token == null) return [];
    return await AwUserService().fetchPersonalConsents(_token!, language: userInformation?.language);
  }

  Future<PersonalConsentDetail?> fetchPersonalConsentDetail(String consentId) async {
    if (token == null) return null;
    return await AwUserService().fetchPersonalConsentDetail(_token!, consentId, language: userInformation?.language);
  }

  Future<bool> submitConsent(String consentId, bool value) async {
    if (token == null) return false;
    return await AwUserService().submitPersonalConsent(_token!, consentId, value);
  }

  Future<List<AboutItem>> fetchAboutItems() async {
    if (token == null) return [];
    return await AwUserService().fetchAboutItems(_token!, language: userInformation?.language);
  }

  Future<AboutItemDetail?> fetchAboutItemDetail(String consentId) async {
    if (token == null) return null;
    return await AwUserService().fetchAboutItemDetail(_token!, consentId, language: userInformation?.language);
  }

  Future<MyQRResponse?> fetchMyQR() async {
    //if (token == null) return null;
    final String qr = '${_userInformation?.userCode ?? ''}|${_userInformation?.code ?? ''}|${_userInformation?.phone ?? ''}';
    return MyQRResponse(code: 200, status: 'success', ref: qr, qrCode: qr); //await AwUserService().fetchMyQR(_token!);
  }

  Future<void> cleanUpKeyChain() async {
    const secureStorageUnlock = FlutterSecureStorage();
    await secureStorageUnlock.deleteAll();

    await secureStorage.deleteAll();
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();

    final appPath = await getApplicationDocumentsDirectory();
    await isar.close();

    // delete all files and directory in the app directory

    final dir = Directory(appPath.path);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  Future<String?> getPriviledgeLink() async {
    if (token == null) return null;

    final response = await AwUserService().fetchPriviledge(_token!);
    return response.data?.url;
  }

  void setTestToken(String token) {
    _token = token;
    notifyListeners();
  }

  void reloadAll() {
    notifyListeners();
  }
}
