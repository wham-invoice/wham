import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/schema/contact.dart';
import 'package:wham/screens/new_contact_screen.dart';
import 'package:wham/screens/utils.dart';

import '../network/contacts.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  static const routeName = '/contacts';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> with UiLoggy {
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
                  future: ContactRequests.user(args.signedInUser.session),
                  builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
                    if (snapshot.hasError) {
                      loggy.error(snapshot.error);
                      return PlatformText('Something went wrong');
                    }

                    if (snapshot.connectionState != ConnectionState.done) {
                      return PlatformText("Loading");
                    }

                    List<Contact> contacts = snapshot.data!;

                    if (contacts.isEmpty) {
                      return PlatformText("Create a new contact");
                    }

                    return ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) => PlatformListTile(
                            title: PlatformText(
                                "${contacts[index].firstName} ${contacts[index].lastName}",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            subtitle: PlatformText(contacts[index].email,
                                style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () =>
                                loggy.info("implement details screen")));
                  }),
            ),
            PlatformTextButtonIcon(
                onPressed: () async {
                  var shouldRefresh = await Navigator.pushNamed<bool>(
                    context,
                    NewContactScreen.routeName,
                    arguments: ScreenArguments(args.signedInUser),
                  );

                  if (shouldRefresh!) {
                    _refreshData();
                  }
                },
                icon: Icon(PlatformIcons(context).add),
                label: PlatformText("Create Contact"))
          ],
        ));
  }
}
