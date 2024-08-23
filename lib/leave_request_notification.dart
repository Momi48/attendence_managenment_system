import 'package:attendence_system/button/round_button.dart';
import 'package:attendence_system/class_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaveRequestNotification extends StatefulWidget {
  const LeaveRequestNotification({super.key});

  @override
  State<LeaveRequestNotification> createState() =>
      _LeaveRequestNotificationState();
}

class _LeaveRequestNotificationState extends State<LeaveRequestNotification> {
  String email = 'admin@gmail.com';
  bool loading = false;

  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();
    notificationService.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Setting'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: RoundButton(
                title: 'Send Notification',
                loading: loading,
                onTap: () async {
                  // send leave request  notification to admin
                  try {
                    setState(() {
                      loading = true;
                    });
                    final querySnapshot = await FirebaseFirestore.instance
                        .collection('Admin')
                        .where('email', isEqualTo: email)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      notificationService.showNotification();
                      setState(() {
                        loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Notification sent to $email'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      setState(() {
                        loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No admin found with name $email'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to send notification: $e')),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
