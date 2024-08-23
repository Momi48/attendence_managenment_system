import 'package:attendence_system/admin/menu_screen.dart';
import 'package:attendence_system/button/round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final ref = FirebaseFirestore.instance;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
  }
  
  Future<void> adminLogin() async {
  try{

  
    auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), password: passwordController.text);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MenuScreen()));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Admin Logged In Succesffuly'),
      backgroundColor: Colors.green,
    ));
  } catch(e){
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
   }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Enter Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is Empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: 'Enter Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is Empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundButton(
                    title: 'Login ',
                    loading: loading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        adminLogin();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
