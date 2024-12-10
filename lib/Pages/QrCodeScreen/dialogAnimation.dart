import 'package:besure_hcp/Models/ScanQrObject.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/TakeServicesScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class DialogAnimation extends StatefulWidget {
  const DialogAnimation({super.key, this.sObj});

  final ScanQrObject? sObj;

  @override
  State<DialogAnimation> createState() => _DialogAnimationState();
}

class _DialogAnimationState extends State<DialogAnimation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goNext();
  }

  goNext() async{
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
    // Navigator.push(context, MaterialPageRoute(builder: ((context) => TakeServicesScreen(sObj: widget.sObj))));
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:  Colors.transparent,

      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(500.0)
      ),
      content: Container(
        child: Lottie.asset(
          'assets/animations/scanDoneAnimation.json',
          width: 80.w,
          height: 80.w,
        ),
      ),
    );
  }
}