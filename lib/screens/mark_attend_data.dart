import 'package:attendence_system/screens/mark_attendence_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarkAttendenceData extends StatefulWidget {
  const MarkAttendenceData({super.key});

  @override
  State<MarkAttendenceData> createState() => _MarkAttendenceDataState();
}

class _MarkAttendenceDataState extends State<MarkAttendenceData> {
  List<bool> isDone = [];
  final nameController = TextEditingController();
  final presentController = TextEditingController();
  final absentController = TextEditingController();
  int present = 0;
  int absent = 0;
  final ref = FirebaseFirestore.instance.collection('User_Details').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendence Data'),
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
              stream: ref,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No Data Found'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          String present =
                              snapshot.data!.docs[index]['Present'].toString();
                          String absent =
                              snapshot.data!.docs[index]['Absent'].toString();
                          String name =
                              snapshot.data!.docs[index]['name'].toString();
                          String leaves =
                              snapshot.data!.docs[index]['Leaves'].toString();
                          isDone.add(true);
                          return ListTile(
                            title: Text(name),
                            subtitle: Text('Leave $leaves'),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'Edit',
                                  child: TextButton(
                                      onPressed: () async {
                                        showDialogScreen(name, present, absent);
                                      },
                                      child: const Text('Edit')),
                                ),
                                PopupMenuItem(
                                  value: 'Delete',
                                  child: TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('User_Details')
                                            .doc(name)
                                            .delete();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete')),
                                ),
                              ],
                            ),
                            leading: IconButton(
                                onPressed: () async {
                                  setState(() {});
                                },
                                icon: Icon(
                                    isDone[index] == true
                                        ? Icons.check
                                        : Icons.dangerous,
                                    color: isDone[index] == true
                                        ? Colors.green
                                        : Colors.red)),
                          );
                        }),
                  );
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MarkAttendenceScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  showDialogScreen(String name, String present, String absent) {
    nameController.text = name;
    presentController.text = present.toString();
    absentController.text = absent.toString();

    int preValue = int.parse(presentController.text);
    int abValue = int.parse(absentController.text);

    return showDialog(
        context: (context),
        builder: (context) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: AlertDialog(
              title: const Text('Enter Your Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Edit Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: presentController,
                    decoration: const InputDecoration(
                      labelText: 'Edit Present',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: absentController,
                    decoration: const InputDecoration(
                      labelText: 'Edit Absent',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    int newPreValue =
                        int.parse(presentController.text) + preValue;
                    int newAbValue = int.parse(absentController.text) + abValue;
                    setState(() {});
                    await FirebaseFirestore.instance
                        .collection('User_Details')
                        .doc(name)
                        .update({
                      'name': nameController.text,
                      'Present': newPreValue,
                      'Absent': newAbValue,
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
