import 'dart:ui';

import 'package:flutter/material.dart';

class Blur extends StatelessWidget {
  final Widget child;

  const Blur({Key key, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
        child: child,
      ),
    );
  }
}
