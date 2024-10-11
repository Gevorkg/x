import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextButtonAuth extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const MyTextButtonAuth({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          elevation: 3.0,
          backgroundColor: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
          padding: padding ?? const EdgeInsets.all(.0)),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: fontSize ?? 16.0,
        ),
      ),
    );
  }
}

class MyTextButtonSubscribe extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const MyTextButtonSubscribe({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        elevation: 3.0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        padding: padding ?? const EdgeInsets.all(.0),
        side: const BorderSide(color: Colors.grey, width: 1)
        
      ),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          color: textColor ?? Colors.black,
          fontSize: fontSize ?? 16.0,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }
}
