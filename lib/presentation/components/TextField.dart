import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorMsg;
  final int? maxLength;

  const MyTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.errorMsg,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: Colors.black,
      minLines: 1,
      maxLength: maxLength,
      maxLines: 10,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: hintText,
        errorText: errorMsg,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          fontSize: 14,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: validator,
    );
  }
}

class SearchField extends StatelessWidget {
  
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorMsg;
  final int? maxLength;
 final ValueChanged<String>? onChanged;

  const SearchField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.errorMsg,
    this.maxLength,
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: Colors.black,
      minLines: 1,
      maxLength: maxLength,
      maxLines: 10,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: hintText,
        errorText: errorMsg,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          fontSize: 14,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

