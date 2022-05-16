import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final myUserId = FirebaseAuth.instance.currentUser?.displayName;
  final myUserEmail = FirebaseAuth.instance.currentUser?.email;
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
          title: Text(myUserId! + '\'s Profile'),
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Classroom',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Card(
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Classroom list'),
                      leading: const Icon(Icons.class_),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/classroom');
                      },
                    ),
                    const Divider(thickness: 2),
                    ListTile(
                      title: const Text('Add new classroom'),
                      leading: const Icon(Icons.class_),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/classroom/add');
                      },
                    ),
                  ],
                ),
              ),
              const Text(
                'Student',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Card(
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Student list'),
                      leading: const Icon(Icons.class_),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/student');
                      },
                    ),
                    const Divider(thickness: 2),
                    ListTile(
                      title: const Text('Add new student'),
                      leading: const Icon(Icons.class_),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/student/add');
                      },
                    ),
                  ],
                ),
              ),
              const Text(
                'Teacher',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              Card(
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Add new teacher'),
                      leading: const Icon(Icons.class_),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/teacher/add');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
