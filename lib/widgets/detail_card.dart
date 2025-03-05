import 'package:flutter/material.dart';

class DetailsCard extends StatefulWidget {
  DetailsCard({
    super.key,
    this.inputSecondary,
    this.otherInput,
    this.addInput,
    required this.name,
    required this.heading,
    required this.buttonText,
    required this.action,
  });

  final dynamic name;
  final String heading;
  final String buttonText;
  final dynamic action;
  dynamic inputSecondary;
  dynamic otherInput;
  dynamic addInput;

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      margin:
          const EdgeInsets.only(top: 4.0, left: 4.0, right: 10, bottom: 4.0),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.heading,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black54),
          ),
          const SizedBox(
            height: 4,
          ),
          widget.name == null
              ? const CircularProgressIndicator()
              : Center(
                  child: Text(
                    widget.name.toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
          widget.inputSecondary != null && widget.otherInput != null
              ? Wrap(
                  spacing: 12.0,
                  children: [
                    Text(
                      widget.inputSecondary.toString().toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black87),
                    ),
                    Text(
                      widget.otherInput.toString().toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: Colors.black87),
                    ),
                  ],
                )
              : Container(),
          widget.addInput != null
              ? Text(
                  widget.addInput,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                      color: Colors.black54),
                )
              : Container(),
          Center(
            child: GestureDetector(
              onTap: widget.action,
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(220, 20, 60, 1.0),
                    borderRadius: BorderRadius.circular(16.0)),
                child: Text(
                  widget.buttonText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
