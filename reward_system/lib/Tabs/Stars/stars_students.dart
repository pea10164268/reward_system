import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentStars extends StatefulWidget {
  const StudentStars({Key? key}) : super(key: key);

  @override
  State<StudentStars> createState() => _StudentStarsState();
}

class _StudentStarsState extends State<StudentStars> {
  CollectionReference stars = FirebaseFirestore.instance.collection('stars');
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');
  CollectionReference teachers =
      FirebaseFirestore.instance.collection('teachers');
  CollectionReference classrooms =
      FirebaseFirestore.instance.collection('classrooms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: stars.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data!.docs[index]['description']),
              subtitle: Text(snapshot.data!.docs[index]['full_name']),
              trailing: Text(snapshot.data!.docs[index]['class_achieved']),
            );
          },
        );
      },
    ));
  }
}
