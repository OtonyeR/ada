import 'package:ada/constants/styles.dart';
import 'package:flutter/material.dart';

class ReplyArray {
  final List<BotReply> replies;

  ReplyArray({
    required this.replies,
  });

  factory ReplyArray.fromJson(List<dynamic> parsedJson) {
    List<BotReply> listreply = <BotReply>[];
    listreply = parsedJson.map((i) => BotReply.fromJson(i)).toList();

    return ReplyArray(replies: listreply);
  }
}
//
// class BotReply {
//   String? recipientId;
//   String? text;
//   String? image;
//   List<RasaButton>? button;
//
//   BotReply({this.recipientId, this.text, this.image, this.button});
//
//   factory BotReply.fromJson(Map<String, dynamic> json) => BotReply(
//         recipientId: json['recipient_id'],
//         text: json['text'],
//         image: json['image'],
//         button: RasaButton.fromJson(json["button"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "recipientId": recipientId,
//         "text": text,
//         "image": image,
//         "button": button?.toJson(),
//       };
//
//   // if (json['buttons'] != null) {
//   //   buttons = [];
//   //   json['buttons'].forEach((buttonJson) {
//   //     buttons!.add(RasaButton(
//   //       title: buttonJson['title'],
//   //       payload: buttonJson['payload'],
//   //     ));
//   //   });
//   // }
// }
//
// class RasaButton {
//   final String title;
//   final String payload;
//
//   RasaButton({required this.title, required this.payload});
//
//   factory RasaButton.fromJson(Map<String, dynamic> json) => RasaButton(
//         title: json["title"],
//         payload: json["payload"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "title": title,
//         "payload": payload,
//       };
// }

class BotReply {
  String? recipientId;
  String? image;
  String? text;
  List<Buttons>? buttons;

  BotReply({this.recipientId, this.image, this.text, this.buttons});

  BotReply.fromJson(Map<String, dynamic> json) {
    recipientId = json['recipient_id'];
    image = json['image'];
    text = json['text'];
    if (json['buttons'] != null) {
      buttons = <Buttons>[];
      json['buttons'].forEach((v) {
        buttons!.add(new Buttons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipient_id'] = this.recipientId;
    data['image'] = this.image;
    data['text'] = this.text;
    if (this.buttons != null) {
      data['buttons'] = this.buttons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Buttons {
  String? title;
  String? payload;

  Buttons({this.title, this.payload});

  Buttons.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    payload = json['payload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['payload'] = this.payload;
    return data;
  }
}
