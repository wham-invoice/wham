import 'package:googleapis_auth/auth_io.dart';
import 'package:wham/utils/session.dart';

class User {
  final String id;
  final String displayName;
  final Session session;

  User(this.id, this.displayName, this.gClient, this.session);
}
