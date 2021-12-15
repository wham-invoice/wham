import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wham/schema/client.dart';
import 'package:wham/schema/invoice.dart';

class NewInvoiceScreen extends StatefulWidget {
  const NewInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  final hoursTC = TextEditingController();
  final rateTC = TextEditingController();
  final descriptionTC = TextEditingController();
  final dueDateTC = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String clientDropdownValue = 'none';
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
    Future<void> _addInvoice() {
      final Invoice invoice = Invoice(
        clientDropdownValue,
        double.parse(rateTC.text),
        double.parse(hoursTC.text),
        descriptionTC.text,
        selectedDate,
        false,
      );

      return FirebaseFirestore.instance
          .collection('invoices')
          .add(invoice.toJson())
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(addSuccessSB);
        Navigator.pop(context);
      }).catchError((error) {
        print("Failed to add invoice: $error");
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
                  child: PlatformText("Customer"),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: _clientListBuilder()),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformText("Total Hours"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformTextField(
                      controller: hoursTC,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformText("Hourly Rate"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformTextField(
                      controller: rateTC,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformText("Description"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: PlatformTextField(
                      controller: descriptionTC,
                      keyboardType: TextInputType.text),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
              ]),
        )));
  }

  Widget _clientListBuilder() {
    return Center(
        child: FutureBuilder<List<Client>>(
            future: getClientsAll(),
            builder: (context, snapshot) {
              List<DropdownMenuItem<String>> items =
                  snapshot.data!.map((client) {
                return DropdownMenuItem<String>(
                  value: client.id,
                  child: Text(client.email),
                );
              }).toList();

              return PlatformDropdownButton(
                value: clientDropdownValue,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  if (newValue == null) return;
                  return setState(() => clientDropdownValue = newValue);
                },
                items: items,
              );
            }));
  }
}
