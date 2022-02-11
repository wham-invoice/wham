import 'dart:convert';

import 'package:googleapis/gmail/v1.dart';
import 'package:wham/schema/user.dart';
import 'package:wham/schema/contact.dart';

class Email {
  static String fromUser = "me";
  static String defaultMessageSubject = "Default Subject...";
  static String defaultMessageBody = "Default Body...";

  //sendEmailAsUser sends a text/html email from 'user' to 'receiptiant'
  static sendEmailAsUser(
      User user, Contact receiptiant, String subject, String body) async {
    GmailApi _gmailApi = GmailApi(user.gClient);

    String _receiptiantAddress = receiptiant.email;

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

  static String _getBase64Email({String source = ""}) {
    List<int> bytes = utf8.encode(source);

    return base64UrlEncode(bytes);
  }
}
