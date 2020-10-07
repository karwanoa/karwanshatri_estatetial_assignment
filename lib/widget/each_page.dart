import 'package:flutter/material.dart';

class EachPage extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const EachPage({Key key, this.text, this.color, this.textColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 28,
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
