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

class OTPAddUnitRequest {
  String projectCode;
  String unitNumber;
  String last4Id;

  OTPAddUnitRequest({
    required this.projectCode,
    required this.unitNumber,
    required this.last4Id,
  });
}

class OTPAddUnitResponse {
  int code;
  String status;
  String? unitId;
  String? projectId;
  String? contractId;
  String? customerId;
  String? unitNumber;
  String? houseNumber;
  String? projectName;
  String? projectType;
  String? contractNumber;
  String? projectNameEn;

  OTPAddUnitResponse({
    required this.code,
    required this.status,
    this.unitId,
    this.projectId,
    this.contractId,
    this.customerId,
    this.unitNumber,
    this.houseNumber,
    this.projectName,
    this.projectType,
    this.contractNumber,
    this.projectNameEn,
  });
  factory OTPAddUnitResponse.fromJson(Map<String, dynamic> json) {
    return OTPAddUnitResponse(
      code: json['code'] as int,
      status: json['status'] as String,
      unitId: json['data']?['unit_id'] as String?,
      projectId: json['data']?['project_id'] as String?,
      contractId: json['data']?['contract_id'] as String?,
      customerId: json['data']?['customer_id'] as String?,
      unitNumber: json['data']?['unit_number'] as String?,
      houseNumber: json['data']?['house_number'] as String?,
      projectName: json['data']?['project_name'] as String?,
      projectType: json['data']?['project_type'] as String?,
      contractNumber: json['data']?['contract_number'] as String?,
      projectNameEn: json['data']?['project_name_en'] as String?,
    );
  }
}

enum OTPFor {
  reLogin,
  validateUser,
  changePin,
  addUnit,
  other,
}

enum OTPChannel {
  sms,
  email,
}
