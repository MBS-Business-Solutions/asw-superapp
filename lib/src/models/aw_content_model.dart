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

class Contract {
  final String id;
  final String contractId;
  final String projectCode;
  final String projectName;
  final String unitNumber;
  final bool isDefault;
  final String imageUrl;

  Contract({
    required this.id,
    required this.contractId,
    required this.projectCode,
    required this.projectName,
    required this.unitNumber,
    required this.isDefault,
    required this.imageUrl,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      contractId: json['contract_id'],
      projectCode: json['project_code'],
      projectName: json['project_name'],
      unitNumber: json['unit_number'],
      isDefault: json['is_default'],
      imageUrl: json['image_url'],
    );
  }
}

class ContractDetail {
  final DateTime date;
  final DateTime signDate;
  final DateTime transferDate;
  final int sellingPrice;
  final int cashDiscount;
  final int netPrice;
  final int bookAmount;
  final int contractAmount;
  final int downAmount;
  final int transferAmount;
  final int paymentAmount;
  final int remainDownAmount;
  final int remainAmount;

  ContractDetail({
    required this.date,
    required this.signDate,
    required this.transferDate,
    required this.sellingPrice,
    required this.cashDiscount,
    required this.netPrice,
    required this.bookAmount,
    required this.contractAmount,
    required this.downAmount,
    required this.transferAmount,
    required this.paymentAmount,
    required this.remainDownAmount,
    required this.remainAmount,
  });

  factory ContractDetail.fromJson(Map<String, dynamic> json) {
    return ContractDetail(
      date: DateTime.parse(json['date']),
      signDate: DateTime.parse(json['sign_date']),
      transferDate: DateTime.parse(json['transfer_date']),
      sellingPrice: json['selling_price'],
      cashDiscount: json['cash_discount'],
      netPrice: json['net_price'],
      bookAmount: json['book_amount'],
      contractAmount: json['contract_amount'],
      downAmount: json['down_amount'],
      transferAmount: json['transfer_amount'],
      paymentAmount: json['payment_amount'],
      remainDownAmount: json['remain_down_amount'],
      remainAmount: json['remain_amount'],
    );
  }
}

class PaymentDetail {
  final DateTime date;
  final int amount;
  final String type;
  final String status;
  final String receiptNumber;

  PaymentDetail({
    required this.date,
    required this.amount,
    required this.type,
    required this.status,
    required this.receiptNumber,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      type: json['type'],
      status: json['status'],
      receiptNumber: json['receipt_number'],
    );
  }
}

class OverdueDetail {
  final int amount;
  final String? creditNumber;
  final DateTime? debitDate;
  final DateTime dueDate;

  OverdueDetail({
    required this.amount,
    this.creditNumber,
    this.debitDate,
    required this.dueDate,
  });

  factory OverdueDetail.fromJson(Map<String, dynamic> json) {
    return OverdueDetail(
      amount: json['amount'],
      creditNumber: json['credit_number'],
      debitDate: json['debit_date'] != null ? DateTime.parse(json['debit_date']) : null,
      dueDate: DateTime.parse(json['due_date']),
    );
  }
}

class ReceiptDetail {
  final int amount;
  final DateTime date;
  final String paymentType;
  final String receiptNumber;
  final String ref1;
  final String ref2;
  final DateTime dueDate;

  ReceiptDetail({
    required this.amount,
    required this.date,
    required this.paymentType,
    required this.receiptNumber,
    required this.ref1,
    required this.ref2,
    required this.dueDate,
  });

  factory ReceiptDetail.fromJson(Map<String, dynamic> json) {
    return ReceiptDetail(
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      paymentType: json['payment_type'],
      receiptNumber: json['receipt_number'],
      ref1: json['ref1'],
      ref2: json['ref2'],
      dueDate: DateTime.parse(json['due_date']),
    );
  }
}
