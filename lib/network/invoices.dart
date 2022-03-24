import 'dart:convert';

import 'package:wham/network/session.dart';
import 'package:wham/network/util.dart';
import 'package:http/http.dart' as http;

import '../schema/invoice.dart';

class InvoiceRequests {
  static Future<void> create(
    Session s,
    String contactID,
    String description,
    double hours,
    double rate,
    DateTime dueDate,
  ) async {
    final resp = await s.post(
      '/invoice/new',
      jsonEncode({
        'contact_id': contactID,
        'description': description,
        'hours': hours,
        'rate': rate,
        'due_date': dueDate,
      }, toEncodable: customEncode),
    );

    if (resp.statusCode != 200) {
      throw Exception("${resp.statusCode} ${resp.reasonPhrase}");
    }
  }

  static Future<Invoice> get(
    Session s,
    String invoiceID,
  ) async {
    final resp = await s.get(
      '/invoice/get/$invoiceID',
    );

    if (resp.statusCode != 200) {
      throw Exception(
          "platform error: ${resp.statusCode} ${resp.reasonPhrase}");
    }

    final Invoice invoice;
    try {
      invoice = Invoice.fromJson(jsonDecode(resp.body));
    } catch (e) {
      throw Exception("platform error: unable to decode body - $e");
    }

    return invoice;
  }

  static Future<void> delete(
    Session s,
    String invoiceID,
  ) async {
    final resp = await s.delete(
      '/invoice/delete/$invoiceID',
    );

    if (resp.statusCode != 204) {
      throw Exception(
          "platform error: ${resp.statusCode} ${resp.reasonPhrase}");
    }
  }

  static Future<http.Response> sendEmail(
    Session s,
    String invoiceID,
  ) =>
      s.post(
        '/invoice/email',
        jsonEncode({
          'invoice_id': invoiceID,
        }),
      );

  static Future<List<Invoice>> user(
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
      throw Exception("platform error: unable to decode body - $e");
    }

    return invoices;
  }
}
