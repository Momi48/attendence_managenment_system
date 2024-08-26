import 'package:attendence_system/login/login_screen.dart';
import 'package:attendence_system/admin/menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckLogin {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> isLogin(BuildContext context,String email,String name) async {
    await Future.delayed(const Duration(seconds: 1));

    if (user != null) {
      
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MenuScreen()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }
}
