import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reward_system/Login/login_screen.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  CollectionReference students =
      FirebaseFirestore.instance.collection("students");
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const LoginScreen()));
                  },
                  child: const Text('Yes')),
            ],
          );
        });
  }

  getStudentData() {
    return StreamBuilder(
      stream: students.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data?.docs[index]['full_name']),
              subtitle: Text(snapshot.data?.docs[index]['class_name']),
              trailing:
                  Text(snapshot.data!.docs[index]["no_of_stars"].toString()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Leaderboard"),
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
        body: SingleChildScrollView(
          child: Column(children: [
            getStudentData(),
          ]),
        ));
  }
}
