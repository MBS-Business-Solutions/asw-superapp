class Project {
  final int id;
  final String name;
  final String status;
  final String image;

  Project({required this.id, required this.name, required this.status, required this.image});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(id: json['id'], name: json['name'], status: json['status'], image: json['image']);
  }
}

class ImageContent {
  final String image;
  final int id;

  ImageContent({required this.image, required this.id});

  factory ImageContent.fromJson(Map<String, dynamic> json) {
    return ImageContent(image: json['image'], id: json['id']);
  }
}

class OTPRef {
  final bool isMobile;
  final String idCard;
  final String sendTo;
  final String transId;
  final String refCode;

  OTPRef({
    required this.isMobile,
    required this.idCard,
    required this.transId,
    required this.refCode,
    required this.sendTo,
  });

  factory OTPRef.fromJson(
    Map<String, dynamic> json, {
    required String idCard,
    required String sendTo,
    required bool isMobile,
  }) {
    return OTPRef(
      transId: json['trans_id'],
      refCode: json['ref_code'],
      sendTo: sendTo,
      isMobile: isMobile,
      idCard: idCard,
    );
  }
}

class VerifyOTPResponse {
  final String id;
  final String phone;
  final String email;
  final String idCard;

  VerifyOTPResponse({required this.id, required this.phone, required this.email, required this.idCard});

  factory VerifyOTPResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOTPResponse(id: json['id'], phone: json['phone'], email: json['email'], idCard: json['id_card']);
  }
}
