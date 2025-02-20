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
  final bool isLoginWithEmail;
  final String? idCard;
  final String sendTo;
  final String transId;
  final String refCode;

  OTPRef({
    required this.isLoginWithEmail,
    this.idCard,
    required this.transId,
    required this.refCode,
    required this.sendTo,
  });

  factory OTPRef.fromJson(
    Map<String, dynamic> json, {
    String? idCard,
    required String sendTo,
    required bool isLoginWithEmail,
  }) {
    return OTPRef(
      transId: json['trans_id'],
      refCode: json['ref_code'],
      sendTo: sendTo,
      isLoginWithEmail: isLoginWithEmail,
      idCard: idCard,
    );
  }
}

class VerifyOTPResponse {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? idCard;

  VerifyOTPResponse({this.id, this.phone, this.firstName, this.lastName, this.email, this.idCard});

  factory VerifyOTPResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOTPResponse(id: json['id'], phone: json['phone'], firstName: json['first_name'], lastName: json['last_name'], email: json['email'], idCard: json['id_card']);
  }
}

class Consent {
  final String id;
  final String version;
  final String content;
  final List<ConsentItem> items;

  Consent({required this.id, required this.version, required this.content, required this.items});

  factory Consent.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<ConsentItem> items = itemsList.map((i) => ConsentItem.fromJson(i)).toList();

    return Consent(
      id: json['id'],
      version: json['version'],
      content: json['content'],
      items: items,
    );
  }
}

class ConsentItem {
  final String id;
  final String title;
  final String content;
  final bool isRequired;

  ConsentItem({required this.id, required this.title, required this.content, required this.isRequired});

  factory ConsentItem.fromJson(Map<String, dynamic> json) {
    return ConsentItem(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      isRequired: json['is_required'],
    );
  }
}

class UserToken {
  final String token;
  final UserInformation userInformation;

  UserToken({required this.token, required this.userInformation});

  factory UserToken.fromJson(Map<String, dynamic> json) {
    return UserToken(token: json['token'], userInformation: UserInformation.fromJson(json['data']));
  }
}

class UserInformation {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final List<Unit>? units;

  UserInformation({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    this.units,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    var unitsList = json['units'] as List?;
    List<Unit>? units = unitsList?.map((i) => Unit.fromJson(i)).toList();

    return UserInformation(
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      units: units,
    );
  }

  String toJson() {
    return '{"first_name": "$firstName", "last_name": "$lastName", "phone": "$phone", "email": "$email"}';
  }
}

class Unit {
  final String contractId;
  final String projectCode;
  final String unitNumber;
  final String houseNumber;

  Unit({
    required this.contractId,
    required this.projectCode,
    required this.unitNumber,
    required this.houseNumber,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      contractId: json['contract_id'],
      projectCode: json['project_code'],
      unitNumber: json['unit_number'],
      houseNumber: json['house_number'],
    );
  }
}
