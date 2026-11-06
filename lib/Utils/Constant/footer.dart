import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 50,
        vertical: isMobile ? 20 : 30,
      ),
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Connect With Us",
            style: TextStyle(
              fontSize: isMobile ? 24 : 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 20 : 40),
          // Social Icons - Wrap in Row for desktop, Column for mobile
          isMobile
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(
                            FontAwesomeIcons.github, "https://github.com"),
                        const SizedBox(width: 20),
                        _buildSocialIcon(
                            FontAwesomeIcons.linkedin, "https://linkedin.com"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(
                            FontAwesomeIcons.twitter, "https://twitter.com"),
                        const SizedBox(width: 20),
                        _buildSocialIcon(FontAwesomeIcons.instagram,
                            "https://instagram.com"),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(
                        FontAwesomeIcons.github, "https://github.com"),
                    const SizedBox(width: 20),
                    _buildSocialIcon(
                        FontAwesomeIcons.linkedin, "https://linkedin.com"),
                    const SizedBox(width: 20),
                    _buildSocialIcon(
                        FontAwesomeIcons.twitter, "https://twitter.com"),
                    const SizedBox(width: 20),
                    _buildSocialIcon(
                        FontAwesomeIcons.instagram, "https://instagram.com"),
                  ],
                ),
          SizedBox(height: isMobile ? 20 : 40),
          const Divider(color: Colors.grey, height: 1),
          SizedBox(height: isMobile ? 15 : 30),
          // Contact Info - Column for mobile, Row for larger screens
          isMobile
              ? Column(
                  children: [
                    _buildContactInfo(
                        FontAwesomeIcons.envelope, "fa8579364@gmail.com"),
                    const SizedBox(height: 15),
                    _buildContactInfo(
                        FontAwesomeIcons.phone, "+92 301 8920989"),
                    const SizedBox(height: 15),
                    _buildContactInfo(
                        FontAwesomeIcons.mapMarkerAlt, "Peshawar, Pakistan"),
                  ],
                )
              : isTablet
                  ? Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 15,
                      children: [
                        _buildContactInfo(
                            FontAwesomeIcons.envelope, "fa8579364@gmail.com"),
                        _buildContactInfo(
                            FontAwesomeIcons.phone, "+92 301 8920989"),
                        _buildContactInfo(FontAwesomeIcons.mapMarkerAlt,
                            "Peshawar, Pakistan"),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildContactInfo(
                            FontAwesomeIcons.envelope, "fa8579364@gmail.com"),
                        const SizedBox(width: 30),
                        _buildContactInfo(
                            FontAwesomeIcons.phone, "+92 301 8920989"),
                        const SizedBox(width: 30),
                        _buildContactInfo(FontAwesomeIcons.mapMarkerAlt,
                            "Peshawar, Pakistan"),
                      ],
                    ),
          SizedBox(height: isMobile ? 15 : 30),
          Text(
            "© 2023 FADIITECH. All rights reserved",
            style: TextStyle(
              color: Colors.grey,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(FaIconData icon, String url) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withValues(alpha: 0.1),
      ),
      child: IconButton(
        icon: FaIcon(icon, color: Colors.blue, size: 24),
        onPressed: () async {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          }
        },
      ),
    );
  }

  Widget _buildContactInfo(FaIconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
