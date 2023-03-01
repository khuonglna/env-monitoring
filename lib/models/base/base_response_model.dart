class BaseResponse {
  dynamic data;
  String? status;
  int? code;
  String? message;

  BaseResponse({
    this.data,
    this.status,
    this.code,
    this.message,
  });

  BaseResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    status = json['status'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data?.toJson();
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
