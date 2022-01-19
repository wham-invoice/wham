import 'package:googleapis/gmail/v1.dart';
import 'package:wham/schema/user.dart';

class Email {
  static sendEmail(User user) {
    GmailApi gmailApi = GmailApi(user.gClient);

    print("send email TBD..");
  }
}
