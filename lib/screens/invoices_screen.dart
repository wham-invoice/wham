import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/network/invoices.dart';
import 'package:wham/network/contacts.dart';
import 'package:wham/schema/contact.dart';
import 'package:wham/schema/invoice.dart';
import 'package:wham/screens/invoice_detail_screen.dart';
import 'package:wham/screens/new_invoice_screen.dart';
import 'package:wham/screens/utils.dart';

import '../network/contacts.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({Key? key}) : super(key: key);

  static const routeName = '/invoices';

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> with UiLoggy {
  _refreshData() {
    setState(() {});
  }

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
                  future: InvoiceRequests.user(args.signedInUser.session),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Invoice>> snapshot) {
                    if (snapshot.hasError) {
                      loggy.error(snapshot.error);
                      return PlatformText('Something went wrong');
                    }

                    if (snapshot.connectionState != ConnectionState.done) {
                      return PlatformText("Loading");
                    }

                    List<Invoice> invoices = snapshot.data!;

                    if (invoices.isEmpty) {
                      return PlatformText("Create a new invoice");
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: invoices.length,
                        itemBuilder: (context, index) => PlatformListTile(
                            title: PlatformText(
                                DateFormat('dd-MM-yyyy')
                                    .format(invoices[index].dueDate),
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
                future: ContactRequests.user(args.signedInUser.session),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    loggy.error(snapshot.error);
                    return PlatformText('Something went wrong');
                  }

                  if (snapshot.hasData) {
                    return PlatformTextButtonIcon(
                        onPressed: () async {
                          var shouldRefresh = await Navigator.pushNamed<bool>(
                              context, NewInvoiceScreen.routeName,
                              arguments: NewInvoiceScreenArguments(
                                  snapshot.data as List<Contact>,
                                  args.signedInUser));

                          if (shouldRefresh!) {
                            _refreshData();
                          }
                        },
                        icon: Icon(PlatformIcons(context).add),
                        label: PlatformText("Create Invoice"));
                  }

                  return PlatformText("loading");
                }))
          ],
        ));
  }
}
