import 'package:flutter/material.dart';

class RoundIt extends StatelessWidget {
  final Widget? child;
  double radius;
  RoundIt({super.key, required this.child, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
  }
}
