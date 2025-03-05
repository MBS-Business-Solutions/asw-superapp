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
