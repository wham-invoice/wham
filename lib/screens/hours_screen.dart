import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HoursScreen extends StatefulWidget {
  const HoursScreen({Key? key}) : super(key: key);

  @override
  State<HoursScreen> createState() => _HoursScreenState();
}

class _HoursScreenState extends State<HoursScreen> {
  final invoiceTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    invoiceTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference invoices =
        FirebaseFirestore.instance.collection('invoices');

    Future<void> addInvoice() {
      // Call the user's CollectionReference to add a new user

      print("adding invoice... ${invoiceTextController.text}");

      return invoices
          .add({'name': invoiceTextController.text})
          .then((value) => print("Invoice Added"))
          .catchError((error) => print("Failed to add invoice: $error"));
    }

    return PlatformScaffold(
        appBar: PlatformAppBar(),
        iosContentPadding: false,
        iosContentBottomPadding: false,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformTextField(
                    controller: invoiceTextController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                PlatformTextButton(
                  onPressed: addInvoice,
                  child: const Text('Save'),
                ),
              ]),
        ));
  }
}
