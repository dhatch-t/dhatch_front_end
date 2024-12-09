// ignore_for_file: public_member_api_docs, sort_constructors_first
class Login {
  int? id;
  String? phoneNumber;
  String? name;
  String? email;
  String? gender;
  String? otp;
  Login({
    this.id,
    this.phoneNumber,
    this.name,
    this.email,
    this.gender,
    this.otp,
  });

  Map<String, dynamic> tojson() {
    return {
      "phoneNumber": phoneNumber,
      "name": name,
      "gender": gender,
      "email": email
    };
  }

  factory Login.fromjson(Map<String, dynamic> m) {
    return Login(
      email: m['email'],
      gender: m['gender'],
      id: m['id'],
      name: m['name'],
      otp: m['otp'],
      phoneNumber: m['phoneNumber'],
    );
  }
}
