import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loggy/loggy.dart';
import 'package:wham/schema/contact.dart';
import 'package:wham/schema/invoice.dart';
import 'package:wham/screens/utils.dart';

import '../network/requests.dart';

class NewInvoiceScreen extends StatefulWidget {
  const NewInvoiceScreen({Key? key}) : super(key: key);

  static const routeName = '/new-invoice';

  @override
  State<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> with UiLoggy {
  final hoursTC = TextEditingController();
  final rateTC = TextEditingController();
  final descriptionTC = TextEditingController();
  final dueDateTC = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String clientDropdownValue = "";

  final addSuccessSB =
      const SnackBar(content: Text('Invoice added successfully.'));
  final addFailSB = const SnackBar(content: Text('Failed to add invoice.'));

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    hoursTC.dispose();
    rateTC.dispose();
    descriptionTC.dispose();
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showPlatformDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() => selectedDate = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as NewInvoiceScreenArguments;

    _addInvoice() async {
      final response = await Requests.createInvoice(
        args.signedInUser.session,
        clientDropdownValue,
        descriptionTC.text,
        double.parse(hoursTC.text),
        double.parse(rateTC.text),
      );

// TODO should be 200 as we're not returning anything
      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(addSuccessSB);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(addFailSB);
        loggy.error("unable to create invoice ${response.body}");
      }
      Navigator.pop(context);
    }

    return PlatformScaffold(
        iosContentPadding: true,
        appBar: PlatformAppBar(
          title: const Text('New Invoice'),
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: PlatformText("Customer"),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: _clientList(args.contacts)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: PlatformText("Total Hours"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: PlatformTextField(
                          controller: hoursTC,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: PlatformText("Hourly Rate"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: PlatformTextField(
                          controller: rateTC,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: PlatformText("Description"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: PlatformTextField(
                          controller: descriptionTC,
                          hintText: "e.g 130 billable hours at \$80 per hour.",
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: Column(
                          children: [
                            PlatformText(selectedDate.toString()),
                            PlatformTextButton(
                              onPressed: () => _selectDate(context),
                              child: const Text('Due Date'),
                            )
                          ],
                        )),
                    PlatformTextButton(
                      onPressed: _addInvoice,
                      child: const Text('Save'),
                    ),
                  ]), // Column
            ), // ConstrainedBox
          );
        }));
  } // SingleChildScrollView

  // _clientListBuilder
  Widget _clientList(List<Contact> contacts) {
    List<DropdownMenuItem<String>> items = contacts.map((contact) {
      return DropdownMenuItem<String>(
        value: contact.id,
        child: Text(contact.fullName),
      );
    }).toList();

    clientDropdownValue = items.first.value!;

    return PlatformDropdownButton(
      value: clientDropdownValue,
      hint: PlatformText("Select a client"),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        loggy.info(newValue);
        if (newValue == null) return;
        return setState(() => clientDropdownValue = newValue);
      },
      items: items,
    );
  }
}
