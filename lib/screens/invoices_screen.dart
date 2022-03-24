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
import 'package:tuple/tuple.dart';

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

  Future<Tuple2<List<Invoice>, List<Contact>>> _getData(session) async {
    final List<Invoice> invoices = await InvoiceRequests.user(session);
    final List<Contact> contacts = await ContactRequests.user(session);
    return Tuple2(invoices, contacts);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return PlatformScaffold(
        appBar: PlatformAppBar(),
        iosContentPadding: false,
        iosContentBottomPadding: false,
        body: FutureBuilder<Tuple2<List<Invoice>, List<Contact>>>(
          future: _getData(args.signedInUser.session),
          builder: (BuildContext context,
              AsyncSnapshot<Tuple2<List<Invoice>, List<Contact>>> snapshot) {
            if (snapshot.hasError) {
              loggy.error(snapshot.error);
              return PlatformText('Something went wrong');
            }

            if (snapshot.connectionState != ConnectionState.done ||
                snapshot.data == null) {
              return PlatformText("Loading");
            }

            List<Invoice> invoices = snapshot.data!.item1;
            List<Contact> contacts = snapshot.data!.item2;

            if (invoices.isEmpty) {
              return PlatformText("Create a new invoice");
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      // TODO handle better if there are no contacts
                      Contact contact = contacts
                          .firstWhere((c) => c.id == invoices[index].contactID);

                      return PlatformListTile(
                          title: PlatformText(
                              DateFormat('dd-MM-yyyy')
                                  .format(invoices[index].dueDate),
                              style: Theme.of(context).textTheme.headlineSmall),
                          subtitle: PlatformText(
                              invoices[index].getTotal().toString(),
                              style: Theme.of(context).textTheme.bodyMedium),
                          onTap: () async {
                            var shouldRefresh = await Navigator.pushNamed<bool>(
                                context, InvoiceDetailScreen.routeName,
                                arguments: InvoiceDetailScreenArguments(
                                  invoices[index],
                                  contact,
                                  args.signedInUser,
                                ));

                            if (shouldRefresh!) {
                              _refreshData();
                            }
                          });
                    },
                  ),
                ),
                PlatformTextButtonIcon(
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
                    label: PlatformText("Create Invoice")),
              ],
            );
          },
        ));
  }
}
