import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final myUserId = FirebaseAuth.instance.currentUser?.email;

  Future signOut() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                await signOut();
              },
              icon: const Icon(
                Icons.logout_sharp,
                color: Colors.black,
              ),
              label: const Text(
                "Log Out",
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
