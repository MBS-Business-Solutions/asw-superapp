import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_otp_service.dart';

class VerifyOtpProvider {
  OTPRef? _otpRef;
  OTPRef? get otpRef => _otpRef;
  OTPChannel _channel = OTPChannel.sms;
  OTPChannel get channel => _channel;
  OTPVerifyResponse? _verifyOTPResponse;
  OTPRequest? _otpRequest;
  OTPRequest? get otpRequest => _otpRequest;
  OTPAddUnitRequest? _otpAddUnitRequest;

  UserProvider? _userProvider;
  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  Future<OTPRef?> requestOTP({OTPFor action = OTPFor.other, OTPChannel channel = OTPChannel.sms, required String sendTo, bool? isResident, String? idCard4}) async {
    final isSMS = channel == OTPChannel.sms;
    _otpRequest = OTPRequest(
      email: isSMS ? null : sendTo,
      phone: isSMS ? sendTo : null,
      idCard4: idCard4,
      channel: isSMS ? 'phone' : 'email',
      userType: isResident != null ? (isResident ? 'resident' : 'person') : null,
      sendTo: sendTo,
    );

    return resendOTP(action: action);
  }

  Future<OTPRef?> resendOTP({OTPFor action = OTPFor.other}) async {
    switch (action) {
      case OTPFor.reLogin:
        _otpRef = await AwOtpService.sendOTPForReLogin(token: _userProvider!.token!, request: _otpRequest!);
        break;
      case OTPFor.validateUser:
        _otpRef = await AwOtpService.sendOTPForValidateUser(token: _userProvider!.token!, request: _otpRequest!);
        break;
      case OTPFor.changePin:
        _otpRef = await AwOtpService.sendOTPForChangePin(token: _userProvider!.token!, request: _otpRequest!);
        break;
      case OTPFor.addUnit:
        if (_otpAddUnitRequest == null) return null;
        _otpRef = await sendOTPForUnitAdd(
          projectCode: _otpAddUnitRequest!.projectCode,
          unitNumber: _otpAddUnitRequest!.unitNumber,
          last4Id: _otpAddUnitRequest!.last4Id,
        );
        break;

      default:
        return null;
    }
    return _otpRef;
  }

  Future<OTPVerifyResponse?> verifyOTP({OTPFor action = OTPFor.other, required String otp}) async {
    switch (action) {
      case OTPFor.reLogin:
        _verifyOTPResponse = await AwOtpService.verifyOTPForLogin(token: _userProvider!.token!, transId: _otpRef!.transId!, otp: otp);
        break;
      case OTPFor.validateUser:
        _verifyOTPResponse = await AwOtpService.verifyOTPForValidateUser(token: _userProvider!.token!, transId: _otpRef!.transId!, otp: otp);
        break;
      case OTPFor.changePin:
        _verifyOTPResponse = await AwOtpService.verifyOTPForChangePin(token: _userProvider!.token!, transId: _otpRef!.transId!, otp: otp);
        break;
      default:
        return null;
    }
    return _verifyOTPResponse;
  }

  Future<OTPRef?> sendOTPForUnitAdd({required String projectCode, required String unitNumber, required String last4Id}) async {
    _otpAddUnitRequest = OTPAddUnitRequest(projectCode: projectCode, unitNumber: unitNumber, last4Id: last4Id);

    if (_userProvider == null || _userProvider!.token == null) return null;
    _otpRef = await AwOtpService.sendOTPForUnitAdd(token: _userProvider!.token!, projectCode: projectCode, unitNumber: unitNumber, last4Id: last4Id);
    if (_otpRef != null) {
      _otpRequest = OTPRequest.fromJson({
        'channel': 'phone',
        'otpType': 'phone',
        'idCard4': last4Id,
        'phone': _otpRef!.identifier,
      });
    }
    return _otpRef;
  }

  Future<OTPAddUnitResponse?> verifyOTPForAddUnit({required String otp}) async {
    final result = await AwOtpService.verifyOTPForAddUnit(token: _userProvider!.token!, transId: _otpRef!.transId!, otp: otp);
    return result;
  }
}
