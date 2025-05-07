import 'package:AssetWise/src/utils/common_util.dart';

class Contract {
  final String id;
  final String contractId;
  final String? contractNumber;
  final String projectCode;
  final String projectName;
  final String unitNumber;
  final bool isDefault;
  final bool isResident;
  final String imageUrl;

  Contract({
    required this.id,
    required this.contractId,
    required this.contractNumber,
    required this.projectCode,
    required this.projectName,
    required this.unitNumber,
    required this.isDefault,
    required this.isResident,
    required this.imageUrl,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      contractId: json['contract_id'],
      contractNumber: json['contract_number'],
      projectCode: json['project_code'],
      projectName: json['project_name'],
      unitNumber: json['unit_number'],
      isDefault: json['is_default'],
      isResident: json['is_resident'],
      imageUrl: json['image_url'],
    );
  }
}

class ContractDetail {
  final DateTime date;
  final DateTime signDate;
  final DateTime transferDate;
  final double sellingPrice;
  final double cashDiscount;
  final double cashDiscountTransfer;
  final double netPrice;
  final double bookAmount;
  final double contractAmount;
  final double downAmount;
  final double transferAmount;
  final double paymentAmount;
  final double remainDownAmount;
  final double remainAmount;
  List<String>? freebies;

  ContractDetail({
    required this.date,
    required this.signDate,
    required this.transferDate,
    required this.sellingPrice,
    required this.cashDiscount,
    required this.cashDiscountTransfer,
    required this.netPrice,
    required this.bookAmount,
    required this.contractAmount,
    required this.downAmount,
    required this.transferAmount,
    required this.paymentAmount,
    required this.remainDownAmount,
    required this.remainAmount,
    this.freebies,
  });

  factory ContractDetail.fromJson(Map<String, dynamic> json) {
    return ContractDetail(
      date: DateTime.parse(json['date']),
      signDate: DateTime.parse(json['sign_date']),
      transferDate: DateTime.parse(json['transfer_date']),
      sellingPrice: CommonUtil.parseDouble(json['selling_price']),
      cashDiscount: CommonUtil.parseDouble(json['cash_discount']),
      cashDiscountTransfer: CommonUtil.parseDouble(json['transfer_discount']),
      netPrice: CommonUtil.parseDouble(json['net_price']),
      bookAmount: CommonUtil.parseDouble(json['book_amount']),
      contractAmount: CommonUtil.parseDouble(json['contract_amount']),
      downAmount: CommonUtil.parseDouble(json['down_amount']),
      transferAmount: CommonUtil.parseDouble(json['transfer_amount']),
      paymentAmount: CommonUtil.parseDouble(json['payment_amount']),
      remainDownAmount: CommonUtil.parseDouble(json['remain_down_amount']),
      remainAmount: CommonUtil.parseDouble(json['remain_amount']),
    );
  }
}

class PaymentDetail {
  final DateTime date;
  final double amount;
  final String? type;
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
      amount: CommonUtil.parseDouble(json['amount']),
      type: json['type'],
      status: json['status'],
      receiptNumber: json['receipt_number'],
    );
  }
}

class OverdueDetail {
  final double amount;
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
      amount: CommonUtil.parseDouble(json['amount']),
      creditNumber: json['credit_number'],
      debitDate: json['debit_date'] != null ? DateTime.parse(json['debit_date']) : null,
      dueDate: DateTime.parse(json['due_date']),
    );
  }
}

class ReceiptDetail {
  final double amount;
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
      amount: CommonUtil.parseDouble(json['amount']),
      date: DateTime.parse(json['date']),
      paymentType: json['payment_type'],
      receiptNumber: json['receipt_number'],
      ref1: json['ref1'],
      ref2: json['ref2'],
      dueDate: DateTime.parse(json['due_date']),
    );
  }
}

class DownPaymentDetail {
  final String termCode;
  final String termName;
  final DateTime dueDate;
  final double amount;
  final String status;
  final List<ShortPaymentDetail> payments;
  final String? statusCode;

  DownPaymentDetail({
    required this.termCode,
    required this.termName,
    required this.dueDate,
    required this.amount,
    required this.status,
    required this.payments,
    required this.statusCode,
  });

  factory DownPaymentDetail.fromJson(Map<String, dynamic> json) {
    var paymentsFromJson = json['payments'] as List;
    List<ShortPaymentDetail> paymentList = paymentsFromJson.map((i) => ShortPaymentDetail.fromJson(i)).toList();

    return DownPaymentDetail(
      termCode: json['term_code'],
      termName: json['term_name'],
      dueDate: DateTime.parse(json['due_date']),
      amount: CommonUtil.parseDouble(json['amount']),
      status: json['status'],
      payments: paymentList,
      statusCode: json['status_code'],
    );
  }
}

class ShortPaymentDetail {
  final String paymentType;
  final String receiptNumber;

  ShortPaymentDetail({
    required this.paymentType,
    required this.receiptNumber,
  });

  factory ShortPaymentDetail.fromJson(Map<String, dynamic> json) {
    return ShortPaymentDetail(
      paymentType: json['payment_type'],
      receiptNumber: json['receipt_number'],
    );
  }
}

class DownPaymentTermDue {
  final DateTime dueDate;
  final double amount;
  final String termCode;
  final String termName;

  DownPaymentTermDue({
    required this.dueDate,
    required this.amount,
    required this.termCode,
    required this.termName,
  });

  factory DownPaymentTermDue.fromJson(Map<String, dynamic> json) {
    return DownPaymentTermDue(
      dueDate: DateTime.parse(json['due_date']),
      amount: CommonUtil.parseDouble(json['amount']),
      termCode: json['term_code'],
      termName: json['term_name'],
    );
  }
}

class ContractProject {
  final String id;
  final String name;

  ContractProject({
    required this.id,
    required this.name,
  });

  factory ContractProject.fromJson(Map<String, dynamic> json) {
    return ContractProject(
      id: json['id'],
      name: json['name'],
    );
  }
}

class PaymentGatewayResponse {
  final String status;
  final int code;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final String? paymentUrl;

  PaymentGatewayResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.timestamp,
    required this.path,
    this.paymentUrl,
  });

  factory PaymentGatewayResponse.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayResponse(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      timestamp: DateTime.tryParse(json['timestamp'] ?? ''),
      path: json['path'],
      paymentUrl: json['data']?['payment_url'],
    );
  }
}

class QRResponse {
  final String status;
  final int code;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final String? qrCode;

  QRResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.timestamp,
    required this.path,
    this.qrCode,
  });

  factory QRResponse.fromJson(Map<String, dynamic> json) {
    return QRResponse(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      timestamp: DateTime.tryParse(json['timestamp'] ?? ''),
      path: json['path'],
      qrCode: json['data']?['qr_code'],
    );
  }
}
