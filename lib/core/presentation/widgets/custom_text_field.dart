import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final TextInputAction action;

  const CustomTextField({
    Key? key,
    this.controller,
    required this.label,
    this.action = TextInputAction.next,
  }) : super(key: key);

  @override
  _CustomTextField createState() => _CustomTextField();
}

class _CustomTextField extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey.shade200,
      ),
      width: MediaQuery.of(context).size.width * (0.8),
      height: 60.0,
      alignment: Alignment.center,
      child: TextField(
        controller: widget.controller,
        textInputAction: widget.action,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: widget.label,
          border: InputBorder.none,
          hintStyle: TextStyle(
              color: Colors.grey.shade400, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
