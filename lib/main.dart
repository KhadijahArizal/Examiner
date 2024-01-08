
import 'package:examiner/Screen/Announcements/announcements.dart';
import 'package:examiner/Screen/IAP%20EX%20Student/studentDetails.dart';
import 'package:examiner/Screen/IAP%20EX%20Student/studentList.dart';
import 'package:examiner/Screen/authlatest.dart';
import 'package:examiner/Screen/dashboard.dart';
import 'package:examiner/Screen/data.dart';
import 'package:examiner/Screen/start.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDW17txVZK6rztMZDkUbxdKm2dPg1RysCI",
      authDomain: "ikict-f49f6.firebaseapp.com",
      databaseURL: "https://ikict-f49f6-default-rtdb.firebaseio.com",
      projectId: "ikict-f49f6",
      storageBucket: "ikict-f49f6.appspot.com",
      messagingSenderId: "753383357173",
      appId: "1:753383357173:web:8ed039663a24205f9fe3bc",
      measurementId: "G-0LXK2QRZMH"),
    );
 runApp( 
    ChangeNotifierProvider<Data>( // Wrap your MaterialApp with ChangeNotifierProvider
      create: (context) => Data(), // Replace Data() with your actual Data class instantiation
      child: MyApp(), // Your MyApp widget becomes the child
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    print(uid);
  }

  @override
  void initState() {
    getUserInfo();
    FirebaseMessaging.instance.getToken().then(print);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iKICT | Examiner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(0, 146, 143, 10),
        fontFamily: 'Futura',
      ),
      home: const Start(),
      routes: {
       // '/auth': (context) => const AuthPage(),
        //'/signIn': (context) => const SignIn(),
        '/Dashboard':(context) => const Dashboard(title: 'Dashboard',),
        //'/monthly_list': (context) => const listOfStudentMonthly(),
        //'/final_list': (context) => const listOfStudentFinal(),
        '/student_list': (context) => const StudentList(),
        '/announc': (context) => const Announc(),
        '/student_details': (context) => S_Details(
              name: '',
              matric: '',
              studentID: '',
            ),
      },
    );
  }
}
