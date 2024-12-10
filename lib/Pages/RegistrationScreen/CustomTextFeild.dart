import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomTextFeild extends StatefulWidget {
  const CustomTextFeild({super.key, this.obsecureText,this.hintText, this.textInputType, this.controller});

  final bool? obsecureText;
  final String? hintText;
  final TextInputType? textInputType;
  final TextEditingController? controller;

  @override
  State<CustomTextFeild> createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {

  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
            width: 0.5
          ),
          borderRadius: BorderRadius.circular(10.0), 
          ),
      width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 40.w : 90.w,
      child: TextFormField(
          controller: widget.controller,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return AppLocalizations.of(context)!.required;
            } else {
              return null;
            }
          },
          obscureText: widget.obsecureText == true ? true : false,
          keyboardType: widget.textInputType!,
          decoration: 
          
        InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            hintText: widget.hintText,
            border: InputBorder.none,
        ),
        ),
    );
  }
}
