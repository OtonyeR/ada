import 'package:flutter/material.dart';

class FinderTag extends StatefulWidget {
  final int index;
  final String label;
  final bool isSelected;
  final VoidCallback deSelect;
  final VoidCallback onSelect;
  const FinderTag(
      {Key? key,
      required this.index,
      required this.isSelected,
      required this.onSelect,
      required this.deSelect,
      required this.label})
      : super(key: key);

  @override
  State<FinderTag> createState() => _FinderTagState();
}

class _FinderTagState extends State<FinderTag> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isSelected ? widget.deSelect : widget.onSelect,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: widget.isSelected
                  ? Colors.black
                  : const Color.fromRGBO(220, 20, 60, 1.0),
            ),
            child: Center(
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
