import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/ClientReport.dart';
import 'package:besure_hcp/Pages/ReconcilationReport/Components/SingleTransactionRecordPopUp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleTransactionRecord extends StatefulWidget {
   SingleTransactionRecord({super.key, this.clientReport});

  ClientReport? clientReport;

  @override
  State<SingleTransactionRecord> createState() => _SingleTransactionRecordState();
}

class _SingleTransactionRecordState extends State<SingleTransactionRecord> {

  String formatDate(String date){
    final String formattedDate = DateFormat('d-M-yyyy').format(DateTime.parse(date));
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showDialog(context: context, builder: ((context) => SingleTransactionRecordPopUp(transaction: widget.clientReport)));
      },
      child: Container(
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
                Text(widget.clientReport!.clientName!,style: TextStyle(color: silverLakeBlue)),
                Text(formatDate(widget.clientReport!.paymentDate!), style: TextStyle(color: silverLakeBlue),),
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
      ),
    );
  }
}