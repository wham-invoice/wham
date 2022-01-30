import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/schema/contact.dart';
import 'package:wham/screens/utils.dart';

class NewContactScreen extends StatefulWidget {
  const NewContactScreen({Key? key}) : super(key: key);

  static const routeName = '/new-contact';

  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> with UiLoggy {
  final firstNameTC = TextEditingController();
  final lastNameTC = TextEditingController();
  final emailTC = TextEditingController();
  final addSuccessSB =
      const SnackBar(content: Text('Contact added successfully.'));
  final addFailSB = const SnackBar(content: Text('Failed to add contact.'));

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    firstNameTC.dispose();
    lastNameTC.dispose();
    emailTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    Future<void> _addContact() {
      final Contact contact = Contact(
        args.signedInUser.id,
        firstNameTC.text,
        lastNameTC.text,
        emailTC.text,
      );

      return FirebaseFirestore.instance
          .collection('contacts')
          .add(contact.toJson())
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(addSuccessSB);
        Navigator.pop(context);
      }).catchError((error) {
        loggy.error("Failed to add contact: $error");
        ScaffoldMessenger.of(context).showSnackBar(addFailSB);
        Navigator.pop(context);
      });
    }

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformText("First Name"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformTextField(
                      controller: firstNameTC,
                      keyboardType: TextInputType.text),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformText("Last Name"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformTextField(
                      controller: lastNameTC, keyboardType: TextInputType.text),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformText("Email"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformTextField(
                      controller: emailTC, keyboardType: TextInputType.text),
                ),
                PlatformTextButton(
                  onPressed: _addContact,
                  child: const Text('Save'),
                ),
              ]),
        )));
  }
}
