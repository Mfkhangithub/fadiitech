// import 'dart:async';
// import 'package:flutter/material.dart';

// class Header extends StatefulWidget {
//   const Header({Key? key}) : super(key: key);

//   @override
//   State<Header> createState() => _HeaderState();
// }

// class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
//   late Timer _timer;
//   int _currentIndex = 0;
//   late AnimationController _controller;
//   late Animation<double> _animation;
  
//   final List<String> _images = [
//     'assets/banner.png',
//     'assets/bannertwo.png',
//     'assets/bannerthree.png',
//     'assets/bannerfr.png',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 10),
//       vsync: this,
//     )..repeat(reverse: false);

//     _animation = Tween<double>(begin: 1.0, end: -1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );

//     _startAutoSwap();
//   }

//   void _startAutoSwap() {
//     _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       setState(() {
//         _controller.reset(); // Restart animation for each image
//         _currentIndex = (_currentIndex + 1) % _images.length;
//       });
//       _controller.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           color: Colors.black,
//           height: 80,
//           child: AnimatedBuilder(
//             animation: _controller,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(_animation.value * MediaQuery.of(context).size.width, 0),
//                 child: const Text(
//                   'Welcome to FADII YT!',
//                   style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               );
//             },
//           ),
//         ),
//         // Container(
//         //   height: 400,
//         //   width: double.infinity,
//         //   child: AnimatedSwitcher(
//         //     duration: const Duration(seconds: 2),
//         //     child: FadeTransition(
//         //       opacity: _controller,
//         //       child: Image.asset(
//         //         _images[_currentIndex],
//         //         key: ValueKey<int>(_currentIndex),
//         //         fit: BoxFit.cover,
//         //         width: double.infinity,
//         //         height: 400,
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
