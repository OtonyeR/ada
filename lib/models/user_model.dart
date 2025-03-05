// import 'package:ada/widgets/detail_card.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class UserM {
//   final String? uid;
//   final String? firstName;
//   final String? lastName;
//   final String? email;
//   final String? age;
//   final String sex;
//   final List contacts;
//   final List<String>? allergies;
//   // final String? code; //code firebaseauth exemption
//   UserM(
//       {this.age,
//       required this.sex,
//       required this.contacts,
//       this.allergies,
//       this.uid,
//       required this.firstName,
//       required this.lastName,
//       this.email});
//
//   Map<String, dynamic> toJson() => {
//         "FirstName": firstName,
//         "LastName": lastName,
//         "Email": email,
//         "Age": age,
//         "Sex": sex,
//         "Contacts": contacts,
//         "Allergies": allergies,
//       };
// //   static UserM fromJson(Map<String, dynamic> json) => UserM(
// //       age: json['age'],
// //       sex: json['sex'],
// //       contacts: json['contacts'],
// //       firstName: json['firstName'],
// //       lastName: json['lastName'],
// //       email: json['email'],
// //       allergies: json['allergies']);
// // }
//
//   factory UserM.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   ) {
//     final data = snapshot.data();
//     return UserM(
//       age: data?['age'],
//       sex: data?['sex'],
//       contacts: List.from(data!['contacts']),
//       firstName: data['firstName'],
//       lastName: data['lastName'],
//       email: data['email'],
//       allergies:
//           data['allergies'] is Iterable ? List.from(data['allergies']) : null,
//     );
//   }
//
// // factory UserM.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
// //   final data = document.data()!;
// //   return UserM(
// //       age: data["Age"],
// //       sex: data["Sex"],
// //       contacts: List<String>.from(data['Contacts']),
// //       allergies: List<String>.from(data['Allergies']),
// //       firstName: data["FirstName"],
// //       lastName: data["LastName"]);
// // }
// }
//
// class UserWidget extends StatelessWidget {
//   final UserM user;
//
//   UserWidget({required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return DetailsCard(
//       input: "${user.firstName} ${user.lastName}",
//       heading: "Profile Overview",
//       buttonText: "Quick Alert",
//       action: () {},
//       inputSecondary: user.sex,
//       otherInput: user.age,
//     );
//   }
// }
