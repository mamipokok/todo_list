import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/constants/custom_color.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final bool ReadOnly;
  final String hintText;
  final GestureTapCallback? fungsi;
  final FormFieldValidator? validator;
  CustomTextfield({
    super.key,
    this.fungsi,
    this.validator,
    required this.controller,
    required this.ReadOnly,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: CustomColor.warna3,
      ),
      onTap: fungsi,
      controller: controller,
      readOnly: ReadOnly,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: CustomColor.warna1,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 159, 118, 47),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
