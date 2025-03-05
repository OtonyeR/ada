import 'dart:convert';
import 'package:ada/screens/chatscreen.dart';
import 'package:ada/screens/places_screen.dart';
import 'package:ada/widgets/detail_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../constants/styles.dart';
import 'alertscreen.dart';
import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final userAuth = FirebaseAuth.instance.currentUser!;

final String? name = userAuth.displayName;
Map userData = {};
late String userAge;
late String userSex;
late String userNameLast;
late List<String> userAllergies;
late List userContacts;

final String id = userAuth.uid;

Future readUser() async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(id);
  final snapshot = await userDoc.get();

  if (snapshot.exists) {
    final data = snapshot.data() as Map<String, dynamic>;
    userData = data;
    return data;
  } else {
    return const Text("no data");
  }
}

// userDetails(UserM? user) async {
//   tename = (await readUser())!;
// }

class _HomePageState extends State<HomePage> {
  late GoogleMapController googleMapController;
  String lat = '';
  String lon = '';
  String address = '';

  @override
  void initState() {
    // locateMe();
    readUser();
    super.initState();
  }

  // ID of the provider (google.com, apple.com, etc.)

  void locateMe() async {
    List location = await _determinePosition();
    super.setState(() {
      lat = location[1].latitude.toString();
      lon = location[1].longitude.toString();
      address =
          '${location[0].street}, ${location[0].subAdministrativeArea}, ${location[0].postalCode}';
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    locateMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        elevation: 8.8,
        notchMargin: 6.0,
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        height: 70.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                isSelected: true,
                focusColor: const Color.fromRGBO(220, 20, 60, 1.0),
                onPressed: () {},
                icon: const Icon(Icons.dashboard),
                iconSize: 40.0,
                color: const Color.fromRGBO(220, 20, 60, 1.0),
              ),
            ),
            const Expanded(child: Text('')),
            Expanded(
              child: IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (builder) => const NearbyPlaces(),
                  //   ),
                  // );
                },
                icon: const Icon(Icons.settings),
                iconSize: 40.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 110,
        width: 100,
        child: FittedBox(child: aida(
          () async {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => ChatScreen(
                  lat: lat,
                  lon: lon,
                ),
                transitionDuration: const Duration(milliseconds: 600),
              ),
            );
          },
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, left: 20.0, right: 20.0, bottom: 33),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello ${name.toString()}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      "How may I help you today?",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black87,
                  ),
                  child: IconButton(
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      iconSize: 30,
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.topRight,
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            barrierColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            elevation: 10,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.84,
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30))),
                                  child: GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Sup',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Quick Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 7,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: address.isNotEmpty
                        ? DetailsCard(
                            name: address,
                            buttonText: 'Update Location',
                            heading: 'Current Location',
                            action: () {
                              locateMe();
                            })
                        : Container(
                            height: 170,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18.0),
                                border: Border.all(
                                    color: Colors.black12,
                                    width: 0.6,
                                    strokeAlign: BorderSide.strokeAlignOutside),
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 0.17,
                                    blurRadius: 6,
                                    color: Colors.white24,
                                  )
                                ]),
                            child: const Center(
                              child: Text(
                                "No info available",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                Expanded(
                  flex: 1,
                  child: userData.isNotEmpty
                      ? DetailsCard(
                          name: "$name ${userData['LastName']}",
                          heading: 'Profile Overview',
                          buttonText: 'Quick Alert',
                          action: () {},
                          inputSecondary: userData['Sex'],
                          otherInput: userData['Age'])
                      : Container(
                          height: 170,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18.0),
                              border: Border.all(
                                  color: Colors.black12,
                                  width: 0.6,
                                  strokeAlign: BorderSide.strokeAlignOutside),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 0.17,
                                  blurRadius: 6,
                                  color: Colors.white24,
                                )
                              ]),
                          child: const Center(
                            child: Text(
                              "No info available",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Quick Access',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: GridView(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.15,
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                crossAxisSpacing: 10,
              ),
              children: [
                featureCard(
                    const Color.fromRGBO(250, 231, 235, 1.0),
                    const Icon(
                      Icons.call,
                      color: Color.fromRGBO(220, 20, 60, 1.0),
                    ),
                    'Emergency \nAlert', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => AlertScreen(
                        lat: lat,
                        lon: lon,
                      ),
                    ),
                  );
                }),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Send emergency alert"),
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.arrow_back,
                        size: 24,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Send emergency alert"),
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 24,
                      )
                    ],
                  ),
                ),
                featureCard(
                    const Color.fromRGBO(240, 228, 248, 1.0),
                    const Icon(
                      Icons.place_rounded,
                      color: Color.fromRGBO(189, 126, 240, 1.0),
                    ),
                    'Nearby \nPlaces', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => NearbyPlaces(
                        lat: lat,
                        lon: lon,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

Future<List> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return Future.error('Location services are disabled');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error("Location permission denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied');
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  List<Placemark> placemark =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark place = placemark[0];
  List location = [place, position];
  return location;
}
