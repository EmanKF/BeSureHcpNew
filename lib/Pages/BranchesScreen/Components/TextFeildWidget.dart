import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TextFeildWidget extends StatelessWidget {
  const TextFeildWidget({super.key, this.controller, this.hint, this.icon, this.maxLines});

  final TextEditingController? controller;
  final String? hint;
  final Icon? icon;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.symmetric(vertical: 1.h),
      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: icon ,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: silverLakeBlue, width: 1),
          ),
        ),
      )
    );
  }
}