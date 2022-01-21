import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:wham/screens/utils.dart';
import 'package:wham/utils/email.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/invoice-details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as InvoiceDetailScreenArguments;
    final invoice = args.invoice;

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

    return PlatformScaffold(
      appBar: PlatformAppBar(),
      body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: const BoxConstraints(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: PlatformText("Hours: ${invoice.hours} "),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: PlatformText("Total: \$$total "),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: PlatformText("Splurge: \$$splurgeBucket "),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: PlatformText("Smile: \$$smileBucket "),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: PlatformText("Fire: \$$fireBucket "),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: PlatformText("Daily: \$$dailyBucket "),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: PlatformElevatedButton(
                        onPressed: () => Email.sendEmail(
                            args.user,
                            "me",
                            "rstorr95@gmail.com",
                            "congrats! on email functionality",
                            "text/html",
                            "utf-8",
                            "base64",
                            "testing !!! \n\n helloo!"),
                        child: const Text('Email Invoice'),
                      ),
                    ),
                  ]))),
    );
  }
}
