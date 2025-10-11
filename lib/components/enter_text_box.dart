import 'package:jmusic/constants/local_constant.dart';
import 'package:flutter/material.dart';

class EnterTextBox extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? type;
  final String? hintText;
  bool obscureText = false;
  final int maxLines;
  EnterTextBox({
    super.key,
    this.controller,
    this.hintText,
    this.type,
    this.obscureText = false,
    this.maxLines = 1,
  });

  @override
  State<EnterTextBox> createState() => _EnterTextBoxState();
}

class _EnterTextBoxState extends State<EnterTextBox> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.type,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        border: getInputBorder(),
      ),
    );
  }
}
