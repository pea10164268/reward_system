import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassroomList extends StatefulWidget {
  const ClassroomList({Key? key}) : super(key: key);

  @override
  State<ClassroomList> createState() => _ClassroomListState();
}

class _ClassroomListState extends State<ClassroomList> {
  CollectionReference classrooms =
      FirebaseFirestore.instance.collection('classrooms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Classroom List',
              style: TextStyle(
                fontSize: 20,
              )),
        ),
        body: Center(
          child: StreamBuilder(
            stream: classrooms.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data?.docs[index]['class_name']),
                    subtitle: Text(snapshot.data?.docs[index]['teacher']),
                  );
                },
              );
            },
          ),
        ));
  }
}
