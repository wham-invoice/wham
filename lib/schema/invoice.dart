import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wham/schema/contact.dart';

class Invoice {
  String? id;
  final String contactID;
  final String userID;
  final double rate;
  final double hours;
  final String description;
  final DateTime dueDate;
  final bool
      paid; //TODO: make this a enum/class with paid/open/overdue etc states.

  Invoice(this.contactID, this.userID, this.rate, this.hours, this.description,
      this.dueDate, this.paid,
      [this.id]);

  Invoice.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        contactID = snapshot["contact_id"],
        userID = snapshot["user_id"],
        rate = snapshot["rate"],
        hours = snapshot["hours"],
        description = snapshot["description"],
        dueDate = snapshot["due_date"].toDate(),
        paid = snapshot["paid"];

  Map<String, dynamic> toJson() => {
        'contact_id': contactID,
        'user_id': userID,
        'rate': rate,
        'hours': hours,
        'description': description,
        'due_date': dueDate,
        'paid': paid
      };

  double getTotal() {
    return rate * hours;
  }

  Future<Contact> getClient() async {
    return await getContactFromID(contactID);
  }
}
