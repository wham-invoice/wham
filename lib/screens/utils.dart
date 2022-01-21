import 'package:wham/schema/invoice.dart';
import 'package:wham/schema/user.dart';

class ScreenArguments {
  final User user;

  ScreenArguments(this.user);
}

class InvoiceDetailScreenArguments {
  final User user;
  final Invoice invoice;

  InvoiceDetailScreenArguments(this.invoice, this.user);
}
