import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product-details');
      },
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Image.asset('assets/flutterapp.png', fit: BoxFit.cover),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Mobile Application',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Text('\$300'),
          ],
        ),
      ),
    );
  }
}
