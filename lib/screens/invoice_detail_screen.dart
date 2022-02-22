import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:loggy/loggy.dart';
import 'package:wham/screens/utils.dart';
import 'package:wham/screens/home_screen.dart';
import 'package:wham/utils/email.dart';
import 'package:wham/schema/invoice.dart';
import 'package:wham/schema/user.dart';
import 'package:wham/schema/contact.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/invoice-details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as InvoiceDetailScreenArguments;
    final invoice = args.invoice;

    return PlatformScaffold(
        appBar: PlatformAppBar(),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: invoice.getContact(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    //TODO gracefully exit
                    developer.log("unable to get contact",
                        error: snapshot.error);
                  }
                  if (snapshot.hasData) {
                    return InvoiceDisplay(
                        invoice: args.invoice,
                        invoiceClient: snapshot.data! as Contact,
                        user: args.user);
                  }
                  return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ));
                })));
  }
}

class InvoiceDisplay extends StatelessWidget with UiLoggy {
  final Invoice invoice;
  final User user;
  final Contact invoiceClient;

  final emailedInvoiceSB =
      const SnackBar(content: Text('Invoice emailed successfully.'));

  const InvoiceDisplay(
      {Key? key,
      required this.invoice,
      required this.user,
      required this.invoiceClient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double total = invoice.hours * invoice.rate;
    final double gst = double.parse((total * 0.15).toStringAsFixed(2));
    final double acc = double.parse((total * 0.013).toStringAsFixed(2));
    final double tax = double.parse((total * 0.4).toStringAsFixed(2));
    final double studentLoan = double.parse((total * 0.12).toStringAsFixed(2));
    final double takeHome = total - gst - acc - tax - studentLoan;
    final double fireBucket = double.parse((takeHome * 0.2).toStringAsFixed(2));
    final double splurgeBucket =
        double.parse((takeHome * 0.1).toStringAsFixed(2));
    final double smileBucket =
        double.parse((takeHome * 0.1).toStringAsFixed(2));
    final double dailyBucket =
        double.parse((takeHome * 0.6).toStringAsFixed(2));

    return ConstrainedBox(
        constraints: const BoxConstraints(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: PlatformText("Hours: ${invoice.hours} "),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: PlatformText("Total: \$$total "),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: PlatformText("Splurge: \$$splurgeBucket "),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: PlatformText("Smile: \$$smileBucket "),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: PlatformText("Fire: \$$fireBucket "),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: PlatformText("Daily: \$$dailyBucket "),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: PlatformElevatedButton(
                  onPressed: () async {
                    try {
                      //  await Email.sendEmailAsUser(
                      //      signedInUser,
                      //      invoiceClient,
                      //      Email.defaultMessageSubject,
                      //      Email.defaultMessageBody);

                      Email.sendInvoiceEmail(user.session, invoice.id!);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(emailedInvoiceSB);
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName,
                          arguments: ScreenArguments(user));
                    } catch (e) {
                      loggy.error(e);
                    }
                  },
                  child: const Text('Email Invoice'),
                ),
              ),
            ]));
  }
}
