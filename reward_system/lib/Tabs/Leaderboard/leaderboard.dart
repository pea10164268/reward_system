import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reward_system/Login/login_screen.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const LoginScreen()));
                  },
                  child: const Text('Yes')),
            ],
          );
        });
  }

  final _auth = FirebaseAuth.instance;

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
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
