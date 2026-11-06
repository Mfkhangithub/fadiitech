import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget Function(BuildContext context) mobileBuilder;
  final Widget Function(BuildContext context) desktopBuilder;

  const ResponsiveWidget(
      {super.key, required this.mobileBuilder, required this.desktopBuilder});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      // Mobile view
      return mobileBuilder(context);
    } else {
      // Desktop view
      return desktopBuilder(context);
    }
  }
}
