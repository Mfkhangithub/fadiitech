import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // WhatsApp, calls & email

// ─────────────────────────────────────────────────────────────
//  EDIT THESE VALUES
// ─────────────────────────────────────────────────────────────
const String _whatsappNumber = '923018920989'; // without + or spaces
const String _phoneNumber = '+923018920989';
const String _email = 'fa8579364@gmail.com';
const String _yourName = '[Your Name]';

const Color _accent = Color(0xFFD32F2F);
const Color _accentDark = Color(0xFF8E0000);
const Color _ink = Color(0xFF1F2937);

class _Service {
  final String title;
  final List<String> points;
  final String image;
  final bool featured;

  const _Service({
    required this.title,
    required this.points,
    required this.image,
    this.featured = false,
  });
}

const _services = <_Service>[
  _Service(
    title: 'Order Now',
    featured: true,
    points: [
      'Deliver Quality Work on Time',
      'Multiple CV Order 50% discount',
      '24/7 Support',
    ],
    image: 'assets/myservices.png',
  ),
  _Service(
    title: 'Mobile Application Development',
    points: [
      'Professional mobile application development services',
      'User-friendly, feature-rich, and high-performance apps',
      'Expertise in Android, iOS, and cross-platform applications',
      'Seamless functionality and engaging designs',
      'End-to-end development services from concept to deployment',
    ],
    image: 'assets/flutterapp.png',
  ),
  _Service(
    title: 'Website to Mobile App',
    points: [
      'Convert your website into a mobile application',
      'Optimize for performance and user experience',
      'Support for e-commerce, informational, and custom solutions',
      'Seamless transition to mobile platforms',
      'Expand your digital presence across devices',
    ],
    image: 'assets/webtoapp.png',
  ),
];

class OurServices extends StatefulWidget {
  const OurServices({super.key});

  @override
  State<OurServices> createState() => _OurServicesState();
}

class _OurServicesState extends State<OurServices>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _entrance.forward();
      });
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Widget _reveal({
    required double begin,
    required double end,
    required Widget child,
    double dy = 50,
  }) {
    return AnimatedBuilder(
      animation: _entrance,
      child: child,
      builder: (context, child) {
        final raw = ((_entrance.value - begin) / (end - begin)).clamp(0.0, 1.0);
        final v = Curves.easeOutCubic.transform(raw);
        return Opacity(
          opacity: v,
          child: Transform.translate(offset: Offset(0, dy * (1 - v)), child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 1000;

    Widget card(int i) => _reveal(
          begin: 0.2 + i * 0.15,
          end: 0.2 + i * 0.15 + 0.5,
          child: _ServiceCard(
            service: _services[i],
            index: i,
            onImageTap: () => _showFullImage(context, _services[i].image),
            onContact: () => _showContactOptions(context, _services[i].title),
          ),
        );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 48 : 16,
        vertical: 40,
      ),
      child: Column(
        children: [
          _reveal(begin: 0.0, end: 0.4, dy: 30, child: const _Header()),
          const SizedBox(height: 40),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: isWide
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < _services.length; i++) ...[
                            Expanded(child: card(i)),
                            if (i != _services.length - 1)
                              const SizedBox(width: 24),
                          ],
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < _services.length; i++) ...[
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 560),
                            child: card(i),
                          ),
                          if (i != _services.length - 1)
                            const SizedBox(height: 24),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────── contact dialog ─────────────

  void _showContactOptions(BuildContext context, String serviceTitle) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, __) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween(begin: 0.85, end: 1.0).animate(curved),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 420,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_accentDark, _accent],
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Contact Options',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      serviceTitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.85),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(ctx),
                                icon: const Icon(Icons.close_rounded,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _ContactTile(
                                icon: Icons.chat_rounded,
                                color: const Color(0xFF25D366),
                                title: 'WhatsApp',
                                subtitle: 'Chat with us on WhatsApp',
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _open(Uri.parse(
                                      'https://wa.me/$_whatsappNumber'));
                                },
                              ),
                              const SizedBox(height: 10),
                              _ContactTile(
                                icon: Icons.call_rounded,
                                color: const Color(0xFF2563EB),
                                title: 'Call Us',
                                subtitle: 'Call us directly',
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _open(Uri.parse('tel:$_phoneNumber'));
                                },
                              ),
                              const SizedBox(height: 10),
                              _ContactTile(
                                icon: Icons.shopping_cart_rounded,
                                color: const Color(0xFFF59E0B),
                                title: 'Place Order',
                                subtitle: 'Order now and get started',
                                onTap: () {
                                  Navigator.pop(ctx);
                                  _sendEmail(serviceTitle);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ───────────── actions ─────────────

  Future<void> _open(Uri uri) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) _showError();
    } catch (_) {
      _showError();
    }
  }

  void _showError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _accentDark,
        content: const Text('Sorry, could not open that. Please try again.'),
      ),
    );
  }

  void _sendEmail(String serviceTitle) {
    final subject = Uri.encodeComponent('Order for $serviceTitle');
    final body = Uri.encodeComponent('Hello,\n\n'
        'I would like to place an order for $serviceTitle.\n\n'
        'Please provide more details on the process and pricing.\n\n'
        'Looking forward to your response.\n\n'
        'Best regards,\n'
        '$_yourName');
    _open(Uri.parse('mailto:$_email?subject=$subject&body=$body'));
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.8,
                maxScale: 4.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  Section header
// ═════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _accent.withValues(alpha: 0.4)),
          ),
          child: const Text(
            'WHAT WE OFFER',
            style: TextStyle(
              color: _accent,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Our Services',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 70,
          height: 4,
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  Service card
// ═════════════════════════════════════════════════════════════
class _ServiceCard extends StatefulWidget {
  final _Service service;
  final int index;
  final VoidCallback onImageTap;
  final VoidCallback onContact;

  const _ServiceCard({
    required this.service,
    required this.index,
    required this.onImageTap,
    required this.onContact,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    const duration = Duration(milliseconds: 300);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hover ? -10 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: s.featured || _hover ? _accent : Colors.grey.shade200,
            width: s.featured ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (_hover || s.featured ? _accent : Colors.black)
                  .withValues(alpha: _hover ? 0.28 : 0.1),
              blurRadius: _hover ? 32 : 18,
              offset: Offset(0, _hover ? 18 : 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── image ──
              GestureDetector(
                onTap: widget.onImageTap,
                child: MouseRegion(
                  cursor: SystemMouseCursors.zoomIn,
                  child: SizedBox(
                    height: 210,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedScale(
                          scale: _hover ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          child: Image.asset(
                            s.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_outlined, size: 40),
                            ),
                          ),
                        ),
                        // bottom fade
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.45),
                              ],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                        // number badge
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: s.featured ? _accent : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              s.featured
                                  ? 'SPECIAL OFFER'
                                  : '0${widget.index + 1}',
                              style: TextStyle(
                                color: s.featured ? Colors.white : _accent,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        // zoom hint
                        Positioned(
                          right: 14,
                          bottom: 14,
                          child: AnimatedOpacity(
                            duration: duration,
                            opacity: _hover ? 1 : 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.zoom_in_rounded,
                                  size: 20, color: _ink),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── content ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: duration,
                        height: 3,
                        width: _hover ? 64 : 28,
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final p in s.points)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: _accent.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded,
                                    size: 14, color: _accent),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  p,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    height: 1.45,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      const SizedBox(height: 8),
                      _ContactButton(onTap: widget.onContact),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  "Contact Us" button
// ═════════════════════════════════════════════════════════════
class _ContactButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ContactButton({required this.onTap});

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: _hover
                  ? const [_accent, _accentDark]
                  : const [_accentDark, _accent],
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: _hover ? 0.5 : 0.25),
                blurRadius: _hover ? 22 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Contact Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: Offset(_hover ? 0.35 : 0, 0),
                child: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  Row inside the contact dialog
// ═════════════════════════════════════════════════════════════
class _ContactTile extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<_ContactTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _hover
                ? widget.color.withValues(alpha: 0.1)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hover
                  ? widget.color.withValues(alpha: 0.6)
                  : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.icon, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}