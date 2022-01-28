import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String? id;
  String firstName;
  String lastName;
  String email;

  Contact(this.firstName, this.lastName, this.email, [this.id]);

  Contact.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        firstName = snapshot["first_name"],
        lastName = snapshot["last_name"],
        email = snapshot["email"];

  Map<String, dynamic> toJson() =>
      {'first_name': firstName, 'last_name': lastName, 'email': email};
}

Future<Contact> getContactFromID(String id) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('contacts').doc(id).get();

  return Contact.fromSnapshot(doc);
}

Future<List<Contact>> getContactsAll(String userID) async {
  final idd = FirebaseFirestore.instance.collection('contacts').id;
  print("please contact! " + idd);
  List<Contact> contacts = [];
  QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
      .collection('invoices')
      .where("user_id", isEqualTo: userID)
      .get();

  print("waiting for contact! ");

  for (DocumentSnapshot doc in query.docs) {
    contacts.add(Contact.fromSnapshot(doc));
    print("contact! " + doc.id);
  }

  return contacts;
}
