class Contact {
  final String id;
  final String userID;
  final String firstName;
  final String lastName;
  final String email;

  Contact({
    required this.id,
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userID = json['user_id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'user_id': userID,
        'first_name': firstName,
        'last_name': lastName,
        'email': email
      };

  get fullName => "$firstName $lastName";
}
