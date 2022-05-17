import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final user = FirebaseAuth.instance.currentUser;
  final myUserId = FirebaseAuth.instance.currentUser?.displayName;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future editUser() {
    FirebaseFirestore.instance.collection("users").doc(user?.uid).update({
      "full_name": _fullNameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
    });
    user?.updateDisplayName(user?.displayName);
    user?.updateEmail(_emailController.text);
    user?.updatePassword(_passwordController.text);
    user?.reload();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success!"),
            content: const Text(
                "Edit Successful!\n You will be logged out and redirected back to the log in page!"),
            actions: [
              TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Redirect to Login Page!')),
            ],
          );
        });
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
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        editUser();
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Edit Profile",
                    ),
                  ),
                ],
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Edit $myUserId\'s Profile'),
      ),
      body: Column(children: [
        Expanded(
          child: form(),
        )
      ]),
    );
  }
}
