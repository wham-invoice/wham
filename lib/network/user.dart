import 'dart:convert';

import 'package:wham/network/session.dart';

import '../schema/user.dart';

class UserRequests {
  static Future<User> login(
    String uid,
    String code,
    String idToken,
  ) async {
    final Session s = Session();
    final resp = await s.post(
        '/auth',
        jsonEncode(
            <String, String>{'uid': uid, 'code': code, 'id_token': idToken}));

    if (resp.statusCode != 200) {
      throw Exception(
          "platform error: ${resp.statusCode} ${resp.reasonPhrase}");
    }

    final User user;
    try {
      user = User.fromJson(jsonDecode(resp.body), s);
    } catch (e) {
      throw Exception("platform error: unable to decode body - $e");
    }

    return user;
  }

  static Future<UserSummary> summary(
    Session s,
  ) async {
    final resp = await s.get(
      '/user/summary',
    );

    if (resp.statusCode == 204) {
      return UserSummary(invoiceTotal: 0.0, invoicePaid: 0.0);
    }

    if (resp.statusCode != 200) {
      throw Exception(
          "platform error: expected 200 got ${resp.statusCode} reason: ${resp.reasonPhrase}");
    }

    final UserSummary summary;
    try {
      summary = UserSummary.fromJson(jsonDecode(resp.body));
    } catch (e) {
      throw Exception("platform error: unable to decode body - $e");
    }

    return summary;
  }
}
