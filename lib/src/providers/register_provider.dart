import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';

class RegisterProvider {
  late UserProvider _userProvider;

  bool _isResident = false;
  bool get isResident => _isResident;
  bool _isLoginWithEmail = false;
  bool get isLoginWithEmail => _isLoginWithEmail;
  String _phoneEmail = '';
  String get phoneEmail => _phoneEmail;
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

  Future<RegisterOTPRef?> requestOTPResident({bool? isLoginWithEmail, String? idCard4, String? phoneEmail}) async {
    _isResident = true;
    _idCard4 = idCard4 ?? _idCard4;
    _phoneEmail = phoneEmail ?? _phoneEmail;
    _isLoginWithEmail = isLoginWithEmail ?? _isLoginWithEmail;

    _otpRef = await AwRegisterService.sendOTPResident(isLoginWithEmail: _isLoginWithEmail, idCard4: _idCard4, phoneEmail: _phoneEmail);
    return otpRef;
  }

  Future<RegisterOTPVerifyResponse?> verifyOTPResident(String otp) async {
    if (otpRef != null) {
      _verifyOTPResponse = await AwRegisterService.verifyOTPResident(transId: otpRef!.transId, otp: otp);
    }
    return verifyOTPResponse;
  }

  Future<RegisterOTPRef?> requestOTPNonResident({bool? isLoginWithEmail, String? phoneEmail}) async {
    _isResident = false;
    _phoneEmail = phoneEmail ?? _phoneEmail;
    _isLoginWithEmail = isLoginWithEmail ?? _isLoginWithEmail;

    _otpRef = await AwRegisterService.sendOTPNonResident(isLoginWithEmail: _isLoginWithEmail, phoneEmail: _phoneEmail);
    return otpRef;
  }

  Future<RegisterOTPVerifyResponse?> verifyOTPNonResident(String otp) async {
    if (otpRef != null) {
      _verifyOTPResponse = await AwRegisterService.verifyOTPNonResident(transId: otpRef!.transId, otp: otp);
    }
    return verifyOTPResponse;
  }
}
