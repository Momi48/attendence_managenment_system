import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarkLeaveScreen extends StatefulWidget {
  const MarkLeaveScreen({super.key});

  @override
  State<MarkLeaveScreen> createState() => _MarkLeaveScreenState();
}

class _MarkLeaveScreenState extends State<MarkLeaveScreen> {
  final leaveData =
      FirebaseFirestore.instance.collection('User_Details').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Leave Attendence Data'),
         leading:
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                )
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: leaveData,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No Data Found'),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                'Name: ${snapshot.data!.docs[index]['name'].toString()}'),
                            subtitle: Text(
                                'Leave ${snapshot.data!.docs[index]['Leaves'].toString()}'),
                          );
                        }),
                  );
                }
              })
        ],
      ),
    );
  }
}
