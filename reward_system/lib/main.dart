import 'package:firebase_core/firebase_core.dart';
import 'package:reward_system/Tabs/Stars/create_star.dart';
import 'package:reward_system/Tabs/Stars/stars_students.dart';
import 'package:reward_system/decisions_tree.dart';
import 'Tabs/Classroom/classroom_list.dart';
import 'Tabs/Classroom/create_classroom.dart';
import 'Tabs/Profile/profile_screen.dart';
import 'Tabs/Student/create_student.dart';
import 'Tabs/Student/student_list.dart';
import 'Tabs/Tabs.dart';
import 'Tabs/Teacher/create_teacher.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login/login_screen.dart';
import 'Register/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: const DecisionTree(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/teacher/add': (context) => const CreateTeacher(),
        '/student': (context) => const StudentList(),
        '/student/add': (context) => const CreateStudent(),
        '/classroom': (context) => const ClassroomList(),
        '/classroom/add': (context) => const CreateClassroom(),
        '/tabs': (context) => const TabsScreen(),
        '/star/add': ((context) => const CreateStar()),
        '/star': (context) => const StudentStars()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
