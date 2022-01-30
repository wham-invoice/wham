import 'dart:convert';

import 'package:googleapis/gmail/v1.dart';
import 'package:wham/schema/user.dart';
import 'package:wham/schema/contact.dart';

class Email {
  static String fromUser = "me";

  static sendEmailAsUser(
      User user,
      Contact to,
      String subject,
      String contentType,
      String charset,
      String contentTransferEncoding,
      String emailContent) async {
    GmailApi gmailApi = GmailApi(user.gClient);

    String receiptiantAddress = to.email;

    await gmailApi.users.messages.send(
        Message.fromJson({
          'raw': getBase64Email(
              source: 'From: $fromUser\r\n'
                  'To: $receiptiantAddress\r\n'
                  'Subject: $subject\r\n'
                  'Content-Type: $contentType; charset=$charset\r\n'
                  'Content-Transfer-Encoding: $contentTransferEncoding\r\n\r\n'
                  '$emailContent'),
        }),
        fromUser);
  }

  static String getBase64Email({String source = ""}) {
    List<int> bytes = utf8.encode(source);

    return base64UrlEncode(bytes);
  }
}
