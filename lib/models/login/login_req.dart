class LoginReq {
  String? userName;
  String? password;
  String? deviceId;

  LoginReq({
    this.userName,
    this.password,
    this.deviceId,
  });

  LoginReq.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['password'] = password;
    data['deviceId'] = deviceId;
    return data;
  }
}
