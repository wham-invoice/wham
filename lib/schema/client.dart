import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String? id;
  String firstName;
  String lastName;
  String email;

  Client(this.firstName, this.lastName, this.email, [this.id]);

  Client.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        firstName = snapshot["first_name"],
        lastName = snapshot["last_name"],
        email = snapshot["email"];

  Map<String, dynamic> toJson() =>
      {'first_name': firstName, 'last_name': lastName, 'email': email};
}

Future<Client> getClientFromID(String id) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('clients').doc(id).get();

  return Client.fromSnapshot(doc);
}

Future<List<Client>> getClientsAll() async {
  List<Client> clients = [];
  QuerySnapshot<Map<String, dynamic>> query =
      await FirebaseFirestore.instance.collection('clients').get();

  for (DocumentSnapshot doc in query.docs) {
    clients.add(Client.fromSnapshot(doc));
  }

  return clients;
}
