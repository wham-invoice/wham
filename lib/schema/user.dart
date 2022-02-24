import '../network/session.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String accessToken;
  final String refreshToken;
  final Session session;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.session,
  });

  factory User.fromJson(Map<String, dynamic> json, Session s) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      session: s,
    );
  }
}
