import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final myUserId = FirebaseAuth.instance.currentUser?.displayName;
  final _auth = FirebaseAuth.instance;

  Future signOut() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Really?"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, '/profile');
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.popAndPushNamed(context, '/login');
                  },
                  child: const Text('Yes')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                await signOut();
              },
              label: const Text(
                "Log out",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              icon: const Icon(
                Icons.logout_sharp,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(children: [
            Text("Welcome! $myUserId", style: const TextStyle(fontSize: 25)),
          ]),
        )));
  }
}
