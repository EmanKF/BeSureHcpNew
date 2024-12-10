import 'dart:developer';
import 'dart:io';
import 'package:besure_hcp/Pages/ReconcilationReport/Components/PdfReviewAndDownloadPage%20.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:http/http.dart' as http;
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/ClientReport.dart';
import 'package:besure_hcp/Models/DisplayReconcilation.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/ReconcilationReport/Components/Popup.dart';
import 'package:besure_hcp/Pages/ReconcilationReport/Components/SingleTransactionRecord.dart';
import 'package:besure_hcp/Pages/ReconcilationReport/Components/disaprovePopup.dart';
import 'package:besure_hcp/Pages/TransactionsScreen/SingleTransactionScreen.dart';
import 'package:besure_hcp/Services/ReconcilationReportsServices.dart';
import 'package:besure_hcp/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class ReconcilationMainScreen extends StatefulWidget {
  ReconcilationMainScreen({super.key, this.reconcilation, this.from,this.to, this.id, this.fileName, this.is_approved, this.is_disapproved});

  DisplayReconcilation? reconcilation;
  int? id;
  String? from,to, fileName;
  bool? is_approved, is_disapproved;

  @override
  State<ReconcilationMainScreen> createState() => _ReconcilationMainScreenState();
}

class _ReconcilationMainScreenState extends State<ReconcilationMainScreen> {
  DateTime? fromDate =  DateTime.now(), toDate =  DateTime.now();
  DateTime defaultDate = DateTime.now();
  bool isSelected_fromDate = false, isSelected_toDate = false;
  // DisplayReconcilation reconcilation = DisplayReconcilation();
  num totalTrans = 0;
  bool isDone = true, isDownloadDone = true, approved = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    approved = widget.is_approved!;
  }

  String formatDate(String date){
    final String formattedDate = DateFormat('d-M-yyyy').format(DateTime.parse(date));
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reconcilation Report'),
        backgroundColor: silverLakeBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(widget.reconcilation!.reportList != null)
              Container(
                color: silverLakeBlue,
                child: Column(
                  children: [
                    // SizedBox(
                    //   height: 40,
                    // ),
                    // Text('Reconcilation Report', style: TextStyle(fontSize: 16, color: Colors.white),),
                    // SizedBox(
                    //   height: 7,
                    // ),
          
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       margin: EdgeInsets.symmetric(horizontal:30),
              //       child: RichText(
              //         text: TextSpan(
              //           children: [
              //             TextSpan(text: 'Commission Rate:  ', style: TextStyle(color: Colors.white, fontSize: 16)),
              //             TextSpan(text: BaseScreen.commission.toString(), style: TextStyle(color: Colors.white)),
              //             TextSpan(text: '%', style: TextStyle(color: Colors.white)),
              //           ]
              //         )
              //       ),
              //     ),
              //   ],
              // ),
      
              SizedBox(
                height: 4,
              ),
      
              Container(
                child: Text('Balance', style: TextStyle(color: Colors.white, fontSize: 18),),
              ),
              Container(
                margin: EdgeInsets.all(1),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: (widget.reconcilation!.transactionTotalCenterCash! + widget.reconcilation!.transactionBesurePayment!).toString(), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      TextSpan(text: ' SAR', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                    ]
                  ))
              ),
      
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(255, 165, 212, 234)
                            ),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(context: context, builder: ((context) => Popup(title: 'Total Transactions',totalSentence: 'Total Transactions: ' + totalTrans.toString() + ' SAR', hcpSentence: 'Center Cash: ' + widget.reconcilation!.transactionTotalCenterCash.toString() + ' SAR', besureSentence: 'BeSure Payments: ' + widget.reconcilation!.transactionBesurePayment.toString() + ' SAR',)));
                              },
                              child: Icon(Icons.compare_arrows_outlined, color: Colors.white))),
                          Text('Transactions', style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(255, 165, 212, 234)
                            ),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(context: context, builder: ((context) => Popup(title: 'Total Commission Detuctions',totalSentence: 'Total Commission Detuctions: (' + BaseScreen.commission.toString() + '%)', hcpSentence: 'In Center Amount: ' + widget.reconcilation!.centerCashCommission.toString() + ' SAR', besureSentence: 'with BeSure Account ' + widget.reconcilation!.besureAmazonComission.toString() + ' SAR',)));
                              },
                              child: Icon(Icons.percent_rounded, color: Colors.white))),
                          Text('Commissions',style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ),
                
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromARGB(255, 165, 212, 234)
                            ),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(context: context, builder: ((context) => Popup(title: 'Transfers/Settlement',totalSentence: 'Money Transfers:', hcpSentence: 'From HCP to BeSure: ' + widget.reconcilation!.transferFromHCPToBeSure.toString() + ' SAR', besureSentence: 'From BeSure to HCP: ' + widget.reconcilation!.transferFromBeSureToHCP.toString() + ' SAR',)));
                              },
                              child: Icon(Icons.account_balance_wallet, color: Colors.white))),
                          Text('Transfers', style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    )
                  ],
                ),
              )
      
      
                  ],
                ),
              ),
      
              if(widget.reconcilation!.reportList == null)
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text('Reconcilation Report')
                  ]),
              ),
            
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )
                  ),
                  child: Column(
                    children: [
                      Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: silverLakeBlue,
                      width: 0.3
                    )
                  )
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                              width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 28.w : 44.w ,
                              child: TextButton(
                              onPressed: () async{
                                    // final DateTime? picked = await showDatePicker(
                                    //           helpText: AppLocalizations.of(context)!.from,
                                    //           context: context,
                                    //           initialDate: DateTime.now(),
                                    //           firstDate: DateTime(2020),
                                    //           lastDate: DateTime(2024)
                                    //               .add(const Duration(days: 360)),
                                    //           );
                                    //       if (picked != null) {
                                    //         if(picked.isAfter(toDate!)){
                                    //           showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.dateValidationFrom));
                                    //           print('nooooooooooooo');
                                    //         }
                                    //         else{
                                    //         setState(() {
                                    //           fromDate = picked;
                                    //           isSelected_fromDate = true;
                                    //         });
                                    //         }
                                    //       }
                                },
                                
                                child: Row(
                                  children: [
                                    Icon(Icons.event_rounded, color: isSelected_fromDate == false ?  azureishBlue : silverLakeBlue, size: 30,),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        Text('From Date',textAlign: TextAlign.start, style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.w100, fontSize: 10),),
                                          
                                        
                                        Text(
                                            formatDate(widget.from!),
                                            textScaleFactor: 1.0,
                                            style: TextStyle(color: isSelected_fromDate == false ?  azureishBlue : silverLakeBlue, fontWeight: FontWeight.bold,fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                              ),
          
                               Container(
                                width: 0.3, // Width of the vertical line
                                height: 30, // Height of the vertical line
                                color: silverLakeBlue, // Line color
                              ),
                
                    Container(
                          width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 28.w : 44.w ,
                          child: TextButton(
                          onPressed: () async{
                            //  final DateTime? picked = await showDatePicker(
                            //               helpText: AppLocalizations.of(context)!.to,
                            //               context: context,
                            //               initialDate: DateTime.now(),
                            //               firstDate: DateTime(2020),
                            //               lastDate: DateTime(2024)
                            //                   .add(const Duration(days: 360)));
                            //           if (picked != null) {
                            //              if(picked.isBefore(fromDate!)){
                            //                   showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.dateValidationTo));
                            //                   print('nooooooooooooo');
                            //                 }
                            //                 else{
                            //                 setState(() {
                            //                   toDate = picked;
                            //                   isSelected_toDate = true;
                            //                 });
                            //                 }
                            //           }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.event, color: isSelected_toDate == false ?  azureishBlue : silverLakeBlue, size: 30),
                                SizedBox(
                                  width: 10,
                                ),
                                
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('To Date',textAlign: TextAlign.start, style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.w100, fontSize: 10),),
                                    Text(
                                        formatDate(widget.to!),
                                        textScaleFactor: 1.0,
                                        style: TextStyle(color: isSelected_toDate == false ?  azureishBlue : silverLakeBlue, fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                          ),
                
                    ],
                  ),
              ),
          
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 40.w ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: approved == true ? Colors.grey : silverLakeBlue
                      ),
                      child: TextButton(
                        onPressed: () async{
                          if(approved == false){
                          setState(() {
                            isDone = false;
                          });

                          await approveReconcilation(widget.id!, true, '');
                          Observable.instance.notifyObservers([
                          "_PreReconcilationScreenState",
                          ], notifyName : "update");                          
                            setState(() {
                              isDone = true;
                              approved = true;
                            });
                          }
                        }, 
                        child: isDone == false? LoadingAnimationWidget.stretchedDots(
                          color: Colors.white,
                          size: 30
                        ) 
                        : 
                        Text(approved == true? 'Approved' : 'Approve', style: TextStyle(color: Colors.white),))
                        ),

                        Container(
                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 40.w ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: widget.is_disapproved == true? Colors.grey : silverLakeBlue
                      ),
                      child: TextButton(
                        onPressed: () async{
                          if(widget.is_disapproved == false)
                          showDialog(context: context, builder: ((context) => DisapprovePopUp(id: widget.id!,)));
                        }, 
                        child: 
                        Text(widget.is_disapproved == true? 'Disapproved' : 'Disapprove', style: TextStyle(color: Colors.white),))
                        ),

                ],
              ),

              SizedBox(
                height: 5
              ),
               if(widget.fileName != null && widget.fileName != '')
               Container(
                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 87.w ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: silverLakeBlue
                      ),
                      child: TextButton(
                        onPressed: () async{
                          setState(() {
                            isDownloadDone = false;
                          });
                          log(swaggerReportsUrl + widget.fileName!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfDownloadScreen(pdfUrl: swaggerReportsUrl + widget.fileName!),
                            ),
                          );
                      
                          // await generateAndNotifyPdf(widget.reconcilation!, widget.from!,widget.to!);
                          setState(() {
                            isDownloadDone = true;
                          });
                        }, 
                        child: isDownloadDone == false? Container(
                          child: Lottie.asset(
                            'assets/animations/downloadingPdf.json',
                            // width: 80.w,
                            height: 10.w,
                          ),
                        )
                        : 
                        Text('Preview PDF', style: TextStyle(color: Colors.white),))
                        ),
                      
                      if(widget.reconcilation!.reportList != null)
                      for(ClientReport c in widget.reconcilation!.reportList!)
                      SingleTransactionRecord(clientReport: c),
      
                      // Spacer()
                    ],
                  ),
                ),
                
            ],
          ),
        ),
      ),
    );
  }
}