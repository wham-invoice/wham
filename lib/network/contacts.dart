import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wham/network/session.dart';
import '../schema/contact.dart';

class ContactRequests {
  static Future<List<Contact>> user(
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
      throw Exception("platform error: unable to decode body - $e");
    }

    return contacts;
  }

  static Future<http.Response> create(
    Session s,
    String firstName,
    String lastName,
    String phone,
    String email,
  ) =>
      s.post(
        '/contact/new',
        jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'email': email,
        }),
      );

  static Future<Contact> get(
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
      throw Exception("platform error: unable to decode body - $e");
    }

    return contact;
  }

  static Future<void> delete(
    Session s,
    String invoiceID,
  ) async {
    final resp = await s.get(
      '/invoice/delete/$invoiceID',
    );

    if (resp.statusCode != 204) {
      throw Exception(
          "platform error: ${resp.statusCode} ${resp.reasonPhrase}");
    }
  }
}
