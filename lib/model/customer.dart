// ignore_for_file: public_member_api_docs, sort_constructors_first
class Customer {
  String? customerPhoneNumber;
  String? customerName;
  String? customerGender;
  String? customerEmail;

  Customer({
    this.customerPhoneNumber,
    this.customerName,
    this.customerGender,
    this.customerEmail,
  });

  Map<String, dynamic> tojson() {
    return {
      "customerPhoneNumber": customerPhoneNumber,
      "customerName": customerName,
      "customerGender": customerGender,
      "customerEmail": customerEmail
    };
  }

  factory Customer.fromjson(Map<String, dynamic> m) {
    return Customer(
      customerEmail: m['customerEmail'],
      customerGender: m['customerGender'],
      customerName: m['customerName'],
      customerPhoneNumber: m['customerPhoneNumber'],
    );
  }
}
