import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';

class RegisterProvider {
  late UserProvider _userProvider;

  bool? isResident;
  bool? isLoginWithEmail;
  String? mobileEmail;
  String? idCard4;
  OTPRef? otpRef;
  VerifyOTPResponse? verifyOTPResponse;

  RegisterProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }
}
