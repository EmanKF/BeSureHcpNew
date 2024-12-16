import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileItemWidget extends StatelessWidget {
  const ProfileItemWidget({super.key, this.icon, this.text, this.function});

  final IconData? icon;
  final String? text;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        padding:
            EdgeInsets.only(right: 5.w, left: 5.w, top: 1.2.h, bottom: 1.2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon!,
              color: icon! == Icons.logout ? Colors.red : Colors.black,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.w : 2.w,
            ),
            Text(
              text!,
              style: TextStyle(
                  color: icon! == Icons.logout ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.sp : 16.sp),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: grey,
              size: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height? 1.w : 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
