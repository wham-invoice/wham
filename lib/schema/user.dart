import 'package:googleapis_auth/auth_io.dart';

class User {
  final String id;
  final String displayName;
  final AuthClient gClient;

  User(this.id, this.displayName, this.gClient);
}
