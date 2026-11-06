import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  static const String resumeUrl = 'resume/Mr.MFahad_Resume_2026.pdf';

  void _downloadResume() {
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;

    anchor
      ..href = resumeUrl
      ..download = 'Mr.MFahad_Resume_2026.pdf'
      ..style.display = 'none';

    web.document.body!.appendChild(anchor);

    anchor.click();

    anchor.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070A0F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Resume',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
              top: 8,
              bottom: 8,
            ),
            child: ElevatedButton.icon(
              onPressed: _downloadResume,
              icon: const Icon(
                Icons.download,
                color: Colors.white,
              ),
              label: const Text(
                'Download Resume',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.25),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: HtmlElementView.fromTagName(
              tagName: 'iframe',
              onElementCreated: (Object element) {
                final iframe = element as web.HTMLIFrameElement;

                iframe
                  ..src = '$resumeUrl#toolbar=1&navpanes=0&scrollbar=1'
                  ..style.width = '100%'
                  ..style.height = '100%'
                  ..style.border = 'none';

                iframe.setAttribute(
                  'title',
                  'Muhammad Fahad Resume',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
