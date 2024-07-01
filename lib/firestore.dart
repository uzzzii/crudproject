import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  Future<void> addnote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  Stream<QuerySnapshot> getData() {
    final dataStream = notes.orderBy("timestamp", descending: true).snapshots();
    return dataStream;
  }
}
