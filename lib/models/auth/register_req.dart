class RegisterReq {
  String? userName;
  String? password;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;

  RegisterReq({
    this.userName,
    this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
  });

  RegisterReq.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['password'] = password;
    data['firstname'] = firstName;
    data['lastname'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}
