import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/network/invoices.dart';
import 'package:wham/screens/utils.dart';
import 'package:wham/schema/invoice.dart';
import 'package:wham/schema/user.dart';
import 'package:wham/schema/contact.dart';

class InvoiceDetailScreen extends StatelessWidget with UiLoggy {
  const InvoiceDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/invoice-details';

  final emailSuccessSB =
      const SnackBar(content: Text('Invoice emailed successfully.'));
  final emailFailSB = const SnackBar(content: Text('Unable to send invoice.'));

  final deleteSuccessSB =
      const SnackBar(content: Text('Invoice deleted successfully.'));
  final deleteFailSB =
      const SnackBar(content: Text('Unable to delete invoice.'));

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as InvoiceDetailScreenArguments;

    final Invoice invoice = args.invoice;
    final User user = args.signedInUser;
    final Contact invoiceClient = args.contact;

    final num total = invoice.hours * invoice.rate;
    final num gst = double.parse((total * 0.15).toStringAsFixed(2));
    final num acc = double.parse((total * 0.013).toStringAsFixed(2));
    final num tax = double.parse((total * 0.4).toStringAsFixed(2));
    final num studentLoan = double.parse((total * 0.12).toStringAsFixed(2));
    final num takeHome = total - gst - acc - tax - studentLoan;

    return PlatformScaffold(
      appBar: PlatformAppBar(),
      iosContentPadding: false,
      iosContentBottomPadding: false,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child:
                  invoice.paid ? PlatformText("Paid") : PlatformText("Unpaid"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: PlatformText("Client: ${invoiceClient.fullName} "),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: PlatformText("Hours: ${invoice.hours} "),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: PlatformText("Total: \$$total "),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: PlatformText("Take Home: \$$takeHome "),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: PlatformElevatedButton(
                onPressed: () async {
                  final response =
                      await InvoiceRequests.sendEmail(user.session, invoice.id);
                  if (response.statusCode == 204) {
                    ScaffoldMessenger.of(context).showSnackBar(emailSuccessSB);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(emailFailSB);
                    loggy
                        .error("unable to send invoice ${response.statusCode}");
                  }
                },
                child: const Text('Email Invoice'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: PlatformElevatedButton(
                onPressed: () async {
                  try {
                    await InvoiceRequests.delete(user.session, invoice.id);
                    ScaffoldMessenger.of(context).showSnackBar(deleteSuccessSB);

                    Navigator.of(context).pop(true);
                  } catch (e) {
                    loggy.error("unable to delete invoice $e");
                    ScaffoldMessenger.of(context).showSnackBar(deleteFailSB);
                  }
                },
                child: const Text('Delete'),
              ),
            ),
          ])),
    );
  }
}
