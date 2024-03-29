// ignore_for_file: use_build_context_synchronously

import 'package:examiner/Screen/googlebtn.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // AuthService authService = AuthService();
  bool isSignedIn = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: const AssetImage('assets/iiumlogo.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white30.withOpacity(0.2), BlendMode.dstATop),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  padding: const EdgeInsets.all(70),
                  decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/iium.png')),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'I-KICT',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 146, 143, 10),
                    fontSize: 60,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Playfair Display',
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Industrial Attachment Programme Dashboard',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontFamily: 'Futura',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: GoogleBtn(),
                    ),
                  ),
                  if (_isLoading) const CircularProgressIndicator(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
