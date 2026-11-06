import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websidefadii/Model/skillsmodel.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  _SkillsSectionState createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  double _opacity = 0.0;

  final List<SkillModel> skillsData = [
    SkillModel(name: 'Dart', icon: FontAwesomeIcons.dartLang, level: 0.95),
    SkillModel(name: 'Flutter', icon: FontAwesomeIcons.flutter, level: 0.90),
    SkillModel(name: 'Html5', icon: FontAwesomeIcons.html5, level: 0.85),
    SkillModel(name: 'CSS3', icon: FontAwesomeIcons.css3, level: 0.80),
    SkillModel(name: 'Firebase', icon: FontAwesomeIcons.google, level: 0.75),
    SkillModel(name: 'Git', icon: FontAwesomeIcons.gitAlt, level: 0.85),
    SkillModel(
        name: 'UI/UX Design', icon: FontAwesomeIcons.paintBrush, level: 0.70),
    SkillModel(
        name: 'Responsive Design',
        icon: FontAwesomeIcons.mobileAlt,
        level: 0.90),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startFadeInAnimation();
    });
  }

  void _startFadeInAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 4;
    double childAspectRatio = 1.2;

    if (screenWidth < 600) {
      crossAxisCount = 2;
      childAspectRatio = 1.0;
    } else if (screenWidth < 900) {
      crossAxisCount = 3;
      childAspectRatio = 1.1;
    } else if (screenWidth < 1200) {
      crossAxisCount = 4;
      childAspectRatio = 1.2;
    }

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth < 600 ? 20 : 50,
          vertical: screenWidth < 600 ? 30 : 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "My Skills",
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: skillsData.length,
              itemBuilder: (context, index) {
                return SkillTile(
                    skill: skillsData[index], isMobile: screenWidth < 600);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SkillTile extends StatefulWidget {
  final SkillModel skill;
  final bool isMobile;

  const SkillTile({
    super.key,
    required this.skill,
    required this.isMobile,
  });

  @override
  State<SkillTile> createState() => _SkillTileState();
}

class _SkillTileState extends State<SkillTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -5.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isHovered
                ? [
                    Colors.blue.shade800,
                    Colors.purple.shade600,
                  ]
                : [
                    Colors.blue.shade600,
                    Colors.purple.shade400,
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: _isHovered ? 0.3 : 0.2,
              ),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(
                0,
                _isHovered ? 10 : 5,
              ),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            widget.isMobile ? 12 : 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // FONT AWESOME ICON
              FaIcon(
                widget.skill.icon,
                color: _isHovered ? Colors.white : Colors.white70,
                size: widget.isMobile ? 36 : 42,
              ),

              SizedBox(
                height: widget.isMobile ? 8 : 12,
              ),

              Text(
                widget.skill.name,
                style: TextStyle(
                  fontSize: widget.isMobile ? 16 : 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              if (widget.skill.fullName != null) ...[
                SizedBox(
                  height: widget.isMobile ? 4 : 6,
                ),
                Text(
                  widget.skill.fullName!,
                  style: TextStyle(
                    fontSize: widget.isMobile ? 12 : 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              SizedBox(
                height: widget.isMobile ? 12 : 16,
              ),

              // PROGRESS BAR
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: widget.skill.level,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isHovered ? Colors.white : Colors.blue.shade100,
                  ),
                ),
              ),

              SizedBox(
                height: widget.isMobile ? 6 : 8,
              ),

              Text(
                '${(widget.skill.level * 100).toInt()}%',
                style: TextStyle(
                  fontSize: widget.isMobile ? 14 : 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
