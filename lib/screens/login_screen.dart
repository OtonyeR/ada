import 'package:ada/constants/styles.dart';
import 'package:ada/screens/choosescreen.dart';
import 'package:ada/screens/homescreen.dart';
import 'package:ada/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isLoggedIn;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => const SignInOptions(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .7,
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          kTextField(
                            emailController,
                            Icons.email_rounded,
                            Colors.red,
                            const Color.fromRGBO(237, 232, 230, 1.0),
                            Colors.red.withOpacity(.05),
                            'Email address',
                            TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          kTextField(
                            passController,
                            Icons.password_rounded,
                            Colors.red,
                            const Color.fromRGBO(237, 232, 230, 1.0),
                            Colors.red.withOpacity(.05),
                            'Password',
                            TextInputType.visiblePassword,
                          ),
                          const SizedBox(height: 40),
                          buttonStyle2(
                            () {
                              signUser();
                              Navigator.pop(context);
                              if (isLoggedIn = true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
                              }
                            },
                            'Login',
                            MediaQuery.of(context).size.width * .6,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Don\'t have an account?',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: ' Sign up',
                                    style: const TextStyle(
                                        color: Colors.blueAccent, fontSize: 18),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (builder) =>
                                                const SignUp(),
                                          ),
                                        );
                                      }),
                              ]))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signUser() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim());

    FirebaseAuth.instance.currentUser != null
        ? isLoggedIn = true
        : isLoggedIn = false;
  }
}
