import 'dart:convert';

import 'package:loggy/loggy.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:wham/schema/user.dart';

class Email with UiLoggy {
  static sendEmail(User user, String from, to, subject, contentType, charset,
      contentTransferEncoding, emailContent) async {
    GmailApi gmailApi = GmailApi(user.gClient);

    await gmailApi.users.messages.send(
        Message.fromJson({
          'raw': getBase64Email(
              source: 'From: $from\r\n'
                  'To: $to\r\n'
                  'Subject: $subject\r\n'
                  'Content-Type: $contentType; charset=$charset\r\n'
                  'Content-Transfer-Encoding: $contentTransferEncoding\r\n\r\n'
                  '$emailContent'),
        }),
        from);

    print("email sent ");
  }

  static String getBase64Email({String source = ""}) {
    List<int> bytes = utf8.encode(source);

    return base64UrlEncode(bytes);
  }
}
