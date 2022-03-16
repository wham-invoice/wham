import '../network/session.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final Session session;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.session,
  });

  factory User.fromJson(Map<String, dynamic> json, Session s) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      session: s,
    );
  }
}

class UserSummary {
  final double invoiceTotal;
  final double invoicePaid;

  UserSummary({
    required this.invoiceTotal,
    required this.invoicePaid,
  });

  UserSummary.fromJson(Map<String, dynamic> json)
      : invoiceTotal = json['total'],
        invoicePaid = json['paid'];

  double unpaidTotal() {
    return invoiceTotal - invoicePaid;
  }
}
