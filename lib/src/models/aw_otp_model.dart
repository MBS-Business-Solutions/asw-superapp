class OTPRequest {
  final String? userType; // 'resident' | 'person'
  final String? channel; // 'phone' | 'email'
  final String? idCard4;
  final String? phone;
  final String? email;
  final String? sendTo;

  OTPRequest({
    this.userType,
    this.channel,
    this.idCard4,
    this.phone,
    this.email,
    this.sendTo,
  });

  factory OTPRequest.fromJson(Map<String, dynamic> json) {
    return OTPRequest(
      userType: json['type'] as String?,
      channel: json['otpType'] as String?,
      idCard4: json['idCard4'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      sendTo: json['sendTo'] as String?,
    );
  }
}

class OTPRef {
  String? success;
  dynamic message;
  String? transId;
  String? refCode;
  String? identifier;

  OTPRef({
    required this.success,
    this.message,
    this.transId,
    this.refCode,
    this.identifier,
  });

  factory OTPRef.fromJson(Map<String, dynamic> json) {
    return OTPRef(
      success: json['status'] as String?,
      message: json['message'],
      transId: json['data']?['trans_id'] as String?,
      refCode: json['data']?['ref_code'] as String?,
      identifier: json['data']?['identifier'] as String?,
    );
  }
}

class OTPVerifyResponse {
  String success;
  String? message;

  OTPVerifyResponse({
    required this.success,
    this.message,
  });

  factory OTPVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OTPVerifyResponse(
      success: json['status'] as String,
      message: json['message'] as String?,
    );
  }
}

enum OTPFor {
  reLogin,
  validateUser,
  changePin,
  other,
}

enum OTPChannel {
  sms,
  email,
}
