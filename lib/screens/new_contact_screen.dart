import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/network/contacts.dart';
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
  final phoneTC = TextEditingController();
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

    _addContact() async {
      final response = await ContactRequests.create(
        args.signedInUser.session,
        firstNameTC.text,
        lastNameTC.text,
        phoneTC.text,
        emailTC.text,
      );

      bool success = response.statusCode == 200;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(addSuccessSB);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(addFailSB);
        loggy.error("unable to create contact ${response.body}");
      }

      Navigator.of(context).pop(success);
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
                      style: const TextStyle(color: Colors.white),
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
                      controller: lastNameTC,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformText("Phone"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformTextField(
                      controller: phoneTC,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text),
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
                      controller: emailTC,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text),
                ),
                PlatformTextButton(
                  onPressed: _addContact,
                  child: const Text('Save'),
                ),
              ]),
        )));
  }
}
