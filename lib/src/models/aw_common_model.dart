class ServiceResponse {
  int? code;
  String status;
  String? message;

  ServiceResponse({
    this.code,
    required this.status,
    this.message,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      code: json['code'],
      status: json['status'],
      message: json['message'].toString(),
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

class ServiceResponseWithData<T> extends ServiceResponse {
  T? data;

  ServiceResponseWithData({
    super.code,
    required super.status,
    super.message,
    this.data,
  });

  factory ServiceResponseWithData.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ServiceResponseWithData(
      code: json['code'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}

class KeyValue {
  final int id;
  final String value;
  final String? image;

  KeyValue({required this.id, required this.value, this.image});

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue(
      id: json['id'],
      value: json['value'] ?? json['name'],
      image: json['image'],
    );
  }
}
