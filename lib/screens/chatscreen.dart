// ignore_for_file: library_prefixes
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ada/constants/styles.dart';
import 'package:ada/models/nearby_response.dart';
import 'package:ada/models/reply_model.dart';
import 'package:ada/screens/homescreen.dart';
import 'package:ada/widgets/bot_messages.dart';
import 'package:ada/widgets/chat_message.dart';
import 'package:ada/widgets/text_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tflite/tflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'alertscreenf.dart';

class ChatScreen extends StatefulWidget {
  final String lat;
  final String lon;

  const ChatScreen({
    Key? key,
    required this.lat,
    required this.lon,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController messageInputController = TextEditingController();

  SpeechToText speechToText = SpeechToText();
  TextToSpeech tts = TextToSpeech();

  Future<void> runTextToSpeech(
      String currentTtsString, double currentSpeechRate) async {
    // await tts.awaitSpeakCompletion(true);
    await tts.getVoice();
    List voice = await tts.getLanguages();
    print(voice);
    await tts.setPitch(1.0);
    await tts.setVolume(1.0);
    await tts.setRate(currentSpeechRate);
    await tts.speak(currentTtsString);
  }

  String apiKey = "";

  bool isListening = false;
  List botReplies = [];
  // late dynamic buttonResponse;
  List<dynamic> talk = [];
  List<String> speech = [];
  String speechText = '';
  bool isReplying = false;
  late String imageMessage;
  final String id = userAuth.uid;

  @override
  void initState() {
    super.initState();
    isReplying = true;

    loadModel().then((value) {
      setState(() {
        isReplying = false;
      });
    });
    informBot();
  }

  // Create an animation with value of type "double"
  final spinKit = const SpinKitDoubleBounce(
    color: Color.fromRGBO(220, 20, 60, 1.0),
    size: 70.0,
    duration: Duration(seconds: 4),
  );

  //declare image variables
  File? imagePath;
  dynamic image;
  late String imageID;
  final ImagePicker picker = ImagePicker();
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  Future informBot() async {
    final response = await http.post(
      Uri.parse('http://192.168.43.153:5005/webhooks/rest/webhook'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "message": "about me",
        "metadata": {
          "name": name.toString(),
          "age": userData["Age"],
          "sex": userData["Sex"],
          "contacts": userData["Contacts"],
          "allergies": userData["Allergies"],
        }
      }),
    );
    response.statusCode;
  }

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    final img = await picker.pickImage(source: media);
    if (img == null) return;
    imagePath = File(img.path);
    imageID = "img.name ${Random().nextInt(40)}";
    setState(() {
      sendImage();
      isReplying = false;
    });
    String output = await classifyImage(imagePath);
    String imageMess = output.replaceAll(RegExp(r'[0-9]'), '');
    imageMessage = imageMess.replaceAll(RegExp(''), '');
    getReply("This is an image: $imageMessage");
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  classifyImage(image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      isReplying = false;
      //Declare List _outputs in the class which will be used to show the classified class name and confidence
    });
    return output![0]["label"];
  }

  Future<List<Results>?> getNearbyPlaces(place, keyword) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=$keyword&location=${widget.lat},${widget.lon}&rankby=distance&type=$place&key=$apiKey');
    var response = await http.post(url);

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    return nearbyPlacesResponse.results ?? [];
  }

  Future getReply(String? message, {image}) async {
    isReplying = true;
    final response = await http.post(
      Uri.parse('http://192.168.43.153:5005/webhooks/rest/webhook'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "sender": id,
        "message": message,
        "metadata": {"imageData": image}
      }),
    );

    // Do something with the response
    if (response.statusCode == 200) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      var parsedResponse = ReplyArray.fromJson(jsonResponse);
      var responseList = parsedResponse.replies;

      // Clear the existing list of bot reply widgets
      // Widget place;
      botReplies.clear();
      List gist = [];

      for (var reply in responseList) {
        botResponse(
          text: reply.text,
          image: reply.image,
          buttons: reply.buttons,
        );
        gist.add(reply.text);

        Widget place;

        if (reply.buttons != null) {
          Widget buttonList = Container(
            height: 60,
            margin: const EdgeInsets.only(bottom: 20.0),
            child: ListView.builder(
              itemCount: reply.buttons!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return buttonStyle5(
                  action: () async {
                    sendMessage(reply.buttons![index].title);
                    await getReply(reply.buttons![index].payload);
                  },
                  label: "${reply.buttons![index].title}",
                  width: MediaQuery.of(context).size.width * .4,
                );
              },
            ),
          );
          setState(() {
            talk.insert(0, buttonList);
          });
        } else {
          Container();
        }

        if (reply.text == "Finding nearby hospitals...") {
          List<Results>? places = await getNearbyPlaces(
              "Hospital", "hospital"); // Handle hospital results
          // List<Results>? places = await nearbyPlacesResponse.results;
          if (places!.isNotEmpty) {
            botResponse(text: "I found two hospitals nearby");
            await tts.speak("I found two hospitals nearby");
            place = ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return nearbyPlacesWidget(places[index]);
                });
            talk.insert(0, place);
          } else {
            botResponse(text: "Can't perform search");
          }
        }

        if (reply.text == "Finding nearby police station...") {
          List<Results>? places = await getNearbyPlaces(
              "Police Station", "police"); // Handle police station results
          if (places!.isNotEmpty) {
            botResponse(text: "I found two police stations nearby");
            await tts.speak("I found two police stations nearby");

            place = ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return nearbyPlacesWidget(places[index]);
                });
            talk.insert(0, place);
          } else {
            botResponse(text: "Can't perform search");
          }
        }

        if (reply.text == "Finding nearby pharmacy...") {
          List<Results>? places = await getNearbyPlaces("Pharmacy", "pharmacy");
          if (places!.isNotEmpty) {
            botResponse(text: "I found two pharmacies nearby");
            await tts.speak("I found two pharmacies nearby");
            place = ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return nearbyPlacesWidget(places[index]);
                });
            talk.insert(0, place);
          } else {
            botResponse(text: "Can't perform search");
          }
        }

        if (reply.text == "Dialed emergency number...") {
          // Handle emergency number logic
          _callNumber(112);
        }

        if (reply.text == "Sent quick SOS alerts to emergency contacts...") {
          // Handle SOS alerts logic
          List<String> numbers = [];
          _sendSMS(
              "I need immediate help! Please send assistance to my location",
              numbers);
        }

        if (reply.text == "Redirecting to custom alert page...") {
          // Handle custom alert logic
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const AlertScreen()));
        }

        if (reply.text == "Redirecting to helplines page...") {
          // Handle helplines page redirection
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const AlertScreen()));
        }
      }
      botReplies.addAll(gist);
      for (var bottalk in botReplies) {
        await tts.speak(bottalk);
        await Future.delayed(Duration(seconds: 12)); // Add a delay of 1 second
      }
      gist.clear();
      print(botReplies);
      // Return the list of BotNormal widgets
      print(responseList);
      return;
    } else {
      return [];
    }
  }

  void sendMessage(send) async {
    Bubble message = Bubble(
      text: send,
      textType: 'text',
    );
    // tts.speak(send);
    setState(() {
      talk.insert(0, message);
    });
  }

  void sendVoice() {
    if (speechText != '') {
      Bubble voice = Bubble(
        textType: 'text',
        text: speechText,
      );
      setState(() {
        talk.insert(0, voice);
      });
    } else {
      return;
    }
  }

  void sendImage() {
    Bubble photo = Bubble(
      textType: 'image',
      id: imageID,
      image: imagePath,
      text: speechText,
    );
    setState(() {
      talk.insert(0, photo);
    });
  }

  void botResponse({String? text, String? image, List<Buttons>? buttons}) {
    BotNormal bot = BotNormal(
      text: text,
      image: image,
      buttons: buttons,
      // chatList: talk,
      // condition: isReplying,
    );
    setState(() {
      talk.insert(0, bot);
    });
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(252, 247, 248, 1.0),
      body: SafeArea(
        child: Column(children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => const HomePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: FittedBox(
                          child: aidaActive(
                        () {},
                        isReplying == true ? spinKit : Container(),
                      )),
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              cacheExtent: 20.0,
              itemBuilder: (context, index) {
                return talk[index];
              },
              physics: const BouncingScrollPhysics(),
              itemCount: talk.length,
              reverse: true,
            ),
          ),
          isListening == true
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('I\'m Listening...',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: Colors.black26)),
                )
              : Container(),
          Container(
            margin: const EdgeInsets.only(
                bottom: 20.0, right: 14.0, left: 6.0, top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 7.2),
                    child: IconButton(
                      icon: const Icon(
                        Icons.photo_camera_rounded,
                        color: Color.fromRGBO(220, 20, 60, 1.0),
                        size: 40,
                      ),
                      onPressed: () async {
                        myAlert();
                        await getReply('This is an image', image: image);
                        isReplying = false;
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    child: TextBar(
                      textController: messageInputController,
                      onSend: () async {
                        String input = messageInputController.text;
                        input.isNotEmpty ? sendMessage(input) : null;
                        messageInputController.clear();
                        await getReply(input);
                        isReplying = false;
                        // .then((value) => {
                        //   for (dynamic val in value)
                        //     {
                        //       // botResponse(val),
                        //       // print(value),
                        //     },
                        //   isTyping = false,
                        // }
                        // );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 0.5),
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {},
                      onTapDown: (details) async {
                        if (!isListening) {
                          bool available = await speechToText.initialize();
                          if (available) {
                            setState(() {
                              isListening = true;
                              speechToText.listen(onResult: (result) {
                                setState(() {
                                  String words = result.recognizedWords;
                                  result.finalResult ? speech.add(words) : null;
                                  speechText = speech.last;
                                  print(speechText);
                                  speech.clear();
                                  sendVoice();
                                  getReply(speechText);
                                  isReplying = false;

                                  // .then((value) => {
                                  //   for (dynamic val in value)
                                  //     {
                                  //       // botResponse(val),
                                  //       // print(value),
                                  //     },
                                  //   isTyping = false,
                                  // });
                                });
                              });
                            });
                          }
                        }
                      },
                      onTapUp: (details) {
                        setState(() {
                          isListening = false;
                        });
                        speechToText.stop();
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: isListening == true ? 60 : 45,
                          width: isListening == true ? 60 : 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: const Color.fromRGBO(220, 20, 60, 1.0),
                          ),
                          child: Icon(
                            isListening ? Icons.mic : Icons.mic_none,
                            color: Colors.white,
                            size: isListening == true ? 28 : 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text(
              'Please choose media to select',
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  Expanded(
                    child: buttonStyle(
                      () {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                      },
                      'From Gallery',
                      Icons.image,
                    ),
                  ),
                  Expanded(
                    child: buttonStyle(
                      () {
                        Navigator.pop(context);
                        getImage(ImageSource.camera);
                      },
                      'From Camera',
                      Icons.camera,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showPopup() {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/img.png",
                      height: 160,
                      width: 250,
                    ),
                    const Material(
                        child: Text(
                      "Are You Flutter Developer?",
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 18,
                      ),
                    )),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("NO")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("YES")),
                        ]),
                  ],
                )),
          );
        });
  }

  Widget nearbyPlacesWidget(Results results) {
    return Column(
      children: [
        BotNormal(
          text:
              "One of them is ${results.name!} \nIt is located around ${results.vicinity!}",
        ),
        GestureDetector(
          onTap: () async {
            var url = Uri.parse(
                'https://www.google.com/maps/dir/?api=1&origin=${widget.lat}%2C${widget.lon}&destination=${results.geometry!.location!.lat}%2C${results.geometry!.location!.lng}&destination_place_id=${results.placeId}');
            if (await canLaunchUrl(url)) {
              await launchUrl(url,
                  mode: LaunchMode.externalNonBrowserApplication);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Container(
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.only(left: 18.0),
            child: const Text(
              "See directions",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(220, 20, 60, 1.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _callNumber(number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void _sendSMS(String message, List<String> recipients) async {
    String result = await sendSMS(
            message: message, recipients: recipients, sendDirect: true)
        .catchError((onError) {
      print(onError);
      return "E no work";
    });
    print(result);
  }
}
