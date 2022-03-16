import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/schema/contact.dart';
import 'package:wham/schema/invoice.dart';
import 'package:wham/screens/invoice_detail_screen.dart';
import 'package:wham/screens/new_invoice_screen.dart';
import 'package:wham/screens/utils.dart';

import '../network/requests.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({Key? key}) : super(key: key);

  static const routeName = '/invoices';

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> with UiLoggy {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return PlatformScaffold(
        appBar: PlatformAppBar(),
        iosContentPadding: false,
        iosContentBottomPadding: false,
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: Requests.getInvoices(args.signedInUser.session),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Invoice>> snapshot) {
                    if (snapshot.hasError) {
                      return PlatformText('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return PlatformText("Loading");
                    }

                    List<Invoice> invoices = snapshot.data!;

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: invoices.length,
                        itemBuilder: (context, index) => PlatformListTile(
                            title: PlatformText(
                                invoices[index].dueDate.toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            subtitle: PlatformText(
                                invoices[index].getTotal().toString(),
                                style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () => {
                                  Navigator.pushNamed(
                                      context, InvoiceDetailScreen.routeName,
                                      arguments: InvoiceDetailScreenArguments(
                                          invoices[index], args.signedInUser))
                                }));
                  }),
            ),
            FutureBuilder(
                future: Requests.getContacts(args.signedInUser.session),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return PlatformText('Something went wrong');
                  }

                  if (snapshot.hasData) {
                    return PlatformTextButtonIcon(
                        onPressed: () => Navigator.pushNamed(
                            context, NewInvoiceScreen.routeName,
                            arguments: NewInvoiceScreenArguments(
                                snapshot.data as List<Contact>,
                                args.signedInUser)),
                        icon: Icon(PlatformIcons(context).add),
                        label: PlatformText("Create Invoice"));
                  }

                  return PlatformText("loading");
                }))
          ],
        ));
  }
}
