// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTxtStlName extends StatelessWidget {
  final String text; // Только текст передается при создании виджета

  const MyTxtStlName({
    required this.text, // Передаем только текст
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text, // Текст поста
      style: GoogleFonts.roboto(
        // Стиль зафиксирован внутри класса
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      maxLines: 5, // Количество строк фиксировано
      overflow: TextOverflow.ellipsis, // Обрезка текста, если он длиннее
    );
  }
}

class MyTxtStlContent extends StatelessWidget {
  final String text; // Только текст передается при создании виджета

  const MyTxtStlContent({
    required this.text, // Передаем только текст
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text, // Текст поста
      style: GoogleFonts.roboto(
        // Стиль зафиксирован внутри класса
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      maxLines: 5, // Количество строк фиксировано
      overflow: TextOverflow.ellipsis, // Обрезка текста, если он длиннее
    );
  }
}

class MyTxtStlTime extends StatelessWidget {
  final String text; // Только текст передается при создании виджета

  const MyTxtStlTime({
    required this.text, // Передаем только текст
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text, // Текст поста
      style: const TextStyle(
          color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14),
      maxLines: 5, // Количество строк фиксировано
      overflow: TextOverflow.ellipsis, // Обрезка текста, если он длиннее
    );
  }
}
