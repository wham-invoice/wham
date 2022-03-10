import 'package:wham/schema/invoice.dart';
import 'package:wham/schema/user.dart';
import 'package:wham/schema/contact.dart';

class ScreenArguments {
  final User signedInUser;

  ScreenArguments(this.signedInUser);
}

class InvoiceDetailScreenArguments {
  final User signedInUser;
  final Invoice invoice;

  InvoiceDetailScreenArguments(this.invoice, this.signedInUser);
}

class NewInvoiceScreenArguments {
  final User signedInUser;
  final List<Contact> contacts;

  NewInvoiceScreenArguments(this.contacts, this.signedInUser);
}
