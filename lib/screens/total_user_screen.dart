import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TotalUserScreen extends StatefulWidget {
  const TotalUserScreen({super.key});

  @override
  State<TotalUserScreen> createState() => _TotalUserScreenState();
}

class _TotalUserScreenState extends State<TotalUserScreen> {
  final refData = FirebaseFirestore.instance.collection('User').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Logged in '),
        leading:
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                )
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: refData,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  const CircularProgressIndicator.adaptive();
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final name = snapshot.data!.docs[index]['name'];
                          final email = snapshot.data!.docs[index]['email'];
                          return ListTile(
                            title: Text(name),
                            subtitle: Text(email),
                            trailing: TextButton(
                                onPressed: () async {
                                  showMessage(name);
                                },
                                child: Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Center(
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))),
                          );
                        }),
                  );
                }
                return const CircularProgressIndicator.adaptive();
              })
        ],
      ),
    );
  }

  Future<void> showMessage(String name) {
    return showDialog(
        barrierDismissible: false,
        context: (context),
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Your Account?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    QuerySnapshot query = await FirebaseFirestore.instance
                        .collection('User')
                        .where('name', isEqualTo: name)
                        .get();
                    if (query.docs.isNotEmpty)  {
                      for (int i = 0; i < query.docs.length; i++) {
                        DocumentSnapshot doc = query.docs[i];
                         FirebaseFirestore.instance
                            .collection('User')
                            .doc(doc.id).delete();
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.blue),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }
}
