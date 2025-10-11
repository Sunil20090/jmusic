import 'package:flutter/material.dart';

class RoundIt extends StatelessWidget {
  final Widget? child;
  RoundIt({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius:  BorderRadius.circular(20),
      child: child,
    );
  }
}