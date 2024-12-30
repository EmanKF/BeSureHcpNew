import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Functions/OneSignalWeb.dart';
import 'package:besure_hcp/Models/Appointment.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/ConfirmServices.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/TakeServicesScreen.dart';
import 'package:besure_hcp/RiverpodProviders/riverpodProviders.dart';
import 'package:besure_hcp/configure_ws.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/ServicesScreen/AllServicesScreen.dart';
import 'package:besure_hcp/Models/ScanQrObject.dart';
import 'package:besure_hcp/Services/TakeServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AppointmentDetails extends ConsumerStatefulWidget {
  const AppointmentDetails({super.key, this.appointment});

  final Appointment? appointment;

  @override
  ConsumerState<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends ConsumerState<AppointmentDetails>{
  ServiceModel? selectedService;
  List<ServiceModel> addedServices = [];
  bool isLoadingAdd = false;
  bool isLoadingPay = false;

   @override
  void initState() {
    super.initState();
    addedServices = widget.appointment!.clientServices!;
    ref.read(websocketProvider).connect(ref);
  }
  @override
  void dispose(){
  //   final webSocketService = ref.read(websocketProvider);
  //  webSocketService.dispose(ref);
    super.dispose();
  }

  final allApprovedServicess = AllServicesScreen.allApprovedServices.toList();

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('TakeServiceDisplayedBefore',true);
  }
  

  void sendWebSocketMessage(List<ServiceModel> list) async{
    var onesignalId = '2219b7bc-722b-e852-e229-0e2ead6f9cdf';
    if(!kIsWeb){
      onesignalId = await OneSignal.User.getOnesignalId() ?? 'N/A';
    }
    else if(kIsWeb){
      onesignalId = await getOneSignalPlayerId();
      log(onesignalId);
    }
    log(onesignalId+' on send msg');
    final prefs = await SharedPreferences.getInstance();
        String id = prefs.getString('SPId') ?? '';
        List<Map> mapList = List.empty(growable: true);
        for(ServiceModel s in list){
          // if(s.dis == null) s.dis = 0 ;
          Map<String,dynamic> map = new Map();
          num discountValue = (s.price! * s.dis!)/100;
          num priceAfterDiscount = s.price! - discountValue;
          map['Id'] = 0;
          map['ServiceProviderServicesId'] = s.serviceProviderServicesId;
          map['ClientCardId'] = 0;
          map['Service'] = s.name;
          map['ServiceImage'] = "string";
          map['Amount'] = priceAfterDiscount;
          map['Discount'] = discountValue;
          map['Note'] = "Note";
          map["ServiceDiscount"] = 0;
          map["Is_Accepted"] = true;
          mapList.add(map);
        }
        
        final message = {
          "Id":0,
          "Action":"ClientCardPopup",
          "Message":"PopupClientCard",
          "ClientPoints":0,
          "ClientName_en":widget.appointment!.client!.fullName_en,
          "SPName_en":"",
          "ClientName":widget.appointment!.client!.fullName,
          "SPName":"",
          "SPPoints":0,
          "SP": id,
          "SPDeviceId":onesignalId,
          "BranchId" : 0,
          "Client": widget.appointment!.client!.id,
          "Data":["String"],
          "ClientCard": mapList
            };
            log(jsonEncode(message));
            log(message.toString());
      ref.read(websocketProvider).sendMessage(jsonEncode(message));
  }


  @override
  Widget build(BuildContext context) {
    var rejectedServices = ref.read(servicesRejected);
    log(rejectedServices.toString());

    return Scaffold(
      appBar: AppBar(
        foregroundColor: grey,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: 100.w,
        height:100.h,
        color: Colors.white,
        child: SingleChildScrollView(        
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(AppLocalizations.of(context)!.name +":", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: silverLakeBlue,
                    fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 13.sp : 16.sp
                  )),
                  SizedBox(
                    width: 1.w,
                  ),
                  Text(widget.appointment!.client!.fullName!, style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: silverLakeBlue,
                    fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 13.sp : 16.sp
                  )),
                ],
              ),
               SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(AppLocalizations.of(context)!.eligibleSentence),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(AppLocalizations.of(context)!.services, style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: silverLakeBlue,
                    fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                    fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 12.sp : 16.sp
                  )),
                ],
              ),
      
              Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: DropdownButtonFormField(
                        items: allApprovedServicess.map((ServiceModel value){
                          return new DropdownMenuItem<String>(
                            value: value.id.toString(),
                            child: Container(
                              width: 160,
                              child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                          );
                        }).toList(),
                        validator: (val){
                            if(val == null)
                            return 'Select Service';
                            else return null;
                        },
                        onChanged: (v){
                          // print(v.toString());
                          for( ServiceModel s in allApprovedServicess){
                            if(s.id == int.parse(v.toString())){
                              setState(() {
                                selectedService = ServiceModel.clone(s);
                              });
                            }
                          }
                          // print(selectedService!.id.toString()+' '+selectedService!.name!);                          
                        },
      
                          hint: Text(AppLocalizations.of(context)!.services, style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700
                              )
                          ),
                          decoration: InputDecoration( 
                            prefixIcon: Icon(Icons.public_rounded, size:30),
                            border: OutlineInputBorder(
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: silverLakeBlue, width:1
                              )
                            )
                          ),
                      ),                                                                                                                                                                                                                                                                                                
                ),
                
              Container(
                    padding: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w) : EdgeInsets.symmetric(horizontal: 3.w),
                    margin: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: silverLakeBlue,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: 
                    isLoadingAdd == true ?
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0 : 2.w),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                    :
                    TextButton(
                      onPressed: () async{
                        if(selectedService == null){
                          showDialog(context: context, builder: ((context) => MsgDialog(msg: AppLocalizations.of(context)!.selectServicetoadd)));
                        }
                        else{
                        bool isExist = false;
      
                        if(selectedService != null){
                          for(ServiceModel s in addedServices){
                            if(s.id == selectedService!.id!){
                              isExist = true;
                            }
                          }
                          if(isExist == false){
                            setState(() {
                              isLoadingAdd = true;
                            });
                          num? r = await checkIfEligibleService( widget.appointment!.clientId!, selectedService!.serviceProviderServicesId!);
                          if(r != null && r != 0){
                            setState(() {
                              selectedService!.isEligible = true;
                              selectedService!.dis = r;
                            });
                          }
                          if(selectedService!.isEligible == true){
                          if(selectedService!.price == 0){
                            showDialog(context: context, builder: (context) => AddPriceDialog()).then((value) {
                              // print(value);
                              setState(() {
                                selectedService!.price = int.parse(value);
                                addedServices.add(selectedService!);
                                isLoadingAdd = false;
                              });
                            });
                          }
                          else{
                          setState(() {
                            addedServices.add(selectedService!);
                            isLoadingAdd = false;
                          });
                          
                        // print(addedServices.length);
                        // print(addedServices.first);
                        
                        }
                        
                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.notEligibleService));
                          }

                        

                          }
                        }
                        }
                      
                          
                      }, 
                      child: Text(AppLocalizations.of(context)!.add, style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 12.sp : 14.sp
                      ))
                    ),
                  ),
              Column(
                children: [
                  for(ServiceModel sm in addedServices)
                  if(sm.Is_Accepted == true)
                  InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (context) => TakeServiceDetails(service: sm));
                    },
                    child: Container(
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 85.w : 100.w,
                    color: lightBlue,
                    padding: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h) : EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
                    margin: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h) : EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
                    child:
                        Row(
                          children: [
                            Text(sm.name!, style: TextStyle(fontWeight: FontWeight.bold, color: silverLakeBlue),),
                            Spacer(),
                            // if(sm.isEligible! == true)
                            Text(sm.dis!.toString() + '%', style: TextStyle(
                              color: Colors.red
                            )),
                            //  if(sm.isEligible! == true)
                             SizedBox(
                              width: 3.w,
                            ),
                            Text((sm.price! - (sm.price! * (sm.dis!/100))).toString(), style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold),),
                            SizedBox(
                              width: 3.w,
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  addedServices.remove(sm);
                                });
                              },
                              child: Icon(Icons.delete, color: silverLakeBlue,))
                          ],
                        ),
                                    ),
                  )
                ],
              ),
              // const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w) : EdgeInsets.symmetric(horizontal: 3.w),
                    margin: EdgeInsets.all(5.w),
                    color: silverLakeBlue,
                    child:
                     isLoadingPay == true ?
                     Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0 : 2.w),
                       child: CircularProgressIndicator(
                        color: Colors.white,
                       ),
                     )
                     :
                     TextButton(
                      onPressed: () async{
                        
                        if(addedServices.isEmpty){
                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.noServicesSentence));
                        }
                        else{
                          setState(() {
                            isLoadingPay = true;
                          });
                        int amount = 0;
                        for(ServiceModel sm in addedServices){
                          if(sm.Is_Accepted == true){
                            amount = amount + sm.price!;
                          }
                         
                        }
      
                        // bool res = await getDiscount(double.parse(amount.toString()), "");
      
                        // Map map = new Map();
                        // map["id"] = 0;
                        // map["serviceProviderUserId"] = LoginScreen.isAdmin != "True" && LoginScreen.isAdmin != "true" ? BaseScreen.loggedInSP!.id! : LoginScreen.SPSAID;
                        // // map["serviceProviderBranchId"] = widget.branchId;
                        // map["serviceProviderId"] = LoginScreen.SPSAID;
                        // map["clientId"] = widget.appointment!.clientId!;
                        // map["amount"] = amount;
                        // map["discount"] = widget.appointment!.discount!;
                        // map["note"] = "";
                        // map["uploadedReciept"] = "";
                        // map["uploadedClientReciept"] = "";
                        // map["is_Accepted"] = false;
                        // map["is_Cancel"] = false;
                        // map["is_deleted"] = false;
       
                        // List<Map> mapList = [];
                        // for(ServiceModel s in addedServices){
                        //   if(s.Is_Accepted == true){
                        //   Map m = new Map();
                        //   m["is_deleted"] = false;
                        //   m["id"] = 0;

                        //   m["serviceProviderServicesId"] = s.id;
                        //   m["amount"] = s.price;
                        //   m["discount"] = s.dis;
                        //   mapList.add(m);
                        //   }
                        // }
                        // map["services"] = mapList;
                        // print(json.encode(map));
                        // int clientCardId = await AddClientCard(map);
                        // setState(() {
                        //   isLoadingPay = false;
                        // });
                        // log(clientCardId.toString()+' client card iddd');
                        sendWebSocketMessage(addedServices);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConfirmServices(amount: amount, name: widget.appointment!.client!.fullName, services: addedServices, cardId: widget.appointment!.id, clientId: widget.appointment!.clientId,)));
                      }
                      }, 
                      child: Text(AppLocalizations.of(context)!.pay, style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 13.sp : 14.sp
                      ))
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
     
class AddPriceDialog extends StatelessWidget {
  AddPriceDialog({super.key});
  TextEditingController value = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      contentPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:
        [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(15.0),
                child: Text(AppLocalizations.of(context)!.addServicePrice)),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 25.w : 65.w,
            child: TextFormField(
              controller: value,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
              prefix: Text(AppLocalizations.of(context)!.sar, style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold),),
              hintText: AppLocalizations.of(context)!.price,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: silverLakeBlue
                )
              )
            ),
            ),
          ),
          Container(
            padding: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w) : EdgeInsets.symmetric(horizontal: 3.w),
                    margin: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w : 5.w),
                    decoration: BoxDecoration(
                      color: silverLakeBlue,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
            child: TextButton(
              onPressed: (){
                Navigator.pop(context,value.text);
              }, 
              child: Text(AppLocalizations.of(context)!.addPrice, style: TextStyle(color: Colors.white),)))
        ],
      ),
    );
  }
}


class TakeServiceDetails extends StatefulWidget {
  TakeServiceDetails({super.key, this.service});
  ServiceModel? service;

  @override
  State<TakeServiceDetails> createState() => _TakeServiceDetailsState();
}

class _TakeServiceDetailsState extends State<TakeServiceDetails> {
  double? discountedPrice, savedAmount;

  @override
  void initState() {
    discountedPrice = widget.service!.price! - (widget.service!.price! * (widget.service!.dis!/100));
    savedAmount = widget.service!.price! - discountedPrice!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: BeveledRectangleBorder(),
      insetPadding: EdgeInsets.all(0),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 100.w,
        height: 25.h,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 15.w,
                  height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 15.w,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: 
                         widget.service!.image!.contains('/') || ! widget.service!.image!.contains('.')
                          ? 
                          Image.asset('assets/images/esnadTakaful.png')
                          : 
                          Image.network(swaggerImagesUrl + "Services/" + widget.service!.image!)
                        ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 50.w,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w :2.w,
                          ),
                          Text(
                            widget.service!.name!,
                            style: TextStyle(color: silverLakeBlue, 
                             fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                            fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ]),
                 Row(
                        children: [
                          Container(
                            width: 100.w,
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: TextScroll(
                              widget.service!.description!,
                              mode: TextScrollMode.bouncing,
                              velocity: Velocity(pixelsPerSecond: Offset(20, 0)),
                              delayBefore: Duration(milliseconds: 500),
                              pauseBetween: Duration(milliseconds: 500),
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                        ],
                      ),

                  Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                            child: Text(
                              AppLocalizations.of(context)!.actualPrice + ":",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                            child: Text(
                              widget.service!.price!.toString(),
                              style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                            child: Text(
                              AppLocalizations.of(context)!.currency,
                              style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                        ],
                      ),    

                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                            child: Text(
                              AppLocalizations.of(context)!.priceAfterDiscount + ":",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                            child: Text(
                              discountedPrice != null ? discountedPrice.toString() : '',
                              style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                            child: Text(
                              AppLocalizations.of(context)!.currency,
                              style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                        ],
                      ), 

                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                            child: Text(
                              AppLocalizations.of(context)!.youAreSaving + ":",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                            child: Text(
                              savedAmount != null ? savedAmount.toString() : '',
                              style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                            child: Text(
                              AppLocalizations.of(context)!.currency,
                              style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp),
                            ),
                          ),
                        ],
                      ), 
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}