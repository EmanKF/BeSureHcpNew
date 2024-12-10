import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:flutter/material.dart';

class singleTrans extends StatelessWidget {
  const singleTrans({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade100
        ),
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(widget.clientReport!.clientName!,style: TextStyle(color: silverLakeBlue)),
                // Text(formatDate(widget.clientReport!.paymentDate!), style: TextStyle(color: silverLakeBlue),),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(' '),
                Text('Cash', style: TextStyle(color: silverLakeBlue),),
                // Text(' '),
                // Text('2024/6/6'),
                // RichText(text: TextSpan(
                //   children: [
                //     TextSpan(text: '200',style: TextStyle(color: Colors.black)),
                //     TextSpan(text: ' SAR  ',style: TextStyle(color: Colors.black)),
                //     TextSpan(text: '( 5% )',style: TextStyle(color: Colors.black)),
                //   ]
                // ))
              ],
            ),
      
            SizedBox(
              width: 10,
            ),
            
            Icon(Icons.arrow_forward_ios_rounded, color: silverLakeBlue,)
      
          ],
        ),
      );
  }
}