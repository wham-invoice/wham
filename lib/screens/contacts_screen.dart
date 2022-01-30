import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/schema/contact.dart';
import 'package:wham/screens/utils.dart';

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

    final Stream<QuerySnapshot> _contactsStream = FirebaseFirestore.instance
        .collection('contacts')
        .where("user_id", isEqualTo: args.signedInUser.id)
        .snapshots();

    return PlatformScaffold(
        appBar: PlatformAppBar(),
        iosContentPadding: false,
        iosContentBottomPadding: false,
        body: StreamBuilder<QuerySnapshot>(
            stream: _contactsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                loggy.error(snapshot.error);
                return PlatformText('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return PlatformText("Loading");
              }

              List<Contact> contacts = [];
              for (final doc in snapshot.data!.docs) {
                contacts.add(Contact.fromSnapshot(doc));
              }

              return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) => PlatformListTile(
                      title: PlatformText(
                          "${contacts[index].firstName} ${contacts[index].lastName}"),
                      subtitle: PlatformText(contacts[index].email),
                      onTap: () => loggy.info("implement details screen")));
            }));
  }
}
