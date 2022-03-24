class Invoice {
  final String id;
  final String contactID;
  final String userID;
  final num rate;
  final num hours;
  final String description;
  final DateTime issueDate;
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
    required this.issueDate,
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
        issueDate = DateTime.parse(json["issue_date"]),
        dueDate = DateTime.parse(json["due_date"]),
        paid = json["paid"];

  num getTotal() {
    return rate * hours;
  }
}
