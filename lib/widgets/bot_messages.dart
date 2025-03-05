import 'dart:math';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/styles.dart';
import '../models/reply_model.dart';

class BotNormal extends StatelessWidget {
  final Color color;
  final String? text;
  final TextStyle textStyle;
  final String? image;
  final List<Buttons>? buttons;
  BotNormal({
    Key? key,
    this.color = Colors.white70,
    this.text,
    this.textStyle = const TextStyle(
        color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w800),
    this.image,
    this.buttons,
  }) : super(key: key);

  final String id = Random().nextInt(123).toString();
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          Visibility(
            visible: text != null,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child: SelectableText(
                  text!,
                  toolbarOptions: const ToolbarOptions(
                    copy: true,
                    selectAll: true,
                  ),
                  style: text!.contains('emergency')
                      ? const TextStyle(
                          color: Color.fromRGBO(220, 20, 60, 1.0),
                          fontSize: 22,
                          fontWeight: FontWeight.w700)
                      : textStyle,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          image != null && image!.isNotEmpty
              ? BubbleNormalImage(
                  id: id,
                  image: Image.network(
                    image!,
                    scale: 1.0,
                    repeat: ImageRepeat.noRepeat,
                    width: MediaQuery.of(context).size.width * 0.7,
                    fit: BoxFit.cover,
                  ),
                  bubbleRadius: 0.3,
                  isSender: false,
                  tail: false,
                )
              : Container(),
          // buttons != null && buttons!.isNotEmpty
          //     ? Container(
          //         height: 60,
          //         margin: const EdgeInsets.only(bottom: 20.0),
          //         child: ListView.builder(
          //           itemCount: buttons!.length,
          //           scrollDirection: Axis.horizontal,
          //           itemBuilder: (BuildContext context, int index) {
          //             return buttonStyle5(
          //               action: action,
          //               label: "${buttons![index].title}",
          //               width: MediaQuery.of(context).size.width * .4,
          //             );
          //           },
          //         ),
          //       )
          //     : Container(),
        ],
      ),
    );
  }
}
