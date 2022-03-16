import 'package:loggy/loggy.dart';

class Invoice with UiLoggy {
  final String id;
  final String contactID;
  final String userID;
  final double rate;
  final double hours;
  final String description;
  final DateTime dueDate;
  final bool
      paid; //TODO: make this a enum/class with paid/open/overdue etc states.

  Invoice({
    required this.id,
    required this.userID,
    required this.contactID,
    required this.rate,
    required this.hours,
    required this.description,
    required this.dueDate,
    required this.paid,
  });

  Invoice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        contactID = json["contact_id"],
        userID = json["user_id"],
        rate = json["rate"],
        hours = json["hours"],
        description = json["description"],
        dueDate = json["due_date"].toDate(),
        paid = json["paid"];

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
}
