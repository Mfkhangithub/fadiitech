import 'dart:math' as math;

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  EDIT THESE VALUES TO MAKE IT YOURS
// ─────────────────────────────────────────────────────────────
const String _greeting = "Hello, I'm";
const String _myName = 'Mr. Muhammad Fahad';
const String _myTitle = 'SOFTWARE ENGINEER';
const String _myImage = 'assets/probg.png'; // <- put your photo here

const Color _bgDark = Color(0xFF070B1A);
const List<Color> _bgGradient = [
  Color(0xFF070B1A),
  Color(0xFF16124A),
  Color(0xFF2A1B6E),
];
const Color _accent = Color(0xFF22D3EE); // cyan
const Color _accent2 = Color(0xFFA78BFA); // purple

class _Skill {
  final IconData icon;
  final String title;
  final String subtitle;

  const _Skill(this.icon, this.title, this.subtitle);
}

/// Shown on the LEFT side of your photo.
const _leftSkills = <_Skill>[
  _Skill(Icons.phone_iphone_rounded, 'Mobile App Developer',
      'Android & iOS apps with Flutter'),
  _Skill(Icons.flutter_dash_rounded, 'Flutter Specialist',
      'Smooth, pixel-perfect cross-platform UI'),
  _Skill(Icons.brush_rounded, 'UI / UX Design',
      'Clean, modern and user-friendly design'),
];

/// Shown on the RIGHT side of your photo.
const _rightSkills = <_Skill>[
  _Skill(Icons.language_rounded, 'Website Developer',
      'Responsive, fast and beautiful websites'),
  _Skill(Icons.developer_mode_rounded, 'Software Developer',
      'Custom solutions for real business problems'),
  _Skill(Icons.cloud_done_rounded, 'Backend & APIs',
      'Firebase, REST APIs and cloud integration'),
];

class SliderSection extends StatefulWidget {
  /// Kept (optional) so your existing code
  /// `SliderSection(pageController: ...)` still compiles.
  final PageController? pageController;

  const SliderSection({super.key, this.pageController});

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection>
    with TickerProviderStateMixin {
  // One-time entrance animation
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  // Endless ambient animation (floating, glowing ring, blobs)
  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entrance.forward();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _ambient.dispose();
    super.dispose();
  }

  // ───────────── helpers ─────────────

  /// Fade + slide in, using a window [begin, end] of the entrance animation.
  Widget _reveal({
    required double begin,
    required double end,
    required Widget child,
    Offset offset = Offset.zero,
    double fromScale = 1.0,
  }) {
    return AnimatedBuilder(
      animation: _entrance,
      child: child,
      builder: (context, child) {
        final raw = ((_entrance.value - begin) / (end - begin)).clamp(0.0, 1.0);
        final v = Curves.easeOutCubic.transform(raw);
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(offset.dx * (1 - v), offset.dy * (1 - v)),
            child: Transform.scale(
              scale: fromScale + (1 - fromScale) * v,
              child: child,
            ),
          ),
        );
      },
    );
  }

  // ───────────── build ─────────────

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 1000;

    return ClipRect(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _bgGradient,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _Background(animation: _ambient)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 48 : 20,
                vertical: isWide ? 56 : 44,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: isWide ? 700 : 0),
                child: isWide ? _wideLayout() : _narrowLayout(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _skillColumn(_leftSkills, fromLeft: true)),
        const SizedBox(width: 24),
        SizedBox(width: 540, child: _center(avatarSize: 420)),
        const SizedBox(width: 24),
        Expanded(child: _skillColumn(_rightSkills, fromLeft: false)),
      ],
    );
  }

  Widget _narrowLayout() {
    final all = [..._leftSkills, ..._rightSkills];
    return Column(
      children: [
        _center(avatarSize: 290),
        const SizedBox(height: 36),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 14,
          runSpacing: 14,
          children: [
            for (int i = 0; i < all.length; i++)
              _reveal(
                begin: 0.4 + (i * 0.07),
                end: 0.4 + (i * 0.07) + 0.4,
                offset: const Offset(0, 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: _SkillCard(skill: all[i], alignEnd: false),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _skillColumn(List<_Skill> skills, {required bool fromLeft}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          fromLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < skills.length; i++) ...[
          _reveal(
            begin: 0.25 + (i * 0.1),
            end: 0.25 + (i * 0.1) + 0.45,
            offset: Offset(fromLeft ? -90 : 90, 0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 310),
              child: _SkillCard(skill: skills[i], alignEnd: fromLeft),
            ),
          ),
          if (i != skills.length - 1) const SizedBox(height: 22),
        ],
      ],
    );
  }

  // ───────────── center: photo + name ─────────────

  Widget _center({required double avatarSize}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _reveal(
          begin: 0.0,
          end: 0.55,
          fromScale: 0.6,
          child: _avatar(avatarSize),
        ),
        const SizedBox(height: 22),
        _reveal(
          begin: 0.35,
          end: 0.8,
          offset: const Offset(0, 30),
          child: Column(
            children: [
              Text(
                _greeting,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  colors: [Colors.white, _accent, _accent2],
                ).createShader(rect),
                child: const Text(
                  _myName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(30),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Text(
                  _myTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _GradientButton(
                    label: 'Hire Me',
                    icon: Icons.arrow_forward_rounded,
                    onTap: () {
                      // TODO: add your navigation here
                    },
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: add your navigation here
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('View Work'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatar(double size) {
    return AnimatedBuilder(
      animation: _ambient,
      builder: (context, _) {
        final v = _ambient.value;
        final floatY = math.sin(v * 2 * math.pi * 4) * 8; // gentle bobbing
        final glow = 0.30 + math.sin(v * 2 * math.pi * 3) * 0.08;

        return Transform.translate(
          offset: Offset(0, floatY),
          child: SizedBox(
            width: size + 50,
            height: size + 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // pulsing glow
                Container(
                  width: size + 20,
                  height: size + 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withValues(alpha: glow),
                        blurRadius: 90,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: _accent2.withValues(alpha: glow * 0.7),
                        blurRadius: 120,
                        spreadRadius: 4,
                        offset: const Offset(20, 20),
                      ),
                    ],
                  ),
                ),
                // rotating gradient ring
                Transform.rotate(
                  angle: v * 2 * math.pi,
                  child: Container(
                    width: size + 26,
                    height: size + 26,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          _accent,
                          _accent2,
                          Colors.transparent,
                          _accent,
                        ],
                        stops: [0.0, 0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                ),
                // dark gap between ring and photo
                Container(
                  width: size + 10,
                  height: size + 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _bgDark,
                  ),
                ),
                // photo
                ClipOval(
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: Image.asset(
                      _myImage,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_accent2, _accent],
                          ),
                        ),
                        child: const Icon(Icons.person_rounded,
                            size: 120, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  Skill card (glass look + hover effect)
// ═════════════════════════════════════════════════════════════
class _SkillCard extends StatefulWidget {
  final _Skill skill;

  /// true  -> text on the left, icon on the right (used on the left column,
  ///          so the icon sits next to the photo)
  final bool alignEnd;

  const _SkillCard({required this.skill, required this.alignEnd});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final iconBox = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: _hover
              ? const [_accent, _accent2]
              : [
                  _accent.withValues(alpha: 0.85),
                  _accent2.withValues(alpha: 0.85),
                ],
        ),
      ),
      child: Icon(widget.skill.icon, color: Colors.white, size: 26),
    );

    final text = Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            widget.alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            widget.skill.title,
            textAlign: widget.alignEnd ? TextAlign.end : TextAlign.start,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.skill.subtitle,
            textAlign: widget.alignEnd ? TextAlign.end : TextAlign.start,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          _hover ? (widget.alignEnd ? 8 : -8) : 0,
          0,
          0,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: _hover ? 0.13 : 0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hover
                ? _accent.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.14),
          ),
          boxShadow: [
            BoxShadow(
              color: _hover
                  ? _accent.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: _hover ? 28 : 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.alignEnd
              ? [text, const SizedBox(width: 14), iconBox]
              : [iconBox, const SizedBox(width: 14), text],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  Gradient call-to-action button
// ═════════════════════════════════════════════════════════════
class _GradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
          transform: Matrix4.identity()..scale(_hover ? 1.06 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(colors: [_accent, _accent2]),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: _hover ? 0.55 : 0.3),
                blurRadius: _hover ? 28 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: _bgDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: Offset(_hover ? 0.3 : 0, 0),
                child: Icon(widget.icon, size: 18, color: _bgDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  Animated background (soft moving color blobs + dot pattern)
// ═════════════════════════════════════════════════════════════
class _Background extends StatelessWidget {
  final Animation<double> animation;

  const _Background({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value * 2 * math.pi;
        return LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;
            return Stack(
              children: [
                _blob(
                  left: w * 0.05 + math.sin(t) * 40,
                  top: h * 0.1 + math.cos(t) * 30,
                  size: 320,
                  color: _accent,
                ),
                _blob(
                  left: w * 0.7 + math.cos(t) * 40,
                  top: h * 0.45 + math.sin(t) * 30,
                  size: 380,
                  color: _accent2,
                ),
                _blob(
                  left: w * 0.4 + math.sin(t * 2) * 30,
                  top: -80 + math.cos(t * 2) * 20,
                  size: 220,
                  color: const Color(0xFFEC4899),
                ),
                Positioned.fill(
                  child: CustomPaint(painter: _DotsPainter()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _blob({
    required double left,
    required double top,
    required double size,
    required Color color,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.22),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.06);
    const gap = 34.0;
    for (double x = gap / 2; x < size.width; x += gap) {
      for (double y = gap / 2; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}