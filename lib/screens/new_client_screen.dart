import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wham/schema/client.dart';

class NewClientScreen extends StatefulWidget {
  const NewClientScreen({Key? key}) : super(key: key);

  @override
  State<NewClientScreen> createState() => _NewClientScreenState();
}

class _NewClientScreenState extends State<NewClientScreen> {
  final firstNameTC = TextEditingController();
  final lastNameTC = TextEditingController();
  final emailTC = TextEditingController();
  final addSuccessSB =
      const SnackBar(content: Text('Client added successfully.'));
  final addFailSB = const SnackBar(content: Text('Failed to add client.'));

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
    Future<void> _addClient() {
      final Client client = Client(
        firstNameTC.text,
        lastNameTC.text,
        emailTC.text,
      );

      return FirebaseFirestore.instance
          .collection('clients')
          .add(client.toJson())
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(addSuccessSB);
        Navigator.pop(context);
      }).catchError((error) {
        print("Failed to add client: $error");
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
                  onPressed: _addClient,
                  child: const Text('Save'),
                ),
              ]),
        )));
  }
}
