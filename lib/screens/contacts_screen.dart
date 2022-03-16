import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/schema/contact.dart';
import 'package:wham/screens/new_contact_screen.dart';
import 'package:wham/screens/utils.dart';

import '../network/requests.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  static const routeName = '/contacts';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> with UiLoggy {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return PlatformScaffold(
        appBar: PlatformAppBar(),
        iosContentPadding: false,
        iosContentBottomPadding: false,
        body: Column(
          children: [
            FutureBuilder(
                future: Requests.getContacts(args.signedInUser.session),
                builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
                  if (snapshot.hasError) {
                    loggy.error(snapshot.error);
                    return PlatformText('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return PlatformText("Loading");
                  }

                  List<Contact> contacts = snapshot.data!;

                  return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) => PlatformListTile(
                          title: PlatformText(
                              "${contacts[index].firstName} ${contacts[index].lastName}"),
                          subtitle: PlatformText(contacts[index].email),
                          onTap: () => loggy.info("implement details screen")));
                }),
            PlatformTextButtonIcon(
                onPressed: () => Navigator.pushNamed(
                    context, NewContactScreen.routeName,
                    arguments: ScreenArguments(args.signedInUser)),
                icon: Icon(PlatformIcons(context).add),
                label: PlatformText("Create Contact"))
          ],
        ));
  }
}
