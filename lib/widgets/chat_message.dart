import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class Bubble extends StatelessWidget {
  Bubble({
    Key? key,
    required this.text,
    required this.textType,
    this.id,
    this.image,
  }) : super(key: key);
  String textType;
  dynamic id;
  dynamic text;
  dynamic image;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: textType == 'image'
            ? BubbleNormalImage(
                id: id.toString(),
                isSender: true,
                image: Image.file(
                  image,
                  scale: 1.0,
                  repeat: ImageRepeat.noRepeat,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ))
            : BubbleNormal(
                text: text,
                isSender: true,
                color: const Color.fromRGBO(44, 41, 41, 1.0),
                textStyle: const TextStyle(
                    color: Color.fromRGBO(252, 247, 248, 1.0), fontSize: 16),
              )
        // : isSender == false && textType == 'image'
        //     ? BubbleNormalImage(
        //         id: id.toString(),
        //         image: Image.file(
        //           image,
        //           scale: 1.0,
        //           repeat: ImageRepeat.noRepeat,
        //           width: MediaQuery.of(context).size.width * 0.7,
        //           fit: BoxFit.cover,
        //         ))
        // : BotNormal(
        //     text: text,
        //     image: image,
        //     buttons: buttons,
        //     textStyle: const TextStyle(
        //         color: Color.fromRGBO(
        //             44, 41, 41, 1.0), //Color.fromRGBO(44, 41, 41, 1.0),
        //         fontSize: 32,
        //         fontWeight: FontWeight.w700),
        //   )
        );
  }
}
