import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubeVideoEmbed extends StatelessWidget {
  final String videoId;

  const YouTubeVideoEmbed({super.key, required this.videoId});

  _launchURL() async {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchURL,
      child: const Text('Watch Video'),
    );
  }
}
