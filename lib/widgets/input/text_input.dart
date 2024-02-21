import 'package:flutter/material.dart';

class UWTextFormField extends StatefulWidget {
  const UWTextFormField(
      {super.key,
      required this.labelText,
      this.controller,
      this.autofillHints,
      this.obscureText = false});
  final String labelText;
  final TextEditingController? controller;
  final List<String>? autofillHints;
  final bool obscureText;

  @override
  State<UWTextFormField> createState() => _UWTextFormFieldState();
}

class _UWTextFormFieldState extends State<UWTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofillHints: widget.autofillHints,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
