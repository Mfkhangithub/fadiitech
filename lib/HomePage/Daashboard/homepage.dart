import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:websidefadii/HomePage/Daashboard/games.dart';
import 'package:websidefadii/HomePage/Daashboard/slider_section.dart';
import 'package:websidefadii/HomePage/LoginPage/loginpage.dart';
import 'package:websidefadii/HomePage/ourservices.dart';
import 'package:websidefadii/HomePage/ourwork.dart';
import 'package:websidefadii/HomePage/teamsection.dart';
import 'package:websidefadii/HomePage/workink.dart';
import 'package:websidefadii/Utils/Constant/footer.dart';
import 'package:websidefadii/Utils/background.dart';
import 'package:websidefadii/Utils/resumesection.dart';
import 'package:websidefadii/Utils/skill_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  late final ScrollController _scrollController;
  late final Timer _sliderTimer;

  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 1);
    _scrollController = ScrollController()..addListener(_scrollListener);

    // Automatically advances the home-page slider.
    _sliderTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_pageController.hasClients) return;

      final currentPage = _pageController.page?.round() ?? 0;

      // The original slider logic contains four pages (0–3).
      if (currentPage >= 3) {
        _pageController.jumpToPage(0);
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final shouldShowBackground = _scrollController.offset > 50;
    if (shouldShowBackground != _isScrolled && mounted) {
      setState(() => _isScrolled = shouldShowBackground);
    }
  }

  @override
  void dispose() {
    _sliderTimer.cancel();
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 850;
    final horizontalPadding = screenWidth < 600 ? 16.0 : 50.0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            _isScrolled ? Colors.black.withOpacity(0.92) : Colors.transparent,
        elevation: 0,
        title: const Text(
          'FADIITECH',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        actions: isCompact
            ? [
                PopupMenuButton<String>(
                  tooltip: 'Open navigation menu',
                  icon: const Icon(Icons.menu, color: Colors.white),
                  color: const Color(0xFF20242B),
                  onSelected: (value) => _handleNavigation(value),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'Home', child: Text('Home')),
                    PopupMenuItem(value: 'Profile', child: Text('Profile')),
                    PopupMenuItem(value: 'My Resume', child: Text('My Resume')),
                    PopupMenuItem(value: 'Game', child: Text('Game')),
                    PopupMenuItem(value: 'About', child: Text('About')),
                    PopupMenuItem(value: 'Contact', child: Text('Contact')),
                    PopupMenuItem(value: 'Login', child: Text('Login')),
                  ],
                ),
                const SizedBox(width: 8),
              ]
            : [
                _buildNavButton('Home', () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }),
                _buildNavButton(
                  'Profile',
                  () => _showProfileUsSection(context),
                ),
                _buildNavButton('My Resume', _openResume),
                _buildNavButton('Game', _openGame),
                _buildNavButton(
                  'About',
                  () => _showAboutUsSection(context),
                ),
                _buildNavButton(
                  'Contact',
                  () => _showContactUsSection(context),
                ),
                _buildNavButton('Login', _openLogin),
                const SizedBox(width: 12),
              ],
      ),
      body: Stack(
        children: [
          Positioned.fill(child: BackgroundWidget()),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SliderSection(pageController: _pageController),
                // const SkillsSection(),
                // const SizedBox(height: 20),
                LatestWorksSection(),
                const SizedBox(height: 20),
                OurServices(),

                InfoWithImageSection(),
                const SizedBox(height: 20),
                TeamSection(),
                const SizedBox(height: 20),
                FooterSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(
    String title, {
    required Color textColor,
    Color backgroundColor = Colors.transparent,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 90),
      color: backgroundColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: MediaQuery.sizeOf(context).width < 600 ? 26 : 35,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildNavButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          minimumSize: const Size(0, 40),
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blueAccent, width: 2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNavigation(String value) {
    switch (value) {
      case 'Home':
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        break;
      case 'Profile':
        _showProfileUsSection(context);
        break;
      case 'My Resume':
        _openResume();
        break;
      case 'Game':
        _openGame();
        break;
      case 'About':
        _showAboutUsSection(context);
        break;
      case 'Contact':
        _showContactUsSection(context);
        break;
      case 'Login':
        _openLogin();
        break;
    }
  }

  void _openResume() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResumePage()),
    );
  }

  void _openGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TicTacToePage()),
    );
  }

  void _openLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  void _showAboutUsSection(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('About Us'),
          content: const SingleChildScrollView(
            child: Text(
              'Welcome to FADIITECH, where innovation meets creativity. '
              'Our mission is to provide top-notch software development '
              'services to empower businesses worldwide. With a passion '
              'for technology and a dedication to excellence, we specialize '
              'in delivering customized solutions tailored to your unique needs.',
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showProfileUsSection(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;

    final confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        // Start the confetti only after the dialog has been laid out.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          confettiController.play();
        });

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 440,
              maxHeight: screenSize.height * 0.82,
            ),
            child: SizedBox(
              width: screenWidth < 480 ? screenWidth - 40 : 440,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  width: screenWidth < 400 ? 80 : 100,
                                  height: screenWidth < 400 ? 80 : 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.yellow.withOpacity(0.65),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                    image: const DecorationImage(
                                      image: AssetImage('assets/probg.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Muhammad Fahad',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth < 400 ? 16 : 18,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildContactBubble(
                                  icon: Icons.phone,
                                  label: 'Phone',
                                  value: '+923018920989',
                                  color: Colors.green,
                                  fontSize: screenWidth < 400 ? 14 : 16,
                                  onTap: () =>
                                      _launchWhatsApp('+923018920989'),
                                ),
                                const SizedBox(height: 10),
                                _buildContactBubble(
                                  icon: Icons.email,
                                  label: 'Email',
                                  value: 'fa8579364@gmail.com',
                                  color: Colors.blue,
                                  fontSize: screenWidth < 400 ? 14 : 16,
                                  onTap: () =>
                                      _launchEmail('fa8579364@gmail.com'),
                                ),
                                const SizedBox(height: 10),
                                _buildContactBubble(
                                  icon: Icons.location_on,
                                  label: 'Address',
                                  value:
                                      'Mian G Plaza Naguman, Peshawar, Pakistan',
                                  color: Colors.red,
                                  fontSize: screenWidth < 400 ? 14 : 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext),
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // The confetti is painted above the dialog content but
                  // ignores pointer events, so the buttons remain clickable.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ConfettiWidget(
                        confettiController: confettiController,
                        blastDirectionality:
                            BlastDirectionality.explosive,
                        shouldLoop: false,
                        colors: const [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                          Colors.yellow,
                          Colors.purple,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(confettiController.dispose);
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final uri = Uri.parse('https://wa.me/${phoneNumber.replaceAll('+', '')}');
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp.')),
      );
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    final launched = await launchUrl(uri);

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open your email app.')),
      );
    }
  }

  Widget _buildContactBubble({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required double fontSize,
    VoidCallback? onTap,
  }) {
    return Material(
      color: color.withOpacity(0.13),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 15,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black87,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.open_in_new, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactUsSection(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 440,
              maxHeight: 520,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildContactBubble(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: '+92301-8920-989',
                    color: Colors.green,
                    fontSize: screenWidth < 400 ? 14 : 16,
                    onTap: () => _launchWhatsApp('+923018920989'),
                  ),
                  const SizedBox(height: 10),
                  _buildContactBubble(
                    icon: Icons.email,
                    label: 'Email',
                    value: 'fa8579364@gmail.com',
                    color: Colors.blue,
                    fontSize: screenWidth < 400 ? 14 : 16,
                    onTap: () => _launchEmail('fa8579364@gmail.com'),
                  ),
                  const SizedBox(height: 10),
                  _buildContactBubble(
                    icon: Icons.location_on,
                    label: 'Address',
                    value: 'Mian G Plaza Naguman, Peshawar, Pakistan',
                    color: Colors.red,
                    fontSize: screenWidth < 400 ? 14 : 16,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
