import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';

class RegisterProvider {
  late UserProvider _userProvider;

  bool _isResident = false;
  bool get isResident => _isResident;
  String _sendTo = '';
  String _idCard4 = '';
  String get idCard4 => _idCard4;
  String _userName = '';
  String get userName => _userName;
  String _refIdentifier = '';
  String get refIdentifier => _refIdentifier;
  RegisterOTPRef? _otpRef;
  RegisterOTPRef? get otpRef => _otpRef;
  RegisterOTPVerifyResponse? _verifyOTPResponse;
  RegisterOTPVerifyResponse? get verifyOTPResponse => _verifyOTPResponse;

  RegisterProvider updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
    return this;
  }

  Future<RegisterOTPRef?> requestOTPResident({String? idCard4, String? userName}) async {
    _saveValues(
      idCard4: idCard4,
      userName: userName,
    );
    _isResident = true;

    _otpRef = await AwRegisterService.sendOTPResident(idCard4: _idCard4, userName: _sendTo);
    if (_otpRef != null) {
      _refIdentifier = _otpRef!.identifier;
    }
    return otpRef;
  }

  Future<RegisterOTPVerifyResponse?> verifyOTPResident(String otp) async {
    if (otpRef != null) {
      _verifyOTPResponse = await AwRegisterService.verifyOTPResident(transId: otpRef!.transId, otp: otp);
    }
    return verifyOTPResponse;
  }

  Future<RegisterOTPRef?> requestOTPNonResident({String? userName}) async {
    _saveValues(
      idCard4: idCard4,
      userName: userName,
    );
    _isResident = false;

    _otpRef = await AwRegisterService.sendOTPNonResident(userName: _sendTo);
    return otpRef;
  }

  Future<RegisterOTPVerifyResponse?> verifyOTPNonResident(String otp) async {
    if (otpRef != null) {
      _verifyOTPResponse = await AwRegisterService.verifyOTPNonResident(transId: otpRef!.transId, otp: otp);
    }
    if (_verifyOTPResponse?.isResident ?? false) {
      _isResident = true;
    }
    return verifyOTPResponse;
  }

  void _saveValues({String? idCard4, String? userName}) {
    _userName = userName ?? _userName;
    _idCard4 = idCard4 ?? _idCard4;
    _sendTo = _userName;
  }
}
