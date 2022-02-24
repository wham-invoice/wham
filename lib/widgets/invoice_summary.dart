import 'package:enough_platform_widgets/enough_platform_widgets.dart';

// TODO this widget shows a summary of invoices.
// 1. Total invoices
// 2. Unpaid amount.
//

import 'package:flutter/material.dart';

class InvoiceSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlatformText(
          '\$100,234',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        PlatformText(
          'unpaid: \$10,234',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
