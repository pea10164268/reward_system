import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conPasswordController = TextEditingController();

  Future registerUser() async {
    try {
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      User? user = newUser.user;
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'full_name:': _fullNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });
      // ignore: unnecessary_null_comparison
      if (newUser != null) {
        user?.updateDisplayName(_fullNameController.text);
        user?.reload();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Success!"),
                content: const Text("Registration Successful!"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text('Redirect to Login Page!')),
                ],
              );
            });
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }

  Widget form() {
    return Expanded(
      child: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                        hintText: 'Full Name*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        hintText: 'Email Address*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        hintText: 'Password*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _conPasswordController,
                    decoration: const InputDecoration(
                        hintText: 'Confirm Password*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your confirm password.';
                      } else if (_passwordController !=
                          _conPasswordController) {
                        return 'Your password and confirm password must match.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        registerUser();
                      }
                    },
                    icon: const Icon(
                      Icons.login_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Sign up",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Already have an account?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, '/login'),
                      icon: const Icon(Icons.login),
                      label: const Text('Sign In')),
                ],
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Sign up',
              style: TextStyle(
                fontSize: 30,
              )),
          centerTitle: true,
        ),
        body: Center(
          child: Column(children: [
            form(),
          ]),
        ));
  }
}
