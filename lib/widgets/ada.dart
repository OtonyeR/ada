// import 'package:flutter/material.dart';
//
// class aid extends StatefulWidget {
//   var action;
//   aid({Key? key, required this.action}) : super(key: key);
//
//   @override
//   State<aid> createState() => _aidState();
// }
//
// class _aidState extends State<aid> with SingleTickerProviderStateMixin {
//   AnimationController? _controller;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 800))
//       ..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _controller!.dispose();
//     super.dispose();
//   }
//
//   late final Animation<double> _animation = CurvedAnimation(
//     parent: _controller,
//     curve: Curves.linear,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.action,
//       child: Hero(
//         tag: 'aida',
//         child: RotationTransition(
//           turns: ,
//           child: Container(
//             height: 80,
//             width: 80,
//             decoration: BoxDecoration(
//                 color: const Color.fromRGBO(255, 143, 143, 1.0),
//                 borderRadius: BorderRadius.circular(42)),
//             child: Stack(children: [
//               Center(
//                 child: Container(
//                   height: 62,
//                   width: 62,
//                   decoration: BoxDecoration(
//                       color: Colors.red, borderRadius: BorderRadius.circular(31)),
//                 ),
//               ),
//               Center(
//                 child: Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                       color: const Color.fromRGBO(255, 199, 199, 1.0),
//                       borderRadius: BorderRadius.circular(20)),
//                 ),
//               ),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }
