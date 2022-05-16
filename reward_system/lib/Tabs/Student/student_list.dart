import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  CollectionReference students =
      FirebaseFirestore.instance.collection('students');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
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
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data!.docs[index]['full_name']),
                  subtitle: Text(snapshot.data?.docs[index]['class_name']),
                  trailing: Text(snapshot.data?.docs[index]['teacher']),
                );
              },
            );
          },
        ));
  }
}
