import 'dart:convert';
// import 'package:ada/constants/styles.dart';
import 'package:ada/widgets/place_box.dart';
import 'package:http/http.dart' as http;
import 'package:ada/models/nearby_response.dart';
import 'package:flutter/material.dart';
import 'package:ada/widgets/find_tag.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyPlaces extends StatefulWidget {
  final String lat;
  final String lon;
  const NearbyPlaces({
    required this.lat,
    required this.lon,
    Key? key,
  }) : super(key: key);

  @override
  State<NearbyPlaces> createState() => _NearbyPlacesState();
}

class _NearbyPlacesState extends State<NearbyPlaces> {
  List<Map> places = [
    {'type': 'hospital', 'keyword': 'Hospital'},
    {'type': 'police', 'keyword': 'Police Station'},
    {'type': 'pharmacy', 'keyword': 'Pharmacy'},
  ];
  bool active = false;
  dynamic currentSelectionIndex;
  String placeValue = 'Select a Place';
  String type = '';
  String apiKey = "";
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Nearby Places'),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black, size: 30),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => FinderTag(
                    index: index,
                    label: places[index]['keyword'],
                    isSelected: currentSelectionIndex == index,
                    onSelect: () {
                      setState(() {
                        currentSelectionIndex = index;
                        placeValue = places[index]['keyword'];
                        type = places[index]['type'];
                        getNearbyPlaces(placeValue, type);
                      });
                    },
                    deSelect: () {
                      setState(() {
                        currentSelectionIndex = null;
                        placeValue = '';
                        type = '';
                      });
                    },
                  ),
                ),
              ),
            ),
            PlaceBox(
              widget: currentSelectionIndex == null
                  ? Column(
                      children: [
                        Container(
                          color: Colors.white,
                          margin:
                              const EdgeInsets.only(top: 150.0, bottom: 30.0),
                          child: Image.asset(
                            alignment: Alignment.center,
                            'assets/images/place.png',
                          ),
                        ),
                        const Text(
                          'Search for places by tapping the tags above',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            // color: Color.fromRGBO(220, 20, 60, 1.0),
                          ),
                        )
                      ],
                    )
                  : (nearbyPlacesResponse.results != null)
                      ? Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: nearbyPlacesResponse.results!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return nearbyPlacesWidget(
                                    nearbyPlacesResponse.results![index]);
                              }),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: const Color.fromRGBO(220, 20, 60, 1.0),
                          ),
                        ),
            ),
          ]),
        ));
  }

  void getNearbyPlaces(place, keyword) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=$keyword&location=${widget.lat},${widget.lon}&rankby=distance&type=$place&key=$apiKey');
    var response = await http.post(url);

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
  }

  Widget nearbyPlacesWidget(Results results) {
    return GestureDetector(
      onTap: () async {
        var url = Uri.parse(
            'https://www.google.com/maps/dir/?api=1&origin=${widget.lat}%2C${widget.lon}&destination=${results.geometry!.location!.lat}%2C${results.geometry!.location!.lng}&destination_place_id=${results.placeId}');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(blurRadius: 1, color: Colors.black12)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 30,
                      ),
                      Expanded(
                        child: Text(
                          results.name!,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    results.vicinity!,
                    style: const TextStyle(),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(results.openingHours != null
                      ? results.openingHours!.openNow == true
                          ? 'Open'
                          : 'Closed'
                      : 'None Available')
                ],
              ),
            ),
            Container(
              height: 80,
              width: 80,
              margin: const EdgeInsets.only(left: 6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                image: results.photos != null
                    ? DecorationImage(
                        image: NetworkImage(
                            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${results.photos![0].photoReference}&key=$apiKey'),
                        fit: BoxFit.fill,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/placeholder.png'),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
