import 'package:attendence_system/admin/admin_panel.dart';
import 'package:attendence_system/screens/attendence_screen.dart';
import 'package:attendence_system/button/round_button.dart';
import 'package:attendence_system/sign_in/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isChanged = false;

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
  }
  
  void login() async {
    setState(() {
      loading = true;
    });

    try {
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
  
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login Successful',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AttendenceScreen()),
      );
    } catch (error) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login Screen'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminPanel()));
              },
              child: const Text('Admin'))
        ],
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
                  height: 10,
                ),
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
                  obscureText:isChanged ? false : true,
                  decoration: InputDecoration(
                      hintText: 'Enter Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              
                            });
                            isChanged = !isChanged;
                          },
                          icon: Icon(isChanged ? Icons.visibility_off : Icons.visibility)),
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
                        login();
                      }
                    }),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't Have An Account",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text(
                          "Sign Up ",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
