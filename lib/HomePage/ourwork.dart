import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:websidefadii/HomePage/projectdetails.dart';

// ─────────────────────────────────────────────────────────────
//  COLORS (change these to restyle the whole section)
// ─────────────────────────────────────────────────────────────
const Color _bgTop = Color(0xFF0A0A12);
const Color _bgBottom = Color(0xFF1C0A14);
const Color _accent = Color(0xFFE53935);
const Color _accentDark = Color.fromARGB(255, 147, 0, 0);

/// Position of a tile inside the bento grid.
class _Cell {
  final int col, row, colSpan, rowSpan;

  const _Cell(this.col, this.row, this.colSpan, this.rowSpan);
}

/// Builds the bento layout for [n] projects on a grid with [cols] columns.
List<_Cell> _layoutCells(int cols, int n) {
  final cells = <_Cell>[];

  if (cols == 4) {
    // First 8 projects form a "bento" pattern, extras flow in rows of 4.
    const pattern = [
      _Cell(0, 0, 2, 2), // big feature tile
      _Cell(2, 0, 1, 1),
      _Cell(3, 0, 1, 1),
      _Cell(2, 1, 2, 1), // wide tile
      _Cell(0, 2, 1, 1),
      _Cell(1, 2, 1, 1),
      _Cell(2, 2, 1, 1),
      _Cell(3, 2, 1, 1),
    ];
    for (int i = 0; i < n; i++) {
      if (i < pattern.length) {
        cells.add(pattern[i]);
      } else {
        final idx = i - pattern.length;
        cells.add(_Cell(idx % 4, 3 + idx ~/ 4, 1, 1));
      }
    }
  } else if (cols == 2) {
    for (int i = 0; i < n; i++) {
      if (i == 0) {
        cells.add(const _Cell(0, 0, 2, 1));
      } else {
        final idx = i - 1;
        cells.add(_Cell(idx % 2, 1 + idx ~/ 2, 1, 1));
      }
    }
  } else {
    for (int i = 0; i < n; i++) {
      cells.add(_Cell(0, i, 1, 1));
    }
  }
  return cells;
}

class LatestWorksSection extends StatefulWidget {
  const LatestWorksSection({super.key});

  @override
  State<LatestWorksSection> createState() => _LatestWorksSectionState();
}

class _LatestWorksSectionState extends State<LatestWorksSection>
    with SingleTickerProviderStateMixin {
  // Created at declaration so it is always initialized before build.
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  final List<Project> projects = [
    Project('Sports App', 'assets/sports.png', '/sportsDetails'),
    Project('Chat App', 'assets/chatapp.png', '/chatAppDetails'),
    Project('E-commerce App', 'assets/ecomer.png', '/ecommerceDetails'),
    Project('Todo App', 'assets/todoapp.png', '/todoAppDetails'),
    Project('Music App', 'assets/musicapp.jpg', '/musicAppDetails'),
    Project('Food Delivery App', 'assets/foodr.png', '/foodDeliveryDetails'),
    Project('Portfolio', 'assets/portfolio.jpeg', '/portfolioDetails'),
    Project('Gym App', 'assets/gym.png', '/gymAppDetails'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
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
    double dy = 60,
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
            offset: Offset(0, dy * (1 - v)),
            child: Transform.scale(
              scale: fromScale + (1 - fromScale) * v,
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hPad = screenWidth >= 1000 ? 48.0 : 16.0;

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
            const Positioned.fill(child: _SectionBackground()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 64),
              child: Column(
                children: [
                  _reveal(
                    begin: 0.0,
                    end: 0.3,
                    dy: 30,
                    child: _Header(count: projects.length),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1300),
                      child: LayoutBuilder(builder: (context, c) {
                        final w = c.maxWidth;
                        final cols = w >= 1000 ? 4 : (w >= 600 ? 2 : 1);
                        const gap = 18.0;
                        final cellW = (w - gap * (cols - 1)) / cols;
                        final cellH = cols == 4
                            ? cellW * 0.85
                            : cols == 2
                                ? cellW * 0.7
                                : math.min(cellW * 0.7, 320.0);

                        final cells = _layoutCells(cols, projects.length);
                        final rows =
                            cells.map((e) => e.row + e.rowSpan).reduce(math.max);
                        final totalH = rows * cellH + (rows - 1) * gap;

                        return SizedBox(
                          height: totalH,
                          child: Stack(
                            children: [
                              for (int i = 0; i < projects.length; i++)
                                Positioned(
                                  left: cells[i].col * (cellW + gap),
                                  top: cells[i].row * (cellH + gap),
                                  width: cells[i].colSpan * cellW +
                                      (cells[i].colSpan - 1) * gap,
                                  height: cells[i].rowSpan * cellH +
                                      (cells[i].rowSpan - 1) * gap,
                                  child: _reveal(
                                    begin: 0.1 + i * 0.08,
                                    end: 0.1 + i * 0.08 + 0.35,
                                    fromScale: 0.94,
                                    child: ProjectTile(
                                      project: projects[i],
                                      index: i,
                                      large: cells[i].colSpan * cells[i].rowSpan >
                                          1,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
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
}

// ═════════════════════════════════════════════════════════════
//  Header
// ═════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final int count;

  const _Header({required this.count});

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$count PROJECTS',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [Colors.white, Color(0xFFFFB4B0)],
          ).createShader(rect),
          child: const Text(
            'Our Latest Works',
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
          'A selection of apps and websites we have designed and built.',
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
            gradient: const LinearGradient(colors: [_accent, _accentDark]),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
//  Background glow blobs + dots
// ═════════════════════════════════════════════════════════════
class _SectionBackground extends StatelessWidget {
  const _SectionBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -120,
          top: -100,
          child: _glow(420, _accent, 0.22),
        ),
        Positioned(
          right: -140,
          bottom: -120,
          child: _glow(480, const Color(0xFF7C3AED), 0.18),
        ),
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

// ═════════════════════════════════════════════════════════════
//  Model
// ═════════════════════════════════════════════════════════════
class Project {
  final String name;
  final String imagePath;
  final String detailsRoute;

  Project(this.name, this.imagePath, this.detailsRoute);
}

// ═════════════════════════════════════════════════════════════
//  Project tile: 3D tilt + spotlight + zoom + reveal button
// ═════════════════════════════════════════════════════════════
class ProjectTile extends StatefulWidget {
  final Project project;
  final int index;
  final bool large;

  const ProjectTile({
    super.key,
    required this.project,
    this.index = 0,
    this.large = false,
  });

  @override
  State<ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile> {
  bool _hover = false;
  double _dx = 0; // pointer position in [-1, 1]
  double _dy = 0;

  void _open() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailsPage(project: widget.project),
      ),
    );
  }

  void _onHover(PointerHoverEvent e) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final s = box.size;
    setState(() {
      _dx = (e.localPosition.dx / s.width * 2 - 1).clamp(-1.0, 1.0);
      _dy = (e.localPosition.dy / s.height * 2 - 1).clamp(-1.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    const radius = 24.0;
    const fast = Duration(milliseconds: 160);
    const normal = Duration(milliseconds: 350);
    final number = (widget.index + 1).toString().padLeft(2, '0');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _dx = 0;
        _dy = 0;
      }),
      onHover: _onHover,
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: fast,
          curve: Curves.easeOut,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateX(-_dy * 0.07)
            ..rotateY(_dx * 0.07)
            ..scale(_hover ? 1.025 : 1.0, _hover ? 1.025 : 1.0, 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: (_hover ? _accent : Colors.black)
                    .withValues(alpha: _hover ? 0.4 : 0.35),
                blurRadius: _hover ? 40 : 20,
                offset: Offset(0, _hover ? 22 : 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // image (zooms on hover)
                AnimatedScale(
                  scale: _hover ? 1.12 : 1.0,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    widget.project.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF1F2937),
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: Colors.white54, size: 40),
                    ),
                  ),
                ),

                // readable gradient
                AnimatedContainer(
                  duration: normal,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: _hover ? 0.55 : 0.2),
                        Colors.black.withValues(alpha: _hover ? 0.95 : 0.85),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),

                // spotlight following the mouse
                IgnorePointer(
                  child: AnimatedOpacity(
                    duration: normal,
                    opacity: _hover ? 1 : 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(_dx, _dy),
                          radius: 0.9,
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // glowing border
                IgnorePointer(
                  child: AnimatedContainer(
                    duration: normal,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                        color: _hover
                            ? _accent
                            : Colors.white.withValues(alpha: 0.1),
                        width: _hover ? 2 : 1,
                      ),
                    ),
                  ),
                ),

                // number chip
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    child: Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                // arrow badge (turns red on hover)
                Positioned(
                  top: 14,
                  right: 14,
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

                // title + button
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: widget.large ? 30 : 19,
                          height: 1.15,
                        ),
                      ),
                      AnimatedContainer(
                        duration: normal,
                        margin: const EdgeInsets.only(top: 8),
                        height: 3,
                        width: _hover ? 64 : 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [_accent, _accentDark]),
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
                                      offset: Offset(0, 12 * (1 - v)),
                                      child: child,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          colors: [_accent, _accentDark]),
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              _accent.withValues(alpha: 0.5),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'View Details',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(Icons.arrow_forward_rounded,
                                            color: Colors.white, size: 16),
                                      ],
                                    ),
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