import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';

class VerifyOtpProvider {
  OTPRef? _otpRef;
  OTPRef? get otpRef => _otpRef;
  OTPChannel _channel = OTPChannel.sms;
  OTPChannel get channel => _channel;
  String _phoneEmail = '';
  String get phoneEmail => _phoneEmail;
  VerifyOTPResponse? _verifyOTPResponse;

  UserProvider? _userProvider;
  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  Future<OTPRef?> requestOTP({OTPChannel channel = OTPChannel.sms, required String phoneEmail}) async {
    _channel = channel;
    _phoneEmail = phoneEmail;

    // TODO: change to real API for verify OTP user that alread login
    _otpRef = await AwRegisterService.sendOTP(token: _userProvider!.token!, isLoginWithEmail: channel == OTPChannel.email, phoneEmail: phoneEmail);
    return _otpRef;
  }

  Future<OTPRef?> resendOTP() async {
    if (_otpRef != null) {
      _otpRef = await requestOTP(channel: _channel, phoneEmail: _phoneEmail);
      return _otpRef;
    }
    return null;
  }

  Future<VerifyOTPResponse?> verifyOTP(String otp) async {
    if (_otpRef != null) {
      _verifyOTPResponse = await AwRegisterService.verifyOTP(token: _userProvider!.token!, transId: _otpRef!.transId, otp: otp);
    }
    return _verifyOTPResponse;
  }
}

enum OTPChannel {
  email,
  sms,
}
