class UserModel {
  final String id;
  final String email;
  final String password;
  UserModel({required this.id, required this.email, required this.password});

  Map<String, String> toJson() {
    return {"id": id, "email": email, "password": password};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"].toString(),
      email: json["email"].toString(),
      password: json["password"].toString(),
    );
  }
}

class UserSignUpDTO {
  final String email;
  final String password;
  UserSignUpDTO({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }
}
