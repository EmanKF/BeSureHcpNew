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
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400
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
          obscureText: widget.hintText == 'Password' && isHide == false ? false : widget.hintText == 'Password' && isHide == true ? true : false,
          keyboardType: widget.textInputType!,
          decoration: widget.hintText == 'Password' ?
          InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            hintText: AppLocalizations.of(context)!.password,
            suffixIcon:  isHide == false ? IconButton(
                onPressed: (){
                        setState(() => isHide = true);
                        },
                icon:  Icon(Icons.remove_red_eye_outlined),
          ):
          IconButton(
                onPressed: (){
                        setState(() => isHide = false);
                        },
                icon:  Icon(Icons.visibility_off_outlined),
          ),
          border: InputBorder.none,
          )
          :
        
        InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            hintText: widget.hintText == 'Email' ? AppLocalizations.of(context)!.email : AppLocalizations.of(context)!.phoneNumber,
            suffixIcon: widget.hintText == 'Email' ? Icon(Icons.mail_outlined) : widget.hintText == 'Phone' ? Icon(Icons.local_phone) : Icon(Icons.remove_red_eye),
              border: InputBorder.none,
              )
        ),
    );
  }
}
