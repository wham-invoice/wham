class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        phone = json['phone'],
        email = json['email'];

  get fullName => "$firstName $lastName";
}
