import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conPasswordController = TextEditingController();

  Future registerUser() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      if (newUser != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Success!"),
                content: new Text("Registration Successful!"),
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
                    controller: _emailController,
                    decoration: const InputDecoration(
                        hintText: 'Email Address*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        hintText: 'Password*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  TextFormField(
                    controller: _conPasswordController,
                    decoration: const InputDecoration(
                        hintText: 'Confirm Password*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      registerUser();
                    },
                    icon: const Icon(
                      Icons.login_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Sign up",
                    ),
                  )
                ],
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
