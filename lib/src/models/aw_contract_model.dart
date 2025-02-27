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
  final int sellingPrice;
  final int cashDiscount;
  final int cashDiscountTransfer;
  final int netPrice;
  final int bookAmount;
  final int contractAmount;
  final int downAmount;
  final int transferAmount;
  final int paymentAmount;
  final int remainDownAmount;
  final int remainAmount;
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
      sellingPrice: json['selling_price'],
      cashDiscount: json['cash_discount'],
      cashDiscountTransfer: 9999999, //json['cash_discount_transfer'],
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

class DownPaymentDetail {
  final String termCode;
  final String termName;
  final DateTime dueDate;
  final int amount;
  final String status;
  final List<ShortPaymentDetail> payments;

  DownPaymentDetail({
    required this.termCode,
    required this.termName,
    required this.dueDate,
    required this.amount,
    required this.status,
    required this.payments,
  });

  factory DownPaymentDetail.fromJson(Map<String, dynamic> json) {
    var paymentsFromJson = json['payments'] as List;
    List<ShortPaymentDetail> paymentList = paymentsFromJson.map((i) => ShortPaymentDetail.fromJson(i)).toList();

    return DownPaymentDetail(
      termCode: json['term_code'],
      termName: json['term_name'],
      dueDate: DateTime.parse(json['due_date']),
      amount: json['amount'],
      status: json['status'],
      payments: paymentList,
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
  final int amount;
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
      amount: json['amount'],
      termCode: json['term_code'],
      termName: json['term_name'],
    );
  }
}
