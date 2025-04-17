class ServiceResponse {
  String status;
  String? message;

  ServiceResponse({
    required this.status,
    this.message,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

class MyQRResponse {
  int code;
  String? status;
  String? qrCode;
  String? ref;
  String? message;

  MyQRResponse({
    required this.code,
    this.status,
    this.message,
    this.qrCode,
    this.ref,
  });

  factory MyQRResponse.fromJson(Map<String, dynamic> json) {
    return MyQRResponse(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      qrCode: json['data']?['qr_code'],
      ref: json['data']?['ref'],
    );
  }
}

class ServiceResponseWithData<T> {
  String status;
  String? message;
  T? data;

  ServiceResponseWithData({
    required this.status,
    this.message,
    this.data,
  });

  factory ServiceResponseWithData.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ServiceResponseWithData(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
