import 'package:flutter/material.dart';

class GlowImageExample extends StatelessWidget {
  const GlowImageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Glow Effect')),
      body: Center(
        child: Container(
          width: 200, // Set the desired width
          height: 200, // Set the desired height
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Makes the container circular
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.withValues(alpha: 0.8), // Glow color
                blurRadius: 20, // Glow intensity
                spreadRadius: 10, // Glow size
              ),
            ],
            image: const DecorationImage(
              image: AssetImage(
                  'assets/probg.png'), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
