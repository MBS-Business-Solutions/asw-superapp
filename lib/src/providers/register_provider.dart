import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';

class RegisterProvider {
  late UserProvider _userProvider;

  bool _isResident = false;
  bool get isResident => _isResident;
  bool _isLoginWithEmail = false;
  bool get isLoginWithEmail => _isLoginWithEmail;
  String _sendTo = '';
  String? _email;
  String? get email => _email;
  String? _phone;
  String? get phone => _phone;
  String _idCard4 = '';
  String get idCard4 => _idCard4;
  RegisterOTPRef? _otpRef;
  RegisterOTPRef? get otpRef => _otpRef;
  RegisterOTPVerifyResponse? _verifyOTPResponse;
  RegisterOTPVerifyResponse? get verifyOTPResponse => _verifyOTPResponse;

  RegisterProvider updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
    return this;
  }

  Future<RegisterOTPRef?> requestOTPResident({bool? isLoginWithEmail, String? idCard4, String? email, String? phone}) async {
    _saveValues(isLoginWithEmail: isLoginWithEmail, idCard4: idCard4, email: email, phone: phone);
    _isResident = true;

    _otpRef = await AwRegisterService.sendOTPResident(isLoginWithEmail: _isLoginWithEmail, idCard4: _idCard4, phoneEmail: _sendTo);
    return otpRef;
  }

  Future<RegisterOTPVerifyResponse?> verifyOTPResident(String otp) async {
    if (otpRef != null) {
      _verifyOTPResponse = await AwRegisterService.verifyOTPResident(transId: otpRef!.transId, otp: otp);
    }
    return verifyOTPResponse;
  }

  Future<RegisterOTPRef?> requestOTPNonResident({bool? isLoginWithEmail, String? email, String? phone}) async {
    _saveValues(isLoginWithEmail: isLoginWithEmail, idCard4: idCard4, email: email, phone: phone);
    _isResident = false;

    _otpRef = await AwRegisterService.sendOTPNonResident(isLoginWithEmail: _isLoginWithEmail, phoneEmail: _sendTo);
    return otpRef;
  }

  Future<RegisterOTPVerifyResponse?> verifyOTPNonResident(String otp) async {
    if (otpRef != null) {
      _verifyOTPResponse = await AwRegisterService.verifyOTPNonResident(transId: otpRef!.transId, otp: otp);
    }
    return verifyOTPResponse;
  }

  void _saveValues({bool? isLoginWithEmail, String? idCard4, String? email, String? phone}) {
    final sendTo = (isLoginWithEmail ?? false) ? email : phone;
    _email = (isLoginWithEmail ?? false) ? email : null;
    _phone = (isLoginWithEmail ?? false) ? null : phone;
    _idCard4 = idCard4 ?? _idCard4;
    _sendTo = sendTo ?? _sendTo;
    _isLoginWithEmail = isLoginWithEmail ?? _isLoginWithEmail;
  }
}
