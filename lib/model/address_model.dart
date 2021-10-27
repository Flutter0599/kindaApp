class Address {
  late String fisrtName;
  late String lastName;
  late String phone;
  late String city;
  late String zipCode;

  Address({
    required this.fisrtName,
    required this.lastName,
    required this.phone,
    required this.city,
    required this.zipCode,
  });

  Address.fromJson(Map<String, dynamic> data) {
    fisrtName = data['first_name'];
    lastName = data['last_name'];
    phone = data['phone'];
    city = data['city'];
    zipCode = data['zip_code'];
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': fisrtName,
      'last_name': lastName,
      'phone': phone,
      'city': city,
      'zip_code': zipCode,
    };
  }
}
