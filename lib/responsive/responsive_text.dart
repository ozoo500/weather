import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double baseFontSize;
  final int? maxLines;

  const ResponsiveText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines,
    required this.baseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    double fontSize = baseFontSize;

    if (screenWidth >= 1024) {
      fontSize *= 1.3; 
    } else if (screenWidth >= 600) {
      fontSize *= 1.2; 
    }

    return Text(
      text,
      maxLines: maxLines ?? 5,
      overflow: TextOverflow.visible,
      softWrap: true,
      textAlign: TextAlign.start,
      style: style.copyWith(fontSize: fontSize),
    );
  }
}