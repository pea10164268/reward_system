import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ignore: non_constant_identifier_names
  Future login_user() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.popAndPushNamed(context, '/tabs');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found with that email address.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
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
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        hintText: 'Password*',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      login_user();
                    },
                    icon: const Icon(
                      Icons.login_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Sign In",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Don\'t have an account?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.popAndPushNamed(context, '/register'),
                      icon: const Icon(Icons.person_add),
                      label: const Text('Sign Up')),
                ],
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Sign in',
              style: TextStyle(
                fontSize: 20,
              )),
        ),
        body: Center(
          child: Column(children: [
            form(),
          ]),
        ));
  }
}
