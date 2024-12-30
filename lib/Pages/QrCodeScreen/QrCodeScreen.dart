import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Functions/OneSignalWeb.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/configure_ws.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/ScanQrObject.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/QrCodeScreen/dialogAnimation.dart';
import 'package:besure_hcp/Pages/TakeServicesScreens/TakeServicesScreen.dart';
import 'package:besure_hcp/Services/TakeServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class QrCodeScreen extends ConsumerStatefulWidget {
  const QrCodeScreen({super.key});

  @override
  ConsumerState<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends ConsumerState<QrCodeScreen> {
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyQrScanner = GlobalKey();
  GlobalKey keyId = GlobalKey();
  Barcode? result;
  bool isScanning = true;
  int c=0;
  String qrVal = '';
  bool isLoading = false;
  int bId = BaseScreen.loggedInSP!.branchId!;
  List<Branch> branches = [];
  int selectedBranch = 0;
  TextEditingController verificationIdController = new TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController controller = MobileScannerController(
                        detectionSpeed: DetectionSpeed.normal,
                        facing: CameraFacing.back,
                        detectionTimeoutMs: 500,
                      );
 
   @override
  void initState() {
    controller.stop();
    controller.start();
    if(bId == 0){
     branches = BranchesScreen.approvedBranches;
    }
    if(LoginScreen.isAdmin != "true" && LoginScreen.isAdmin != "True"){
      diplayTutorial();
    }
    super.initState();
    ref.read(websocketProvider).connect(ref);
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  

  diplayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('ScanQrDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ScanQrDisplayedBefore',true);
  }


  checkIfEl(vId) async{
     ScanQrObject sObj = await CheckVerificationIdIfEligible(vId);
     if(sObj.clientId == ''){
        showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.notSubscriber));
       await Future.delayed(
        Duration(seconds: 5)
       );
       setState(() {
        isScanning = true;
      });
      }
      else if( sObj.clientId != ''){
        setState(() {
          verificationIdController.text = vId;
        });
        showDialog(context: context, builder: (context) => DialogAnimation(sObj: sObj));
        // Navigator.push(context, MaterialPageRoute(builder: ((context) => TakeServicesScreen(sObj: sObj))));
      }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          width: 100.w,
          height: 100.h,
          color: lightBlue,
          child: 
          // LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True"
          // ?
          //  Column(
          //     children: [
          //        SizedBox(
          //           width: MediaQuery.of(context).size.width,
          //           height: 25.h,
          //           child: SvgPicture.asset('assets/images/bgHue.svg',
          //               fit: BoxFit.fill, color: silverLakeBlue)),
          //       SizedBox(
          //         height: 15.h,
          //       ),
          //      Container(
          //       margin: EdgeInsets.all( MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.w : 15.w),
          //       child: Text(AppLocalizations.of(context)!.qrSentence,
          //       textAlign: TextAlign.justify,
          //       style: TextStyle(
          //         fontWeight: FontWeight.w500,
          //         color: grey,
          //         fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.sp : 12.sp
          //       ),
          //       ))
          //     ],
          //   )
          // :
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  // SizedBox(
                  //     width: MediaQuery.of(context).size.width,
                  //     height: 25.h,
                  //     child: SvgPicture.asset('assets/images/bgHue.svg',
                  //         fit: BoxFit.fill, color: silverLakeBlue)),
                  SizedBox(
                    height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 10.h : 20.h,
                  ),
                 
                  Container(
                    alignment: Alignment.center,
                    child: Text(AppLocalizations.of(context)!.scanSentence, 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: silverLakeBlue,
                      fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                    )),
                  ),
                    
                   SizedBox(
                    height: 4.h,
                  ),
                  if (!kIsWeb)
                  Container(
                    key: keyQrScanner,
                    width: 60.w,
                    height: 60.w,
                    child: MobileScanner(
                      controller: controller,
                       overlay: Lottie.asset(
                            'assets/animations/qrscan.json',
                            width: 60.w,
                            height: 60.w,
                          ),
                       
                    // fit: BoxFit.contain,
                    onDetect: (capture) {
                     if (isScanning) {
                      // print('tihsssss iscapturee   '+capture.barcodes.first.rawValue.toString());
                      // final List<Barcode> barcodes = capture.barcodes;
                      // final Uint8List? image = capture.image;
                      // for (final barcode in barcodes) {
                      //   debugPrint('Barcode found! ${barcode.rawValue}');
                      // }
                       setState(() {
                        isScanning = false;
                        // qrVal = capture.barcodes.first.rawValue!;
                      });
                      checkIfEl(capture.barcodes.first.rawValue);
                    }
                    },
                    errorBuilder: (context, error, widget) {
         return Container(child: Text('mm'),);
  }    ,
                  ),
                  ),
                  // if (result != null)
                  //         Text(
                  //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  //       else
                  //         const Text('Scan a code'),
                  // Container(
                  //   width: 60.w,
                  //   height: 60.w,
                  //   decoration:
                  //       BoxDecoration(shape: BoxShape.circle, color: silverLakeBlue),
                  //   child: Icon(
                  //     Icons.qr_code_rounded,
                  //     color: Colors.white,
                  //     size: 40.w,
                  //   ),
                  // ),
                  SizedBox(
                    height: 5.h,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => ScanQrCode()));
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         AppLocalizations.of(context)!.scanPatientsQr + ' ',
                  //         style: TextStyle(fontSize: 12.sp),
                  //       ),
                  //       Icon(
                  //         Icons.arrow_forward_outlined,
                  //         size: 5.w,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Container(
                    key: keyId,
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 80.w,
                    child: TextFormField(
                      controller: verificationIdController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.numbers_sharp, color: silverLakeBlue,),
                        hintText: AppLocalizations.of(context)!.verificationId,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: silverLakeBlue)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: silverLakeBlue, width: 1),
                        ),                
                      ),
                    )),
                  
                  
                      if(bId == 0)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                           width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 80.w,
                           child: DropdownButtonFormField( 
                           
                                  items: branches.map((Branch value){
                                    return new DropdownMenuItem<String>(
                                      value: value.serviceProviderBranchesId.toString(),
                                      child: Container(
                                        width: 160,
                                        child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                                    );
                                  }).toList(),
                                  validator: (val){
                                     if(val == null)
                                     return 'Select Branch';
                                     else return null;
                                  },
                                  onChanged: (val){
                                         print(val.toString());
                                         setState(() {
                                           selectedBranch = int.parse(val.toString());
                                         });
                                  },
                
                                    hint: Text(SplashScreen.langId == 2 ? 'Select branch' : 'اختر فرع', style:  TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: silverLakeBlue
                                        )
                                    ),
                                    decoration: InputDecoration( 
                                      prefixIcon: Icon(Icons.apartment_rounded, size:30),
                                      border: OutlineInputBorder(
                
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: silverLakeBlue, width: 1),
                                    ),
                                   ),
                                ),                                                                                                                                                                                                                                                                                                
                         ),

                      //  SizedBox(
                      //   height: 1.h,
                      // ), 
                  
                      Container(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0.5.h : 0),
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 80.w,
                        decoration: BoxDecoration(
                            color: silverLakeBlue,
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: isLoading == false ?
                        TextButton(
                            onPressed: () async {
                              if(selectedBranch != 0){
                                if(verificationIdController.text.isEmpty && qrVal == ''){
                                  showDialog(context: context, builder: (context) => MsgDialog(msg: 'Scan the Qrcode of the client or add his verification Id'));
                                }
                                else{
                                if(verificationIdController.text.isNotEmpty ){
                                  setState(() {
                                    isLoading = true;
                                  });
                                 
                                  ScanQrObject sObj = await CheckVerificationIdIfEligible(verificationIdController.text);
                                  print(sObj.clientId);
                                  if(sObj.clientId == ''){
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.notSubscriber));
                                  }
                                  else if( sObj.clientId != ''){
                                    var onesignalId = '';
                                    if(!kIsWeb){
                                      onesignalId = await OneSignal.User.getOnesignalId() ?? 'N/A';
                                    }
                                    else if(kIsWeb){
                                      onesignalId = await getOneSignalPlayerId();
                                      log(onesignalId);
                                    }
                                    final message = {
                                      "Action":"ClientCardRequest",
                                      "SP":LoginScreen.SPSAID,
                                      "Client":"",
                                      "Message":"string",
                                      "DeviceId":onesignalId,
                                      "Data":[]};

                                    ref.read(websocketProvider).sendMessage(json.encode(message));

                                     Navigator.push(context, MaterialPageRoute(builder: ((context) => TakeServicesScreen(sObj: sObj, branchId: selectedBranch,))));
                                  }
                                }
                                    setState(() {
                                      isLoading = false;
                                    });
                              }
                              }
                              else{
                                  showDialog(context: context, builder: (context) => MsgDialog(msg: 'you must select the current branch'));
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.next,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18)),
                                SizedBox(
                                  width: 3.w
                                ),        
                                Lottie.asset(
                                  'assets/animations/nextAnimation.json',
                                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 5.w,
                                  height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 5.w,
                                ),        
                              ],
                            ))
                                    :
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0 : 0.8.h),
                                      alignment: Alignment.center,
                                      width: 10.w,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      
                ],
              ),
            ),
          ),
      ),
    );
  }
   void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: azureishBlue,
      skipWidget: Row(mainAxisAlignment: MainAxisAlignment.end,children: [Text(SplashScreen.langId! == 1 ? "تخطي" : "SKIP")]),
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    if(!kIsWeb){
    targets.add(
      TargetFocus(
        identify: "keyQrScanner",
        keyTarget: keyQrScanner,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.qrkeySentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyId",
        keyTarget: keyId,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.verificationIdKeySentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              );
            },
          ),
        ],
      ),
    );
    }
    else{
      targets.add(
      TargetFocus(
        identify: "keyId",
        keyTarget: keyId,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.verificationIdKeySentenceWeb,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              );
            },
          ),
        ],
      ),
    );
    }
    return targets;
  }
}
