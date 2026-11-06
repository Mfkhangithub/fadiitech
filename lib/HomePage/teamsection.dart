import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────────────────────
//  COLORS (change these to restyle the whole section)
// ─────────────────────────────────────────────────────────────
const Color _bgTop = Color(0xFF0A0A12);
const Color _bgBottom = Color(0xFF14091C);
const Color _accent = Color(0xFFE53935);
const Color _accentDark = Color.fromARGB(255, 147, 0, 0);
const Color _purple = Color(0xFF7C3AED);

class _Member {
  final String name;
  final String role;
  final String image;
  final String email;
  final String experience;
  final String linkedin;
  final String github;

  const _Member({
    required this.name,
    required this.role,
    required this.image,
    required this.email,
    required this.experience,
    required this.linkedin,
    required this.github,
  });
}

/// Edit your team here.
const _team = <_Member>[
  _Member(
    name: 'Muhammad Fahad',
    role: 'Flutter Developer',
    image: 'assets/pro.jpeg',
    email: 'fahad@example.com',
    experience: '2 years of experience in Flutter development',
    linkedin: 'https://linkedin.com/in/muhammad-fahad',
    github: 'https://github.com/muhammad-fahad',
  ),
  _Member(
    name: 'Muhammad Faizan',
    role: 'Flutter Expert',
    image: 'assets/faizan.jpeg',
    email: 'faizan@example.com',
    experience: '2 years of experience in Flutter and Dart',
    linkedin: 'https://linkedin.com/in/muhammad-faizan',
    github: 'https://github.com/muhammad-faizan',
  ),
  _Member(
    name: 'Muhammad Hamza',
    role: 'Flutter Developer',
    image: 'assets/hamza.png',
    email: 'hamza@example.com',
    experience: '2 years of experience in Flutter development',
    linkedin: 'https://linkedin.com/in/muhammad-hamza',
    github: 'https://github.com/muhammad-hamza',
  ),
];

class TeamSection extends StatefulWidget {
  const TeamSection({super.key});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection>
    with SingleTickerProviderStateMixin {
  // Created at declaration so it is always initialized before build.
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
          child:
              Transform.translate(offset: Offset(0, dy * (1 - v)), child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 40).clamp(240.0, 310.0);

    return ClipRect(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _Background()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 64),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _reveal(
                    begin: 0.0,
                    end: 0.35,
                    dy: 30,
                    child: const _Header(),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 28,
                    runSpacing: 28,
                    children: [
                      for (int i = 0; i < _team.length; i++)
                        _reveal(
                          begin: 0.2 + i * 0.15,
                          end: 0.2 + i * 0.15 + 0.5,
                          child: _TeamCard(
                            member: _team[i],
                            width: cardWidth,
                            onTap: () => _showMemberDetails(_team[i]),
                            onEmail: () =>
                                _open(Uri.parse('mailto:${_team[i].email}')),
                            onLinkedIn: () =>
                                _open(Uri.parse(_team[i].linkedin)),
                            onGithub: () => _open(Uri.parse(_team[i].github)),
                          ),
                        ),
                    ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        content: const Text('Sorry, could not open that link.'),
      ),
    );
  }

  // ───────────── details dialog ─────────────

  void _showMemberDetails(_Member m) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 320),
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
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1B1030), Color(0xFF0E0A1A)],
                    ),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.12)),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withValues(alpha: 0.25),
                        blurRadius: 50,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // avatar with gradient ring
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        colors: [_accent, _purple]),
                                  ),
                                  child: CircleAvatar(
                                    radius: 56,
                                    backgroundColor: _bgTop,
                                    backgroundImage: AssetImage(m.image),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  m.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _RolePill(text: m.role),
                                const SizedBox(height: 24),
                                _InfoRow(
                                  icon: Icons.mail_rounded,
                                  label: 'Email',
                                  value: m.email,
                                ),
                                const SizedBox(height: 12),
                                _InfoRow(
                                  icon: Icons.workspace_premium_rounded,
                                  label: 'Experience',
                                  value: m.experience,
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _DialogButton(
                                        icon: Icons.link_rounded,
                                        label: 'LinkedIn',
                                        filled: true,
                                        onTap: () => _open(Uri.parse(m.linkedin)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _DialogButton(
                                        icon: Icons.code_rounded,
                                        label: 'GitHub',
                                        filled: false,
                                        onTap: () => _open(Uri.parse(m.github)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.white70),
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
}

// ═════════════════════════════════════════════════════════════
//  Header
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
            color: _accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _accent.withValues(alpha: 0.5)),
          ),
          child: const Text(
            'MEET THE TEAM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [Colors.white, Color(0xFFD8B4FE)],
          ).createShader(rect),
          child: const Text(
            'Our Team',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'The talented people who turn your ideas into real products.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_accent, _purple]),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  Team card
// ═════════════════════════════════════════════════════════════
class _TeamCard extends StatefulWidget {
  final _Member member;
  final double width;
  final VoidCallback onTap;
  final VoidCallback onEmail;
  final VoidCallback onLinkedIn;
  final VoidCallback onGithub;

  const _TeamCard({
    required this.member,
    required this.width,
    required this.onTap,
    required this.onEmail,
    required this.onLinkedIn,
    required this.onGithub,
  });

  @override
  State<_TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<_TeamCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.member;
    const normal = Duration(milliseconds: 350);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: normal,
          curve: Curves.easeOutCubic,
          width: widget.width,
          height: 400,
          transform: Matrix4.translationValues(0, _hover ? -12 : 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: (_hover ? _accent : Colors.black)
                    .withValues(alpha: _hover ? 0.4 : 0.35),
                blurRadius: _hover ? 44 : 22,
                offset: Offset(0, _hover ? 24 : 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // photo
                AnimatedScale(
                  scale: _hover ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    m.image,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [_purple, _accent]),
                      ),
                      child: const Icon(Icons.person_rounded,
                          size: 110, color: Colors.white),
                    ),
                  ),
                ),

                // gradient for readability
                AnimatedContainer(
                  duration: normal,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: _hover ? 0.55 : 0.25),
                        Colors.black.withValues(alpha: _hover ? 0.95 : 0.88),
                      ],
                      stops: const [0.35, 0.65, 1.0],
                    ),
                  ),
                ),

                // glowing border
                IgnorePointer(
                  child: AnimatedContainer(
                    duration: normal,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: _hover
                            ? _accent
                            : Colors.white.withValues(alpha: 0.12),
                        width: _hover ? 2 : 1,
                      ),
                    ),
                  ),
                ),

                // "view profile" badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: AnimatedContainer(
                    duration: normal,
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _hover
                          ? _accent
                          : Colors.white.withValues(alpha: 0.14),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    child: AnimatedRotation(
                      duration: normal,
                      turns: _hover ? 0 : -0.125,
                      child: const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),

                // info
                Positioned(
                  left: 22,
                  right: 22,
                  bottom: 22,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RolePill(text: m.role),
                      const SizedBox(height: 10),
                      Text(
                        m.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      AnimatedContainer(
                        duration: normal,
                        margin: const EdgeInsets.only(top: 8),
                        height: 3,
                        width: _hover ? 70 : 26,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [_accent, _purple]),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      AnimatedSize(
                        duration: normal,
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.topLeft,
                        child: _hover
                            ? Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: 1),
                                  duration: normal,
                                  curve: Curves.easeOut,
                                  builder: (context, v, child) => Opacity(
                                    opacity: v,
                                    child: Transform.translate(
                                      offset: Offset(0, 14 * (1 - v)),
                                      child: child,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.experience,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.8),
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          _SocialButton(
                                            icon: Icons.link_rounded,
                                            tooltip: 'LinkedIn',
                                            onTap: widget.onLinkedIn,
                                          ),
                                          const SizedBox(width: 10),
                                          _SocialButton(
                                            icon: Icons.code_rounded,
                                            tooltip: 'GitHub',
                                            onTap: widget.onGithub,
                                          ),
                                          const SizedBox(width: 10),
                                          _SocialButton(
                                            icon: Icons.mail_rounded,
                                            tooltip: 'Email',
                                            onTap: widget.onEmail,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(width: double.infinity),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  Small reusable widgets
// ═════════════════════════════════════════════════════════════
class _RolePill extends StatelessWidget {
  final String text;

  const _RolePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _accent.withValues(alpha: 0.9),
            _purple.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            transform: Matrix4.identity()
              ..scale(_hover ? 1.12 : 1.0, _hover ? 1.12 : 1.0, 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hover ? _accent : Colors.white.withValues(alpha: 0.14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Icon(widget.icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [_accent, _purple]),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _DialogButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
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
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: widget.filled
                ? const LinearGradient(colors: [_accent, _accentDark])
                : null,
            color: widget.filled
                ? null
                : Colors.white.withValues(alpha: _hover ? 0.14 : 0.06),
            border: widget.filled
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.3)),
            boxShadow: widget.filled
                ? [
                    BoxShadow(
                      color: _accent.withValues(alpha: _hover ? 0.55 : 0.3),
                      blurRadius: _hover ? 22 : 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
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
//  Background glow + dots
// ═════════════════════════════════════════════════════════════
class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(right: -120, top: -100, child: _glow(420, _purple, 0.22)),
        Positioned(left: -140, bottom: -120, child: _glow(480, _accent, 0.18)),
        Positioned.fill(child: CustomPaint(painter: _DotsPainter())),
      ],
    );
  }

  Widget _glow(double size, Color color, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: alpha), color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.05);
    const gap = 36.0;
    for (double x = gap / 2; x < size.width; x += gap) {
      for (double y = gap / 2; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}