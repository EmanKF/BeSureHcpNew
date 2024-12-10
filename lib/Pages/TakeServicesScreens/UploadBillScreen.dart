// import 'dart:html' as html;
import 'dart:developer';
import 'dart:io';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:http/http.dart' as http;
// import 'dart:html' as html;
import 'dart:ui';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Services/TakeServices.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';


class UploadBillScreen extends StatefulWidget {
  const UploadBillScreen({super.key, this.cardId});

  final int? cardId;

  @override
  State<UploadBillScreen> createState() => _UploadBillScreenState();
}

class _UploadBillScreenState extends State<UploadBillScreen> {
  File? billImage;
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey uploadkey = GlobalKey();
  GlobalKey donekey = GlobalKey();
  late Uint8List imageFile;
  // bool imageAvailable = false;

  @override
  void initState() {
    displayTutorial();
    super.initState();
  }

   displayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('UploadBillDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  //  @override
  // void dispose() {
  //   // Revoke the object URL to free up memory
  //   if (billImage != null) {
  //     html.Url.revokeObjectUrl(billImage!.path);
  //   }
  //   super.dispose();
  // }

  // Future<void> uploadImage(File file, String fileName) async{
  //   print('card id:::::'+widget.cardId.toString());
  //   var uri = Uri.parse(swaggerApiUrl + "ClientCard/UploadBillServiceProvider?CardId=" + widget.cardId.toString());
  //   var request = http.MultipartRequest('POST', uri);
  //   request.headers.addAll({"Authorization" : "Bearer " + LoginScreen.token});
  //   request.headers.addAll({"content-type": "multipart/form-data"});
  //   request.files.add(
  //     await http.MultipartFile.fromPath('Bill', file.path)
  //   );
  //   var response = await request.send();
  //   if(response.statusCode == 200){
  //     print('uploaded');
  //   }
  //   else{
  //     print('failed');
  //     final respStr = await response.stream.bytesToString();
  //     print(respStr);
  //   }
  // }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('UploadBillDisplayedBefore',true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: grey,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.uploadBill, 
        style: TextStyle(
          color: silverLakeBlue, 
          fontWeight: FontWeight.bold,
          fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
          fontSize: 20 ),),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(AppLocalizations.of(context)!.uploadBillSentence, style: TextStyle(
                color: silverLakeBlue
              ),),
            ),
            SizedBox(
              height: 2.h
            ),
            Container(
              key: uploadkey,
              // width: 75.w,
              height: 55.h,
              child: billImage != null ?
              Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                      kIsWeb? 
                      Image.network(
                        billImage!.path,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width/3,
                        // height: 60.h,
                      )
                      :
                      Image.file(
                        billImage!,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: 60.h,
                      )
                      ,
                    )
                  :
                  InkWell(
                    onTap: () async{
                      FilePickerResult? result= await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['jpg','png','jpeg']);
                      if(result != null){
                        print('bteeeee5');
                          print(result.files.first.name);
                        PlatformFile file = result.files.first;

                        if(kIsWeb == true){
                          // var _imageBytes, _imageUrl;

                          //   if(file.bytes != null){
                          //     _imageBytes = file.bytes; // Store the image bytes
                          //     _imageUrl = html.Url.createObjectUrlFromBlob(html.Blob([file.bytes!]));
                          //     setState(() {
                          //       billImage = File(_imageUrl);
                          //     });
                          //     http.MultipartRequest request = http.MultipartRequest("POST",
                          //     Uri.parse(swaggerApiUrl + "ClientCard/UploadBillServiceProvider?CardId=" + widget.cardId.toString()),
                              
                          //   );
                          //   request.headers.addAll({"Authorization" : "Bearer " + LoginScreen.token});
                          //   // request.headers.addAll({"content-type": "multipart/form-data"});
                          //   request.files.add(http.MultipartFile.fromBytes('Bill', _imageBytes, filename: file.name));
                            
                          //   var response = await request.send();
                          //   final respStr = await response.stream.bytesToString();
                          //   print("resultt: ");
                          //   print(respStr);
                          //   }
                         
                        }
                        else{

                          if(file.path != null){
                           
                            setState(() {
                              billImage = File(file.path!);
                            });
                            // await uploadBill(widget.cardId!,File(file.path!));
                            http.MultipartRequest request = http.MultipartRequest(
                              "POST",
                              Uri.parse(swaggerApiUrl + "ClientCard/UploadBillServiceProvider?CardId=" + widget.cardId.toString()),
                              
                            );
                            request.headers.addAll({"Authorization" : "Bearer " + LoginScreen.token});
                            request.headers.addAll({"content-type": "multipart/form-data"});
                            request.files.add(await http.MultipartFile.fromPath("Bill", file.path!));
                            var response = await request.send();
                            final respStr = await response.stream.bytesToString();
                            print("resultt: ");
                            print(respStr);
                          }

                        }
                      }
                      // if (!kIsWeb){
                      //   var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
                      //   if(pickedFile != null){
                      //   File img = File(pickedFile.path);
                      //   setState(() {
                      //     billImage = img;
                      //   });
                      //   }
                      //   String res = await uploadBill(widget.cardId!, billImage!);
                      //   // print(res);
                      // }
                      // else{
                      //   // final image = await ImagePickerWeb.getImageAsBytes();
                      //   // setState(() {
                      //   //   imageFile = image!;
                      //   //   imageAvailable = true;
                      //   // });
                      // }
                    },
                    child: Container(
                      child: Lottie.asset(
                              'assets/animations/uploadBillAnimation.json',
                              width: 75.w,
                              height: 60.w,
                            ),
                    ),
                  )
                  
            ),
            SizedBox(
              height: 1.h,
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 2.w),
            //   decoration: BoxDecoration(
            //     color: silverLakeBlue,
            //     borderRadius: BorderRadius.circular(5.0)
            //   ),
            //   child: TextButton(
            //     onPressed: () async{
            //        var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
            //        if(pickedFile != null){
            //        File img = File(pickedFile.path);
            //        setState(() {
            //          billImage = img;
            //        });
            //       }
            //       String res = await uploadBill(widget.cardId!, billImage!);
            //       print(res);
            //     }, 
            //     child: Text(AppLocalizations.of(context)!.uploadBill, style: TextStyle(
            //       color: Colors.white
            //     ),)),
            // ),
            // SizedBox(
            //   height: 1.h,
            // ),
            Container(
              key: donekey,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                color: silverLakeBlue,
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: TextButton(
                onPressed: () async{
                  Navigator.pop(context);
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BaseScreen(billUploaded: true)));
                }, 
                child: Text(AppLocalizations.of(context)!.done, style: TextStyle(
                  color: Colors.white
                ),)),
            )
          ]
        )
      )  
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
      targets.add(
      TargetFocus(
        identify: "uploadkey",
        keyTarget: uploadkey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.uploadkey,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "donekey",
        keyTarget: donekey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.donekey,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.h),
                ],
              );
            },
          ),
        ],
      ),
    );
    return targets;
  }    
}