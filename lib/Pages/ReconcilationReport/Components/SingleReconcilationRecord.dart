import 'package:besure_hcp/Models/DisplayReconcilation.dart';
import 'package:besure_hcp/Models/ReconcilationObject.dart';
import 'package:besure_hcp/Pages/ReconcilationReport/ReconcilationMainScreen.dart';
import 'package:besure_hcp/Services/ReconcilationReportsServices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SingleReconcilationReport extends StatefulWidget {
  SingleReconcilationReport({super.key, this.reconcilation});

  ReconcilationObject? reconcilation;

  @override
  State<SingleReconcilationReport> createState() => _SingleReconcilationReportState();
}

class _SingleReconcilationReportState extends State<SingleReconcilationReport> {
  bool isDone = true;

  String formatDate(String date){
    final String formattedDate = DateFormat('d-M-yyyy').format(DateTime.parse(date));
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.reconcilation!.is_Canceled == true ? Colors.red.shade300 : widget.reconcilation!.is_Pending == true && widget.reconcilation!.is_Canceled == false ? Colors.blue.shade300 : Colors.green.shade300,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                children: [
                  TextSpan(text: 'From: ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  TextSpan(text: formatDate(widget.reconcilation!.reconcilationFrom!), style: TextStyle(color: Colors.white)),
                  TextSpan(text: '   To: ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  TextSpan(text: formatDate(widget.reconcilation!.reconcilationTo!), style: TextStyle(color: Colors.white))
                ],
              )
            ),

            SizedBox(
              height: 5,
            ),

            RichText(text: TextSpan(
              children: [
                TextSpan(text: 'Setteled Amount: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: widget.reconcilation!.spSetteledAmount!.toString()),
                TextSpan(text: ' SAR')
              ]
            ))

            ],
          ),
          Spacer(),

          GestureDetector(
            onTap: () async{
              setState(() {
                isDone = false;
              });
              DisplayReconcilation reconc =  DisplayReconcilation();
              reconc = await DisplayClaim(DateTime.parse(widget.reconcilation!.reconcilationFrom!).toIso8601String(), DateTime.parse(widget.reconcilation!.reconcilationTo!).toIso8601String());
              setState(() {
                isDone = true;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReconcilationMainScreen(reconcilation: reconc, from: widget.reconcilation!.reconcilationFrom, id: widget.reconcilation!.id,to: widget.reconcilation!.reconcilationTo, fileName: widget.reconcilation!.fileName,is_approved: widget.reconcilation!.is_Settled_SP,is_disapproved: widget.reconcilation!.is_Canceled!,)));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              child: isDone == false ? 
              LoadingAnimationWidget.horizontalRotatingDots(color: widget.reconcilation!.is_Canceled == true ? Colors.red.shade300 : widget.reconcilation!.is_Pending == true && widget.reconcilation!.is_Canceled == false ? Colors.blue.shade300 : Colors.green.shade300, size: 25) 
              : 
              Text('View',style: TextStyle(color: widget.reconcilation!.is_Canceled == true ? Colors.red.shade300 : widget.reconcilation!.is_Pending == true && widget.reconcilation!.is_Canceled == false ? Colors.blue.shade300 : Colors.green.shade300),)),
          ),


        ],
      ),      
    );
  }
}