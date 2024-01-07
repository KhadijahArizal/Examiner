
import 'package:examiner/Screen/dashboard.dart';
import 'package:examiner/Screen/authlatest.dart';
import 'package:flutter/material.dart';

class GoogleBtn extends StatefulWidget {
  @override
  _GoogleBtnState createState() => _GoogleBtnState();
}

class _GoogleBtnState extends State<GoogleBtn> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.teal),
          ),
          color: Colors.white),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          setState(() {
            _isProcessing = true;
          });
          await signInWIthGoogle().then((result) {
            print(result);
            if (result != null) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const Dashboard(title: ''),
                ),
              );
            }
          }).catchError((error) {
            print('error $error');
          });
          setState(() {
            _isProcessing = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/google.png',
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Login with Gmail",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}