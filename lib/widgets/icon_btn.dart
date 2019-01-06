import 'package:flutter/material.dart';

class SimpleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const SimpleIconBtn(
      {Key key,
      @required this.icon,
      @required this.onPressed,
      @required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(icon, size: size),
    );
  }
}
