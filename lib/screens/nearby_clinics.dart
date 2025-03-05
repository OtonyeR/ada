import 'package:flutter/material.dart';

class NearbyClinics extends StatefulWidget {
  const NearbyClinics({Key? key}) : super(key: key);

  @override
  State<NearbyClinics> createState() => _NearbyClinicsState();
}

class _NearbyClinicsState extends State<NearbyClinics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinics In Your Vicinity'),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
      ),
    );
  }
}
