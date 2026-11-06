// import 'package:flutter/material.dart';
// import 'package:websidefadii/Utils/background.dart';
// import 'package:websidefadii/Utils/skill_section.dart';

// class SkillsPage extends StatefulWidget {
//   const SkillsPage({super.key});

//   @override
//   State<SkillsPage> createState() => _SkillsPageState();
// }

// class _SkillsPageState extends State<SkillsPage> {
//   final ScrollController _scrollController = ScrollController();
//   bool _isScrolled = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (_scrollController.offset > 50) {
//       if (!_isScrolled) {
//         setState(() {
//           _isScrolled = true;
//         });
//       }
//     } else {
//       if (_isScrolled) {
//         setState(() {
//           _isScrolled = false;
//         });
//       }
//     }
//   }

//   void _navigateTo(String route) {
//     Navigator.pushNamed(context, route);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           const BackgroundWidget(),
//           SingleChildScrollView(
//             controller: _scrollController,
//             child: const Column(
//               children: [
//                 SizedBox(height: 80),
//                 SkillsSection(),
//               ],
//             ),
//           ),
//           // Positioned(
//           //   top: 0,
//           //   left: 0,
//           //   right: 0,
//           //   child: PortfolioNavBar(
//           //     currentRoute: '/skills',
//           //     onNavigate: _navigateTo,
//           //     isScrolled: _isScrolled,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }