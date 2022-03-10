import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:wham/schema/user.dart';
import 'session.dart';

class Requests {
  static Future<User> platformLogin(
    Session s,
    String uid,
    String code,
    String idToken,
  ) async {
    final resp = await s.post(
        'http://localhost:8080/auth',
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
      throw Exception("platform error: ${resp.body}");
    }

    return user;
  }

  static Future<http.Response> createInvoice(
    Session s,
    String contactID,
    String description,
    double hours,
    double rate,
  ) =>
      s.post(
        'http://localhost:8080/invoice/new',
        jsonEncode({
          'contact_id': contactID,
          'description': description,
          'hours': hours,
          'rate': rate,
        }),
      );

  static Future<http.Response> sendInvoiceEmail(
    Session s,
    String invoiceID,
  ) =>
      s.post(
        'http://localhost:8080/invoice/email',
        jsonEncode({
          'invoice_id': invoiceID,
        }),
      );
}
