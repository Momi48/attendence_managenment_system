import 'package:attendence_system/button/round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarkAttendenceScreen extends StatefulWidget {
  const MarkAttendenceScreen({super.key});

  @override
  State<MarkAttendenceScreen> createState() => _MarkAttendenceScreenState();
}

class _MarkAttendenceScreenState extends State<MarkAttendenceScreen> {
  String currentDayTime = DateFormat('HH:mm:ss').format(DateTime.now());
  int present = 0;
  int absent = 0;
  int leaves = 0;
  String? imageUrl;
  final presentController = TextEditingController();
  final absentController = TextEditingController();
  final leaveController = TextEditingController();
  bool loading = false;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendence'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: presentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText:
                      'Enter Present Count or type 0(blank)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: absentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText:
                      'Enter Absent Count or type 0(blank)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: leaveController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText:
                      'Enter Leaves Count or type 0(blank)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              RoundButton(
                title: 'Add Attendence',
                loading: loading,
                onTap: () async {
                  try {
                    if (nameController.text.isEmpty) {
                      setState(() {
                        loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a name'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    } else {
                      setState(() {
                        loading = true;
                      });
                      String name = nameController.text.trim();

                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection('User')
                          .where('name', isEqualTo: name)
                          .get();
                      if (querySnapshot.docs.isNotEmpty) {
                        // Retrieve the current "present" value
                        DocumentSnapshot userDetailsSnapshot =
                            await FirebaseFirestore.instance
                                .collection('User_Details')
                                .doc(name)
                                .get();

                        if (userDetailsSnapshot.exists) {
                          present = userDetailsSnapshot['Present'] ?? 0;
                          absent = userDetailsSnapshot['Absent'] ?? 0;
                          leaves = userDetailsSnapshot['Leaves'] ?? 0;
                        }
                        int presentValue = int.parse(presentController.text);
                        int absentValue = int.parse(absentController.text);
                        int leaveValue = int.parse(leaveController.text);

                        present += presentValue;
                        absent += absentValue;
                        leaves += leaveValue;
                        DateTime currentTime = DateTime.now();
                        String? imageUrl;
                        await FirebaseFirestore.instance
                            .collection('User_Details')
                            .doc(name)
                            .set({
                          'name': nameController.text,
                          'Day': currentDayTime,
                          'Present': present,
                          'Absent': absent,
                          'Leaves': leaves,
                          'createdAt': currentTime,
                          'imageUrl': imageUrl
                        }, SetOptions(merge: true)).then((_) {
                          setState(() {
                            loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Attendance Added',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        });
                      } else {
                        setState(() {
                          loading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Name Not Found',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
