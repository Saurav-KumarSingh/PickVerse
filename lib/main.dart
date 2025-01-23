import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pickverse/auth_screen/signup.dart';
import 'package:pickverse/screens/home.dart';
import 'package:pickverse/sharedprefrences.dart';
import 'firebase_options.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Usersharedpreferences.init();
    Timer(const Duration(seconds: 3), () {
      //add navigator here
      bool? loginstatus = Usersharedpreferences.getLogin() ?? false;
      if (loginstatus == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const GooglePhotosUI()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const SignupPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/logo.png',scale: 2,),
            // SizedBox(height: 40),
            Lottie.asset('assets/loaderlpicv.json'),
          ],
        ),
      ),
    );
  }
}


