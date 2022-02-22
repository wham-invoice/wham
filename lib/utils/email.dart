import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:googleapis/gmail/v1.dart';
import 'package:wham/schema/user.dart';
import 'package:wham/schema/contact.dart';
import 'package:wham/utils/session.dart';

class Email {
  static String fromUser = "me";
  static String defaultMessageSubject = "Default Subject...";
  static String defaultMessageBody = "Default Body...";

  //sendEmailAsUser sends a text/html email from 'user' to 'receiptiant'
  /**
  static sendEmailAsUser(
      User user, Contact receiptiant, String subject, String body) async {
    GmailApi _gmailApi = GmailApi(user.gClient);

    String _receiptiantAddress = receiptiant.email;

    // TODO this should be moved to wham-platform.
    await _gmailApi.users.messages.send(
        Message.fromJson({
          'raw': _getBase64Email(
              source: 'From: $fromUser\r\n'
                  'To: $_receiptiantAddress\r\n'
                  'Subject: $subject\r\n'
                  'Content-Type: text/html; charset=utf-8\r\n'
                  'Content-Transfer-Encoding: base64\r\n\r\n'
                  '$body'),
        }),
        fromUser);
  }
  **/

  static sendInvoiceEmail(Session s, String invoiceID) async {
    http.Response resp = await s.post(
      'http://localhost:8080/invoice/email',
      jsonEncode(<String, String>{
        'invoice_id': invoiceID,
      }),
    );

    print(resp.statusCode);
  }

  static String _getBase64Email({String source = ""}) {
    List<int> bytes = utf8.encode(source);

    return base64UrlEncode(bytes);
  }
}
