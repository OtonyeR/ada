import 'package:flutter/material.dart';

class TextBar extends StatelessWidget {
  final TextEditingController textController;
  final Color messageBarColor;
  final Color sendButtonColor;
  final void Function(String)? onTextChanged;
  final void Function()? onSend;

  const TextBar({
    super.key,
    required this.textController,
    this.messageBarColor = Colors.transparent,
    this.sendButtonColor = const Color.fromRGBO(220, 20, 60, 1.0),
    this.onTextChanged,
    this.onSend,
  });

  /// [TextBar] constructor
  ///
  ///

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: messageBarColor,
        padding: const EdgeInsets.only(top: 8, left: 0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 4,
                    onChanged: onTextChanged,
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                      hintMaxLines: 1,
                      contentPadding: const EdgeInsets.only(
                          left: 16.0, top: 10, bottom: 10, right: 34),
                      hintStyle: const TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.black38,
                          width: 0.4,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.black26,
                          width: 0.5,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                  ),
                  Positioned(
                    right: 8,
                    bottom: 9,
                    child: InkWell(
                        onTap: onSend,
                        child: Icon(
                          Icons.send_rounded,
                          color: sendButtonColor,
                          size: 32.0,
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
