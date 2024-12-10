import 'dart:convert';
import 'dart:developer';

import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/HomeScreen/HomeSceen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/AfterPaymentScreen.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/Components/ConfirmationPopUp.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/Components/PayingDialog.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/UploadBillScreen.dart';
import 'package:besure_hcp/Services/PaymentServices.dart';
import 'package:besure_hcp/Services/TakeServices.dart';
import 'package:besure_hcp/configure_ws.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmServices extends ConsumerStatefulWidget {
  const ConfirmServices({super.key, this.amount, this.name, this.services, this.cardId, this.clientId});
  final List<ServiceModel>? services;
  final int? cardId;
  final String? name, clientId;
  final num? amount;

  @override
  ConsumerState<ConfirmServices> createState() => _ConfirmServicesState();
}

class _ConfirmServicesState extends ConsumerState<ConfirmServices> with Observer{
  bool isLoadingCash = false,isLoadingCard = false, isPayedCash = false;


  String getTotalDiscount(){
    double res = 0.0;

    for(ServiceModel s in widget.services!){
      if(s.Is_Accepted == true){
      res = res + (s.price! * (s.dis!/100));
      }
      // print(res);
    }
    res = widget.amount! - res;
    // print(res);
    return res.toString();
  }

  @override
  void initState() {
    Observable.instance.addObserver(this);    
    super.initState();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        foregroundColor: grey,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: Column(
          children: [
              Row(
              children: [
                SizedBox(
                  width: 5.w,
                ),
                Text(AppLocalizations.of(context)!.name + ":", style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: silverLakeBlue,
                  fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 8.sp : 16.sp
                )),
                SizedBox(
                  width: 2.w,
                ),
                Text(widget.name!, style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: silverLakeBlue,
                  fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 8.sp : 16.sp
                )),
              ],
            ),
             SizedBox(
              height: 2.h,
            ),         
            Container(
              child: Column(
                children: [
                  for(ServiceModel s in widget.services!)
                  if(s.Is_Accepted == true)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
                    child: (Row(
                      children: [
                        Text(s.name!),
                        Spacer(),
                        Text(s.dis!.toString()+'%  ', style: TextStyle(color: Colors.red),),
                        Text((s.price! - (s.price! * (s.dis!/100))).toString()),
                        Text(' ' + AppLocalizations.of(context)!.currency)
                      ],
                    )),
                  )
                ],
              ),
            )        ,
             Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200
                  )
                )
              ),
              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: (Row(
                children: [
                  Text(AppLocalizations.of(context)!.totalBeforeDiscount, style: TextStyle(
                    fontWeight: FontWeight.w500
                  ),),
                  Spacer(),
                  Text(widget.amount.toString(), style: TextStyle(
                    fontWeight: FontWeight.w500
                  ),),
                  Text(' ' + AppLocalizations.of(context)!.currency)
                ],
              )),
             ),
            //  Container(
            //   margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
            //   child: (Row(
            //     children: [
            //       Text(AppLocalizations.of(context)!.discount, style: TextStyle(
            //         fontWeight: FontWeight.w500
            //       ),),
            //       Spacer(),
            //       Text(widget.discount.toString(), style: TextStyle(
            //         fontWeight: FontWeight.w500
            //       ),),
            //     ],
            //   )),
            //  ),
             Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200
                  )
                )
              ),
              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: (Row(
                children: [
                  Text(AppLocalizations.of(context)!.totalAfterDiscount, style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),),
                  Spacer(),
                  Text(getTotalDiscount(), textDirection: TextDirection.ltr,style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.red
                    
                  ),),
                  Text(' ' + AppLocalizations.of(context)!.currency, style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.red))
                ],
              )),
             ),

              Spacer(),
                   Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    width: 90.w,
                    // margin: EdgeInsets.all(5.w),
                    color: Colors.red,
                    child: TextButton(
                      onPressed: () async{ 
                        setState(() {
                          isLoadingCard = true;
                        });
                        Map map = new Map();
                        map["id"] = widget.cardId;
                        map["clientId"] = widget.clientId;
                        map["orderNb"] = "string";
                        map["amount"] = 1;
                        map["discount"] = 0;
                        map["discount_Benifit_PNPL"] = 0;
                        map["commision"] = 0;
                        map["is_Paid_By_Amazon"] = true;
                        map["is_Cancel"] = false;
                        map['languageId'] = SplashScreen.langId;
                        map["date"] = DateTime.now().toIso8601String();
                        String url = await payCredit(map);
                        log(url);

                        /////////////////
                        ///
                        var onesignalId = await OneSignal.User.getOnesignalId() ?? 'N/A';
    log(onesignalId+' on send msg');
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('SPId') ?? '';
        final message = {
          "Id":0,
          "Action":"ClientCardPayment",
          "Message":"ClientCardPayment",
          "ClientPoints":0,
          "ClientName_en":widget.name,
          "SPName_en":"",
          "ClientName":widget.name,
          "SPName":"",
          "SPPoints":0,
          "SP": id,
          "SPDeviceId":onesignalId,
          "Client": widget.clientId,
          "Data":["String"],
          "ClientCard": [],
          "ClientCardId" : widget.cardId,
          "PaymentUrl": url
        };
            
            log(message.toString());
          ref.read(websocketProvider).sendMessage(jsonEncode(message));
          
                        ///////////////
                        // print(res);
                        setState(() {
                          isLoadingCard = false;
                        });
                        showDialog(context: context, builder: (context) => PayingDialog(name: widget.name,));
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AfterPaymentScreen()));
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => BaseScreen()));
                      }, 
                      child: isLoadingCard == true ? LoadingAnimationWidget.horizontalRotatingDots(color: Colors.white, size: 40) : Text('Pay by BeSure', style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 8.sp : 16.sp
                      ))
                    ),
                  ),
                  
                   Container(
                    margin: EdgeInsets.only(top:8, bottom: 20),
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    // margin: EdgeInsets.all(5.w),
                    // color: silverLakeBlue,
                    child: GestureDetector(
                      onTap: () async{ 
                        setState(() {
                          isLoadingCash = true;
                        });
                        
                        // print(res);
                        setState(() {
                          isLoadingCash = false;
                        });
                        // if(res == true){
                          showDialog(context: context, builder: (context) => ConfirmationPopUp(name: widget.name, cardId: widget.cardId, clientID: widget.clientId,));
                        //   Navigator.pop(context);
                        //   // Navigator.pop(context);
                        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BaseScreen(billUploaded: true)));
                        // }
                      }, 
                      child:isLoadingCash == true ? LoadingAnimationWidget.horizontalRotatingDots(color: silverLakeBlue, size: 40) : 
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Pay at ', style: TextStyle(
                              color: silverLakeBlue,
                              fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 8.sp : 12.sp
                            )),
                            TextSpan(text: 'Frontdesk', style: TextStyle(
                              color: silverLakeBlue,
                              fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 8.sp : 14.sp
                            )),
                          ],
                        ),
                      )
                    ),
                  ),
                      
          ],
      ),
      )
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) async{
    log(map.toString());
    log(map!['action']);
    if(map!['action'] == 'PaymentFrontDesk'){
      showDialog(context: context, builder: (context) => ConfirmationPopUp(name: widget.name, cardId: widget.cardId, clientID: widget.clientId,));
    }
    else if(map['action'] == 'GeneratePaymentLink'){
      Map map = new Map();
                        map["id"] = widget.cardId;
                        map["clientId"] = widget.clientId;
                        map["orderNb"] = "string";
                        map["amount"] = widget.amount;
                        map["discount"] = 0;
                        map["discount_Benifit_PNPL"] = 0;
                        map["commision"] = 0;
                        map["is_Paid_By_Amazon"] = true;
                        map["is_Cancel"] = false;
                        map["date"] = DateTime.now().toIso8601String();
                        log(jsonEncode(map));
                        String url = await payCredit(map);
                        log(url);

                        /////////////////
                        ///
                        var onesignalId = await OneSignal.User.getOnesignalId() ?? 'N/A';
    log(onesignalId+' on send msg');
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('SPId') ?? '';
        final message = {
          "Id":0,
          "Action":"ClientCardPayment",
          "Message":"ClientCardPayment",
          "ClientPoints":0,
          "ClientName_en":widget.name,
          "SPName_en":"",
          "ClientName":widget.name,
          "SPName":"",
          "SPPoints":0,
          "SP": id,
          "SPDeviceId":onesignalId,
          "Client": widget.clientId,
          "Data":["String"],
          "ClientCard": [],
          "ClientCardId" : widget.cardId,
          "PaymentUrl": url
        };
            
            log(message.toString());
          ref.read(websocketProvider).sendMessage(jsonEncode(message));
          Navigator.push(context, MaterialPageRoute(builder: (context) => BaseScreen()));
    }
  }
}