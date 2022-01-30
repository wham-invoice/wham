import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String? id;
  String userID;
  String firstName;
  String lastName;
  String email;

  Contact(this.userID, this.firstName, this.lastName, this.email, [this.id]);

  Contact.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        userID = snapshot["user_id"],
        firstName = snapshot["first_name"],
        lastName = snapshot["last_name"],
        email = snapshot["email"];

  Map<String, dynamic> toJson() => {
        'user_id': userID,
        'first_name': firstName,
        'last_name': lastName,
        'email': email
      };
}

Future<Contact> getContactFromID(String id) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('contacts').doc(id).get();

  return Contact.fromSnapshot(doc);
}

Future<List<Contact>> getContactsAll(String userID) async {
  List<Contact> contacts = [];
  QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
      .collection('contacts')
      .where("user_id", isEqualTo: userID)
      .get();

  for (DocumentSnapshot doc in query.docs) {
    contacts.add(Contact.fromSnapshot(doc));
  }

  return contacts;
}
