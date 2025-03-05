import 'package:ada/constants/styles.dart';
import 'package:ada/screens/login_screen.dart';
import 'package:ada/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInOptions extends StatelessWidget {
  const SignInOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .4,
              alignment: Alignment.topCenter,
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Aida.',
                  style: TextStyle(
                      fontSize: 82,
                      color: Colors.red,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Get emergency and first aid help with Ada',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 80.0,
            ),
            Column(
              children: [
                buttonStyle3(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => LoginScreen(),
                    ),
                  );
                }, 'Sign In', MediaQuery.of(context).size.width * .5),
                const SizedBox(
                  height: 10.0,
                ),
                buttonStyle3(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const SignUp(),
                    ),
                  );
                }, 'Create Account', MediaQuery.of(context).size.width * .65)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
