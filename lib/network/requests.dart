import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wham/schema/contact.dart';

import 'package:wham/schema/user.dart';
import '../schema/invoice.dart';
import 'session.dart';

class Requests {
  static Future<User> platformLogin(
    Session s,
    String uid,
    String code,
    String idToken,
  ) async {
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
        '/invoice/new',
        jsonEncode({
          'contact_id': contactID,
          'description': description,
          'hours': hours,
          'rate': rate,
        }),
      );

  static Future<http.Response> createContact(
    Session s,
    String firstName,
    String lastName,
    String email,
  ) =>
      s.post(
        '/contact/new',
        jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        }),
      );

  static Future<http.Response> sendInvoiceEmail(
    Session s,
    String invoiceID,
  ) =>
      s.post(
        '/invoice/email',
        jsonEncode({
          'invoice_id': invoiceID,
        }),
      );

  static Future<Contact> getContact(
    Session s,
    String contactID,
  ) async {
    final resp = await s.get(
      '/contact/get/$contactID',
    );

    if (resp.statusCode != 200) {
      throw Exception(
          "platform error: ${resp.statusCode} ${resp.reasonPhrase}");
    }

    final Contact contact;
    try {
      contact = Contact.fromJson(jsonDecode(resp.body));
    } catch (e) {
      throw Exception("platform error: ${resp.body}");
    }

    return contact;
  }

  static Future<Invoice> getInvoice(
    Session s,
    String invoiceID,
  ) async {
    final resp = await s.get(
      '/contact/get/$invoiceID',
    );

    if (resp.statusCode != 200) {
      throw Exception(
          "platform error: ${resp.statusCode} ${resp.reasonPhrase}");
    }

    final Invoice invoice;
    try {
      invoice = Invoice.fromJson(jsonDecode(resp.body));
    } catch (e) {
      throw Exception("platform error: ${resp.body}");
    }

    return invoice;
  }

  static Future<List<Contact>> getContacts(
    Session s,
  ) async {
    final resp = await s.get(
      '/user/contacts',
    );

    if (resp.statusCode != 200) {
      throw Exception(
          "platform error: ${resp.statusCode} ${resp.reasonPhrase}");
    }

    final List<Contact> contacts;

    try {
      final List list = json.decode(resp.body);
      contacts = list.map((item) => Contact.fromJson(item)).toList();
    } catch (e) {
      throw Exception("platform error: ${resp.body}");
    }

    return contacts;
  }

  static Future<List<Invoice>> getInvoices(
    Session s,
  ) async {
    final resp = await s.get(
      '/user/invoices',
    );

    if (resp.statusCode != 200) {
      throw Exception(
          "platform error: ${resp.statusCode} ${resp.reasonPhrase}");
    }

    final List<Invoice> invoices;
    try {
      final List list = json.decode(resp.body);
      invoices = list.map((item) => Invoice.fromJson(item)).toList();
    } catch (e) {
      throw Exception("platform error: ${resp.body}");
    }

    return invoices;
  }

  static Future<UserSummary> getSummary(
    Session s,
  ) async {
    final resp = await s.get(
      '/user/summary',
    );

    if (resp.statusCode != 200) {
      throw Exception(
          "platform error: ${resp.statusCode} ${resp.reasonPhrase}");
    }

    final UserSummary summary;
    try {
      final body = json.decode(resp.body);
      summary = UserSummary.fromJson(body);
    } catch (e) {
      throw Exception("platform error: ${resp.body}");
    }

    return summary;
  }
}
