import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Popup extends StatelessWidget {
  Popup({super.key, this.title, this.totalSentence, this.hcpSentence, this.besureSentence});
  String ? title, totalSentence, hcpSentence, besureSentence;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Container(
        width: 100.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30),
            Text(this.title!, style: TextStyle(fontSize: 18,),),
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 20),
                Text(this.totalSentence!, style: TextStyle(fontSize: 15)),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Text('- ' + this.besureSentence!),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30),
                Text('- ' + this.hcpSentence!),
              ],
            ),
            SizedBox(height: 30),
          ],

        ),
      ),
    );
  }
}