import 'dart:io';

import 'package:attendence_system/screens/mark_attendence_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViewAttendenceScreen extends StatefulWidget {
  const ViewAttendenceScreen({super.key});

  @override
  State<ViewAttendenceScreen> createState() => _ViewAttendenceScreenState();
}

class _ViewAttendenceScreenState extends State<ViewAttendenceScreen> {
  File? image;
  bool loading = false;
  List<bool> isDone = [];
  final nameController = TextEditingController();
  final presentController = TextEditingController();
  final absentController = TextEditingController();
  final storageData = FirebaseStorage.instance;
  int present = 0;
  int absent = 0;
  final reference =
      FirebaseFirestore.instance.collection('User_Details').snapshots();
  void getAndUploadImage(String name) async {
    final picker = ImagePicker();
    final galleryImage = await picker.pickImage(source: ImageSource.gallery);
    if (galleryImage != null) {
      image = File(galleryImage.path);
      final storage = storageData.ref().child('images/${image!}');
      UploadTask upload = storage.putFile(File(image!.path));
      setState(() {
        loading = true;
      });
      try {
        await upload.whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Image Uploaded'),
            backgroundColor: Colors.green,
          ));
        });
        
        final url = await storage.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('User_Details')
            .doc(name)
            .update({
          'imageUrl': url,
        });

        setState(() {
          loading = false;
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No Image Selected'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile and Attendence Data'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: reference,
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
                          String? imageUrl =
                              snapshot.data!.docs[index]['imageUrl'];
                          String present =
                              snapshot.data!.docs[index]['Present'].toString();
                          String absent =
                              snapshot.data!.docs[index]['Absent'].toString();
                          String name =
                              snapshot.data!.docs[index]['name'].toString();
                          isDone.add(true);
                          return ListTile(
                              title: Text(name),
                              subtitle: Row(
                                children: [
                                  Text('Absent $absent '),
                                  Text(
                                    'Presents $present',
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'Edit',
                                    child: TextButton(
                                        onPressed: () async {
                                          final documentSnap =
                                              await FirebaseFirestore.instance
                                                  .collection('User_Details')
                                                  .doc(name)
                                                  .get();
                                          final Timestamp createdAt =
                                              documentSnap.get('createdAt');
                                          final Timestamp time =
                                              Timestamp.now();
                                              // make it 3600 seconds for 1 hour
                                          if (time.seconds - createdAt.seconds >
                                              10) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Cannt Edit After 10 Seconds',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            Navigator.pop(context);

                                            return;
                                          }
                                          showDialogScreen(
                                              name, present, absent);
                                        },
                                        child: const Text('Edit')),
                                  ),
                                  PopupMenuItem(
                                    value: 'Delete',
                                    child: TextButton(
                                        onPressed: () async {
                                          final documentSnap =
                                              await FirebaseFirestore.instance
                                                  .collection('User_Details')
                                                  .doc(name)
                                                  .get();
                                          final Timestamp createdAt =
                                              documentSnap.get('createdAt');
                                          final Timestamp time =
                                              Timestamp.now();

                                          if (time.seconds - createdAt.seconds >
                                              10) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Cannt Delete After 10 Seconds',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            Navigator.pop(context);
                                            return;
                                          }
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
                              leading: GestureDetector(
                                  onTap: () {
                                    getAndUploadImage(name);
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: imageUrl != null
                                        ? NetworkImage(imageUrl)
                                        : null,
                                    child: imageUrl == null
                                        ? const Text('')
                                        : null,
                                  )));
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
