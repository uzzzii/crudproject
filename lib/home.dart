import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore.dart'; // Import your FirestoreServices class

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textcontroller = TextEditingController();
  final FirestoreServices _firestoreServices = FirestoreServices();

  void openNoteBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _textcontroller,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              _firestoreServices.addnote(_textcontroller.text);
              _textcontroller.clear();
              Navigator.pop(context);
            },
            child: Text("Add Data"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 120, 233, 222),
        title: Text("Crud App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreServices.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List dataList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = dataList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String dataText = data['note'];

                // Adding borders around each ListTile
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(dataText),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
