import 'package:attendence_system/notification/leave_request_notification.dart';
import 'package:attendence_system/login/login_screen.dart';
import 'package:attendence_system/screens/mark_attendence_screen.dart';
import 'package:attendence_system/screens/mark_leave.dart';
import 'package:attendence_system/sign_in/view_attendence_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Attendence Screen'),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                auth.signOut().then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const  SnackBar(content: Text('Logged Out Successfully'),backgroundColor: Colors.green,));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                });
              },
              icon: const Icon(Icons.logout))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MarkAttendenceScreen()));
                },
                child: const Text('Mark Attendence')),
          ),
          Center(
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MarkLeaveScreen()));
                },
                child: const Text('Show Leave Attendence Data')),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ViewAttendenceScreen()));
              },
              child: const Text('View Attendence / Change Profile Photo ')),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const LeaveRequestNotification()));
              },
              child: const Text('Send A Leave Request Notification to Admin'))
        ],
      ),
    );
  }
}
