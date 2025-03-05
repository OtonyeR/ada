import 'package:flutter/material.dart';

class NearbyStations extends StatefulWidget {
  const NearbyStations({Key? key}) : super(key: key);

  @override
  State<NearbyStations> createState() => _NearbyStationsState();
}

class _NearbyStationsState extends State<NearbyStations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Stations In Your Vicinity'),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      body: SingleChildScrollView(),
    );
  }
}
