import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wham/schema/client.dart';

class Invoice {
  String? id;
  final String clientID;
  final double rate;
  final double hours;
  final String description;
  final DateTime dueDate;
  final bool
      paid; //TODO: make this a enum/class with paid/open/overdue etc states.

  Invoice(this.clientID, this.rate, this.hours, this.description, this.dueDate,
      this.paid,
      [this.id]);

  Invoice.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        clientID = snapshot["client_id"],
        rate = snapshot["rate"],
        hours = snapshot["hours"],
        description = snapshot["description"],
        dueDate = snapshot["due_date"].toDate(),
        paid = snapshot["paid"];

  Map<String, dynamic> toJson() => {
        'client_id': clientID,
        'rate': rate,
        'hours': hours,
        'description': description,
        'due_date': dueDate,
        'paid': paid
      };

  double getTotal() {
    return rate * hours;
  }

  Future<Client> getClient() async {
    return await getClientFromID(clientID);
  }
}
