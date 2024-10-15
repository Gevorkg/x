import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTxtStlName extends StatelessWidget {
  final String text;

  const MyTxtStlName({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class MyTxtStlArtic extends StatelessWidget {
  final String text;

  const MyTxtStlArtic({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class MyTxtStlContent extends StatelessWidget {
  final String text;

  const MyTxtStlContent({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class MyTxtStlTime extends StatelessWidget {
  final String text;

  const MyTxtStlTime({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class MyTxtStlDrawer extends StatelessWidget {
  final String text;

  const MyTxtStlDrawer({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}


class MyTxtStlNickname extends StatelessWidget {
  final String text;

  const MyTxtStlNickname({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 16),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}
