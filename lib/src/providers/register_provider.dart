import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';

class RegisterProvider {
  late UserProvider _userProvider;

  late bool _isResident;
  get isResident => _isResident;
  bool _isLoginWithEmail = false;
  get isLoginWithEmail => _isLoginWithEmail;
  late String _phoneEmail;
  get phoneEmail => _phoneEmail;
  late String _idCard4;
  get idCard4 => _idCard4;
  OTPRef? _otpRef;
  OTPRef? get otpRef => _otpRef;
  VerifyOTPResponse? _verifyOTPResponse;
  VerifyOTPResponse? get verifyOTPResponse => _verifyOTPResponse;

  RegisterProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  Future<OTPRef?> requestOTPResident({bool isLoginWithEmail = false, String? idCard4, String? phoneEmail}) async {
    _isResident = true;
    _idCard4 = idCard4 ?? _idCard4;
    _phoneEmail = phoneEmail ?? _phoneEmail;
    _isLoginWithEmail = isLoginWithEmail;

    _otpRef = await AwRegisterService.sendOTPResident(isLoginWithEmail: _isLoginWithEmail, idCard4: _idCard4, phoneEmail: _phoneEmail);
    return otpRef;
  }

  Future<VerifyOTPResponse?> verifyOTPResident(String otp) async {
    if (otpRef != null) {
      _verifyOTPResponse = await AwRegisterService.verifyOTPResident(transId: otpRef!.transId, otp: otp);
    }
    return verifyOTPResponse;
  }
}
