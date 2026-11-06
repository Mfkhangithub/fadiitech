import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websidefadii/Utils/background.dart';

class SliderPage extends StatefulWidget {
  final bool isWelcomePage;
  final String? title;
  final String? description;
  final String? imagePath;

  const SliderPage({
    super.key,
    this.isWelcomePage = false,
    this.title,
    this.description,
    this.imagePath,
  });

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _textAnimation;
  late Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _imageAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const BackgroundWidget(),
          Container(
            color: Colors.transparent,
            child: widget.isWelcomePage
                ? _buildWelcomePageContent(isMobile, screenWidth)
                : _buildContent(isMobile, screenWidth),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: AnimatedProfileIntro(isMobile: isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePageContent(bool isMobile, double screenWidth) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/disp.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedBuilder(
            animation: _textAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _textAnimation.value,
                child: Transform.translate(
                  offset: Offset(-100 * (1 - _textAnimation.value), 0),
                  child: Container(
                    width: isMobile ? screenWidth : screenWidth * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(400.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16.0 : 24.0,
                      vertical: isMobile ? 24.0 : 48.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to Our Company!",
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "We are dedicated to delivering the best solutions tailored to your needs.",
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (!isMobile)
          Positioned(
            right: 30,
            top: 30,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 50,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/probg.png',
                      width: 350,
                      height: 350,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContent(bool isMobile, double screenWidth) {
    return isMobile
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _imageAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _imageAnimation.value,
                    child: Transform.scale(
                      scale: _imageAnimation.value,
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child:
                            Image.asset(widget.imagePath ?? 'assets/soft.png'),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.title ?? "Default Title",
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            widget.description ?? "Default description",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildTextContent()),
              Expanded(child: _buildImageContent()),
            ],
          );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? "Default Title",
            style: const TextStyle(
                fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Text(
            widget.description ?? "Default description",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    return AnimatedBuilder(
      animation: _imageAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _imageAnimation.value,
          child: Transform.scale(
            scale: _imageAnimation.value,
            child: SizedBox(
              height: 400,
              width: 400,
              child: Image.asset(widget.imagePath ?? 'assets/soft.png'),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedProfileIntro extends StatelessWidget {
  final bool isMobile;

  const AnimatedProfileIntro({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
          onPressed: () => _launchUrl("https://wa.me/+923018920989"),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.github, color: Colors.white),
          onPressed: () => _launchUrl("https://github.com/Mfkhangithub"),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
          onPressed: () => _launchUrl(
              "https://web.facebook.com/profile.php?id=100074030765555"),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.youtube, color: Colors.red),
          onPressed: () => _launchUrl("https://www.youtube.com/@fadiiyt3056"),
        ),
        IconButton(
          icon:
              const FaIcon(FontAwesomeIcons.linkedin, color: Colors.blueAccent),
          onPressed: () => _launchUrl(
              "https://www.linkedin.com/in/muhammad-fahad-891642253/"),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
          onPressed: () =>
              _launchUrl("https://www.instagram.com/fahadahmad6698/"),
        ),
      ],
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
