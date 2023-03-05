class AuthInfo {
  int? userId;
  String? accessKey;
  AuthInfo._();

  static AuthInfo instance = AuthInfo._();

  factory AuthInfo() {
    return instance;
  }

  AuthInfo.fromJson(Map<String, dynamic> json) {
    instance.userId = json['user_id'];
    instance.accessKey = json['access_key'];
  }

  Map<String, dynamic> get authQuery => {
        'user_id': instance.userId,
        'access_key': instance.accessKey,
      };
}
