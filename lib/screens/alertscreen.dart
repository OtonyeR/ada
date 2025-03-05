import 'package:ada/constants/styles.dart';
import 'package:ada/screens/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:telephony/telephony.dart';

class AlertScreen extends StatefulWidget {
  final String lat;
  final String lon;

  const AlertScreen({
    Key? key,
    required this.lat,
    required this.lon,
  }) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

final Telephony telephony = Telephony.instance;

String emer = '112';
String ambulance = '+23480022556362';
bool isSelected = false;
List<String> textTemplates = [
  "Emergency! Need immediate medical assistance!",
  "Help! Fire emergency, please send firefighters!",
  "Urgent! Car accident, send help right away!",
  "SOS! Drowning incident, need rescue team!",
  "Attention! Robbery in progress, call the police!",
  "Emergency situation! Gas leak, evacuate the area!",
  "Help needed! Violent altercation, urgent intervention required!",
  "Seeking assistance! Lost in the wilderness, need rescue!",
  "Emergency call! Suspected heart attack, need paramedics!",
  "Danger! Building collapse, send search and rescue team!",
];

String customText = 'Please I need your help.\n This is my location';
String quickText = '';
final TextEditingController messageController = TextEditingController();
List<dynamic> contactList = userData["Contacts"][0]["name"];

List<String> numbers = ['08104297455'];
void parseContact() {
  return;
  numbers.clear();
  for (var contact in contactList) {
    List<dynamic> contactPhoneNumbers = contact["phone"];
    numbers.addAll(contactPhoneNumbers.map((number) => number.toString()));
  }
}

String selectedMessage = '';

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Send Alerts',
          style: TextStyle(fontSize: 24),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: const Text(
                "Get help from friends \n and professionals quickly",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        //parseContact();
                        confirm112Call();
                      },
                      child: Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 2),
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(220, 20, 60, 1.0),
                            border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.black12),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 0.4,
                                blurRadius: 2,
                                color: Colors.black12,
                              )
                            ],
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          child: const Center(
                            child: Text(
                              "Dial \n112",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white
                                  // color: Color.fromRGBO(220, 20, 60, 1.0),
                                  ),
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        quickSOS();
                      },
                      child: Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 2),
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(220, 20, 60, 1.0),
                            border: Border.all(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.black12),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 0.4,
                                blurRadius: 2,
                                color: Colors.black12,
                              )
                            ],
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          child: const Center(
                            child: Text(
                              "Quick \n SOS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        confirmShareLocation();
                      },
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 2),
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(220, 20, 60, 1.0),
                          border: Border.all(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.black12),
                          boxShadow: const [
                            BoxShadow(
                              spreadRadius: 0.4,
                              blurRadius: 2,
                              color: Colors.black12,
                            )
                          ],
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Share \n Location",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              flex: 2,
              child: ListView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 0.0),
                  physics: const BouncingScrollPhysics(),
                  // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //   childAspectRatio: 1.09,
                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 20,
                  //   crossAxisSpacing: 20,
                  // ),
                  children: [
                    alertCard(
                      context,
                      'Custom SOS',
                      () {
                        customSOS();
                      },
                      const Color.fromRGBO(250, 231, 235, 1.0),
                      const Icon(
                        CupertinoIcons.bubble_left_fill,
                        color: Color.fromRGBO(220, 20, 60, 1.0),
                      ),
                    ),
                    alertCard(
                      context,
                      'Call an ambulance',
                      () {
                        _callNumber(ambulance);
                      },
                      const Color.fromRGBO(250, 231, 235, 1.0),
                      const Icon(
                        Icons.call,
                        color: Color.fromRGBO(220, 20, 60, 1.0),
                      ),
                    ),
                    alertCard(
                      context,
                      'View Contacts',
                      () {},
                      const Color.fromRGBO(250, 231, 235, 1.0),
                      const Icon(
                        CupertinoIcons.person_3_fill,
                        color: Color.fromRGBO(220, 20, 60, 1.0),
                      ),
                    ),
                    alertCard(
                      context,
                      'View National Helplines',
                      () {},
                      const Color.fromRGBO(250, 231, 235, 1.0),
                      const Icon(
                        Icons.lightbulb_circle_rounded,
                        color: Color.fromRGBO(220, 20, 60, 1.0),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  void confirmShareLocation() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return CupertinoPopupSurface(
            isSurfacePainted: true,
            child: Container(
                padding: const EdgeInsetsDirectional.all(20),
                color: CupertinoColors.white,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).copyWith().size.height * 0.35,
                child: Material(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/images/mylocation.png",
                      ),
                      const Text(
                        "This will share your location with all you emergency contacts?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 18,
                        ),
                      ),
                      Material(
                        child: buttonStyle2(() {
                          // parseContact();
                          _sendSMS(
                              "I'm sharing my location with you \n https://www.google.com/maps/search/?api=1&query=${widget.lat}%2C${widget.lon}",
                              numbers);
                          AlertDialog(
                            title: const Text('Success'),
                            content: const Text('Location shared'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        }, "Okay", MediaQuery.of(context).size.width * 0.4),
                      )
                    ],
                  ),
                )),
          );
        });
  }

  void confirm112Call() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return CupertinoPopupSurface(
            isSurfacePainted: true,
            child: Container(
                padding: const EdgeInsetsDirectional.all(20),
                color: CupertinoColors.white,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).copyWith().size.height * 0.35,
                child: Material(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/images/112phone.png",
                      ),
                      const Text(
                        "This will call the Nigerian Emergency Line?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 18,
                        ),
                      ),
                      buttonStyle2(() {
                        _callNumber(emer);
                        Navigator.of(context).pop();
                      }, "Okay", MediaQuery.of(context).size.width * 0.4)
                    ],
                  ),
                )),
          );
        });
  }

  void confirmCall() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return CupertinoPopupSurface(
            isSurfacePainted: true,
            child: Container(
                padding: const EdgeInsetsDirectional.all(20),
                color: CupertinoColors.white,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).copyWith().size.height * 0.35,
                child: Material(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/images/112phone.png",
                      ),
                      const Text(
                        "This will call the Nigerian Emergency Line?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 18,
                        ),
                      ),
                      buttonStyle2(() {
                        _callNumber("080022556362");
                        Navigator.of(context).pop();
                      }, "Okay", MediaQuery.of(context).size.width * 0.4)
                    ],
                  ),
                )),
          );
        });
  }

  void customSOS() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 10,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.44,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      const Text(
                        "Type your custom message",
                        style: TextStyle(fontSize: 22),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 50.0),
                          child: TextField(
                            controller: messageController,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 5,
                            maxLines: 7,
                            onChanged: (text) {
                              text = messageController.text;
                              setState(() {
                                customText = text;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Type your message here...',
                              hintMaxLines: 1,
                              contentPadding: const EdgeInsets.only(
                                  left: 20.0, top: 20, bottom: 10, right: 34),
                              hintStyle: const TextStyle(
                                  fontSize: 16, fontStyle: FontStyle.italic),
                              fillColor:
                                  const Color.fromRGBO(250, 231, 235, 1.0),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none),
                            ),
                            textInputAction: TextInputAction.send,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Text(
                          "Tapping 'send' means all listed emergency contacts receive this message",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      buttonStyle2(() {
                        parseContact();
                        _sendSMS(customText, numbers);
                      }, "Send", MediaQuery.of(context).size.width * 0.4)
                    ],
                  ),
                )),
          );
        });
  }

  void quickSOS() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 10,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 25.0),
            child: Column(
              children: [
                const Text(
                  "Pick a quick SOS message",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: textTemplates.length,
                    itemBuilder: (BuildContext context, int index) {
                      return StatefulBuilder(
                        builder:
                            (BuildContext context, StateSetter setModalState) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(250, 231, 235, 1.0),
                              border: Border.all(style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(22.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white54.withOpacity(0.1),
                                  spreadRadius: 0.1,
                                  blurRadius: 0.1,
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () {
                                setModalState(() {
                                  isSelected = !isSelected;
                                  quickText = textTemplates[index];
                                  print(quickText);
                                });
                              },
                              selected: (quickText == textTemplates[index]),
                              selectedTileColor:
                                  const Color.fromRGBO(220, 20, 60, 1.0),
                              title: Text(
                                textTemplates[index],
                                softWrap: true,
                                textWidthBasis: TextWidthBasis.parent,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.black87, fontSize: 24),
                              ),
                              trailing: Visibility(
                                visible: (quickText == textTemplates[index] &&
                                    isSelected),
                                child: const Icon(
                                  Icons.check,
                                  textDirection: TextDirection.rtl,
                                  color: Color.fromRGBO(220, 20, 60, 1.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const SizedBox(
                  width: 380,
                  child: Text(
                    "Tapping 'send' means all listed emergency contacts receive this message",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buttonStyle2(() {
                    if (quickText.isNotEmpty) {
                      // parseContact();
                      _sendSMS(quickText, numbers);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Please select an emergency message.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }, "Send", MediaQuery.of(context).size.width * 0.4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _callNumber(number) async {
  await FlutterPhoneDirectCaller.callNumber(number);
}

void _sendSMS(String message, List<String> recipents) async {
  bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
  String result =
      await sendSMS(message: message, recipients: recipents, sendDirect: true)
          .catchError((onError) {
    print(onError);
    return "E no work";
  });
  print(result);
}
