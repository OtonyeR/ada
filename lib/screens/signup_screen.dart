import 'package:ada/constants/styles.dart';
import 'package:ada/screens/choosescreen.dart';
import 'package:ada/screens/homescreen.dart';
import 'package:ada/screens/login_screen.dart';
import 'package:ada/widgets/ticket.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late bool isLoggedIn;
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController allergyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  List<Ticket> allergies = [];
  List allergyPlain = [];
  List contactsList = [];
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  Map _contact = {};
  String? selectedValue;
  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  void addAllergy() async {
    String input = allergyController.text.trim();

    setState(() {
      if (input != '') {
        allergyPlain.add(input);
        allergyPlain.toSet().toList();
      }
      if (allergyPlain.contains(input)) {
        return;
      }
    });
  }

  @override
  void dispose() {
    firstController.dispose();
    lastController.dispose();
    ageController.dispose();
    allergyController.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 0.0,
                  ),
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
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
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
                              'Sign up to continue',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
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
                              height: 15,
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
                            const SizedBox(
                              height: 15,
                            ),
                            kTextField(
                              firstController,
                              Icons.person,
                              Colors.red,
                              const Color.fromRGBO(237, 232, 230, 1.0),
                              Colors.red.withOpacity(.05),
                              'First name',
                              TextInputType.name,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            kTextField(
                              lastController,
                              Icons.email_rounded,
                              Colors.red,
                              const Color.fromRGBO(237, 232, 230, 1.0),
                              Colors.red.withOpacity(.05),
                              'Last name',
                              TextInputType.name,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            kTextField(
                              ageController,
                              Icons.person,
                              Colors.red,
                              const Color.fromRGBO(237, 232, 230, 1.0),
                              Colors.red.withOpacity(.05),
                              'Age',
                              TextInputType.number,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            DropdownButtonFormField2(
                              decoration: InputDecoration(
                                //Add isDense true and zero Padding.
                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                //Add more decoration as you want here
                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                              ),
                              isExpanded: true,
                              hint: const Text(
                                'Select Your Gender',
                                style: TextStyle(fontSize: 14),
                              ),
                              items: genderItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select gender.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                selectedValue = value.toString();
                              },
                              onSaved: (value) {
                                selectedValue = value.toString();
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 60,
                                padding: EdgeInsets.only(right: 10),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 30,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            kButtonTextField(
                              const Icon(Icons.no_meals_rounded),
                              const Icon(
                                Icons.add_circle_rounded,
                                color: Colors.red,
                                size: 26,
                              ),
                              () {
                                addAllergy();
                                allergyController.clear();
                              },
                              Colors.red,
                              const Color.fromRGBO(237, 232, 230, 1.0),
                              Colors.red.withOpacity(.05),
                              'Allergy',
                              TextInputType.text,
                              false,
                              controller: allergyController,
                            ),
                            allergyPlain.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(8.0),
                                    height: 60,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Ticket(
                                            action: () {
                                              setState(() {
                                                allergyPlain.removeAt(index);
                                              });
                                            },
                                            label: allergyPlain[index]);
                                      },
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: allergyPlain.length,
                                    ),
                                  )
                                : Visibility(
                                    visible: false, child: Container()),
                            const SizedBox(height: 30),
                            kButtonTextField(
                              const Icon(Icons.no_meals_rounded),
                              const Icon(
                                Icons.add_circle_rounded,
                                color: Colors.red,
                                size: 26,
                              ),
                              () async {
                                Contact? newContact =
                                    await _contactPicker.selectContact();
                                setState(() {
                                  _contact = {
                                    "name": newContact?.fullName,
                                    "phone": newContact?.phoneNumbers
                                  };
                                  contactsList.add(_contact);
                                });
                              },
                              Colors.red,
                              const Color.fromRGBO(237, 232, 230, 1.0),
                              Colors.red.withOpacity(.05),
                              "Tap  '+'  to add contacts",
                              TextInputType.number,
                              true,
                            ),
                            const SizedBox(height: 15),
                            contactsList.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(8.0),
                                    height: 60,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Wrap(
                                          spacing: 8.0,
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            Text(contactsList[index]["name"],
                                                style: const TextStyle(
                                                    fontSize: 18)),
                                          ],
                                        );
                                      },
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: contactsList.length,
                                    ),
                                  )
                                : Visibility(
                                    visible: false, child: Container()),
                            const SizedBox(height: 20),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    buttonStyle2(
                      () {
                        createUser();
                        Navigator.pop(context);
                        if (isLoggedIn = true) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        }
                      },
                      'Sign Up',
                      MediaQuery.of(context).size.width * .4,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Already have an account?',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' Login',
                              style: const TextStyle(
                                  color: Colors.blueAccent, fontSize: 18),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => const LoginScreen(),
                                    ),
                                  );
                                }),
                        ]))
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future createUser() async {
    late UserCredential userCredential;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passController.text.trim(),
    );
    final userid = userCredential.user?.uid;
    addUserDetails(
      firstName: firstController.text.trim().toUpperCase(),
      lastName: lastController.text.trim().toUpperCase(),
      email: emailController.text.trim(),
      age: ageController.text.trim(),
      sex: selectedValue,
      allergies: allergyPlain,
      contacts: contactsList,
      id: userid,
    );
    userCredential.user?.updateDisplayName(firstController.text.trim());
    FirebaseAuth.instance.currentUser != null
        ? isLoggedIn = true
        : isLoggedIn = false;
  }

  Future addUserDetails(
      {List? allergies,
      List? contacts,
      String? sex,
      required id,
      required String firstName,
      required String lastName,
      required String email,
      required String age}) async {
    await FirebaseFirestore.instance.collection('users').doc(id).set({
      "FirstName": firstName,
      "LastName": lastName,
      "Email": email,
      "Age": age,
      "Sex": sex,
      "Contacts": contacts,
      "Allergies": allergies,
    });
  }
}
