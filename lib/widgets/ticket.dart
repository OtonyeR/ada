import 'package:flutter/material.dart';

class Ticket extends StatefulWidget {
  Ticket({
    super.key,
    this.action,
    required this.label,
  });

  String label;
  dynamic action;

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: const EdgeInsets.only(right: 6.0, top: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: const Color.fromRGBO(220, 20, 60, 0.7450980392156863),
      ),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runAlignment: WrapAlignment.center,
          spacing: 15.0,
          children: [
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            GestureDetector(
              onTap: widget.action,
              child: const Icon(
                Icons.remove_circle_rounded,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
