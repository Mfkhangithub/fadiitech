import 'package:flutter/material.dart';

class Aboutusp extends StatefulWidget {
  const Aboutusp({super.key});

  @override
  State<Aboutusp> createState() => _AboutuspState();
}

class _AboutuspState extends State<Aboutusp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('About Us'),
      content: const Text(
        "Welcome to FADIITECH, where innovation meets creativity.\n "
        "Our mission is to provide top-notch software development \n"
        "services to empower businesses worldwide. With a passion \n"
        "for technology and a dedication to excellence, we specialize \n"
        "in delivering customized solutions tailored to your unique needs.",
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
