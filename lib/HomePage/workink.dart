import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class InfoWithImageSection extends StatefulWidget {
  const InfoWithImageSection({super.key});

  @override
  _InfoWithImageSectionState createState() => _InfoWithImageSectionState();
}

class _InfoWithImageSectionState extends State<InfoWithImageSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _opacityAnimation2;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> _offsetAnimation2;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _offsetAnimation =
        Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _offsetAnimation2 =
        Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    debugPrint(
        'Visibility: ${info.visibleFraction}'); // Debug visibility status

    if (info.visibleFraction > 0.3 && !_isAnimating) {
      _isAnimating = true;
      _controller.reset();
      _controller.forward();
    } else if (info.visibleFraction == 0.0) {
      _isAnimating = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('InfoWithImageSection'),
      onVisibilityChanged: _onVisibilityChanged,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Container(
            width: double.infinity, // Ensure full width
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: isMobile
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAnimatedImage(),
                      const SizedBox(height: 20),
                      _buildAnimatedTextSection(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 3, child: _buildAnimatedTextSection()),
                      const SizedBox(width: 10),
                      Expanded(flex: 3, child: _buildAnimatedImage()),
                    ],
                  ),
          );
        },
      ),
    );
  }

  /// ✅ Animated Image Section
  Widget _buildAnimatedImage() {
    return SlideTransition(
      position: _offsetAnimation2, // Right to Left Animation
      child: FadeTransition(
        opacity: _opacityAnimation2,
        child: _buildImage(),
      ),
    );
  }

  /// ✅ Animated Text Section
  Widget _buildAnimatedTextSection() {
    return SlideTransition(
      position: _offsetAnimation, // Left to Right Animation
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: _buildTextSection(),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      height: 370,
      width: double.infinity, // Ensure proper sizing
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          'assets/imsof.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTextSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16.0,
        runSpacing: 16.0,
        children: List.generate(4, (index) => _buildInfoBox(index)),
      ),
    );
  }

  Widget _buildInfoBox(int index) {
    final icons = [
      Icons.high_quality,
      Icons.timelapse,
      Icons.web_sharp,
      Icons.security
    ];
    final titles = [
      'Quality Products',
      'Timely Work',
      'Reliability',
      'Maintainable'
    ];
    final descriptions = [
      'We believe in Software Quality that is essential to deliver the product on time and on the required quality.',
      'We always plan the Project Development schedule for deploying the Project on time with all completed requirements.',
      'Failure Free Products are our main target. We always develop the most reliable products without any failure issues in the future.',
      'Our Products are fully maintainable for the injection of any new functionality or requirement.',
    ];

    return Container(
      width: 290,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icons[index], color: Colors.white, size: 20),
          const SizedBox(height: 20),
          Text(
            titles[index],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            descriptions[index],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
