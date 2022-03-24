import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wham/schema/user.dart';

class InvoiceSummary extends StatelessWidget {
  final UserSummary summary;
  InvoiceSummary(this.summary, {Key? key}) : super(key: key);

  final currencyFormatter = NumberFormat("###.00#", 'en_US');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlatformText(
          "\$" + currencyFormatter.format(summary.invoiceTotal) + " incl gst",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        PlatformText(
          "unpaid: \$" +
              currencyFormatter.format(summary.unpaidTotal()) +
              " incl gst",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
