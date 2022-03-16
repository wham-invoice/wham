import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:wham/schema/user.dart';

class InvoiceSummary extends StatelessWidget {
  final UserSummary summary;
  const InvoiceSummary(this.summary, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlatformText(
          summary.invoiceTotal.toString() + " incl GST",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        PlatformText(
          summary.unpaidTotal().toString() + " incl GST",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
