import 'package:attendence_system/admin/admin_panel.dart';
// import 'package:attendence_system/screens/attendence_screen.dart';
// import 'package:attendence_system/button/round_button.dart';
import 'package:attendence_system/screens/mark_attend_data.dart';
import 'package:attendence_system/screens/mark_leave.dart';
import 'package:attendence_system/screens/percentage_screen.dart';
import 'package:attendence_system/screens/total_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  List<Widget> pages = const [
    TotalUserScreen(),
    MarkAttendenceData(),
    MarkLeaveScreen(),
    PrintingAndPercentScreen()
  ];
  List<String> userDetails = [
    'Total User',
    'Attend Details',
    'On Leave',
    'Attend Grading'
  ];

  void fetchUser() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('User').get();
      int totlaUser = querySnapshot.size;
      setState(() {
        userDetails[0] = 'Total User $totlaUser';
      });
    } catch (e) {
      userDetails[0] = 'Error';
    }
  }

  String admin = 'admin';
  @override
  void initState() {
    super.initState();
    setState(() {
      
    });
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Admin Screen'),
        leading: IconButton(
            onPressed: () async {
              await auth.signOut().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPanel()),
                );
              });
            },
            icon: Icon(Icons.logout)),
      ),
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: userDetails.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => pages[index]));
                        },
                        child: Container(
                          width: 200,
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              userDetails[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
        //   RoundButton(
        //       title: 'Go to Attendence Screen',
        //       onTap: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => const AttendenceScreen()));
        //       })
        ],
      ),
    );
  }
}
