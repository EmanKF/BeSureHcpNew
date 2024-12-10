import 'dart:io';
import 'dart:ui';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
// import 'dart:html' as html;
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Models/ServiceType.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/Components/TextFeildWidget.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Services/BranchesServices.dart';
import 'package:besure_hcp/Services/ServicesServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyAddService = GlobalKey();
  bool isLoading = false;
  int selectedServiceTypeId = 0;
  int selectedBranchId = 0;
  var imageBytes = '';
  String fileName = '';
  bool doneArabic = false;
  TextEditingController nameArabic = new TextEditingController();
  TextEditingController nameEnglish = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController discount = new TextEditingController();
  TextEditingController descriptionArabic = new TextEditingController();
  TextEditingController descriptionEnglish = new TextEditingController();
  File? serviceImage;
  var serviceImageWeb;
  int sNb = 0;

  @override
  void initState() {
    diplayTutorial();
    super.initState();
  }

  diplayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('AddServiceDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('AddServiceDisplayedBefore',true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.addNewService)
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: 100.w,
          child: Column(
            children: [
              SizedBox(
                height: 0.1.h,
              ),
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
                          //       serviceImage = File(_imageUrl);
                          //       imageBytes = _imageBytes;
                          //         fileName = file.name;
                          //     });
                            
                          //   }
                         
                        }
                        else{

                          if(file.path != null){
                           
                            setState(() {
                              serviceImage = File(file.path!);
                            });
                          }

                        }
                      }    
                  //------------------------
                  // if(!kIsWeb){
                  //  final ImagePicker picker = ImagePicker();
                  // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  // if(image != null){
                  // setState(() {
                  //   serviceImage = File(image!.path);
                  // });
                  // }
                  // }
                  // else if(kIsWeb){
                  //   var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
                  //   if(pickedFile != null){
                  //   var img = await pickedFile.readAsBytes();
                  //   setState(() {
                  //     serviceImageWeb = img;
                  //   });
                  //   }
                  // }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 15.w : 32.w,
                  height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 15.w : 32.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400
                    ),
                    shape: BoxShape.circle
                  ),
                  child: 
                  kIsWeb? 
                      ClipRRect(
                        borderRadius: BorderRadius.circular(300.0),
                        child: serviceImage != null ? Image.network(
                          serviceImage!.path,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width/3,
                          // height: 60.h,
                        ) 
                        :
                        Image.asset("assets/images/noImageIcon.jpg")
                      )
                      :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(300.0),
                        child: serviceImage != null ? Image.file(
                          serviceImage!,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: 60.h,
                        )
                        :
                        Image.asset("assets/images/noImageIcon.jpg")
                      )
                  //  kIsWeb ? 
                  // ClipRRect( 
                  //   child: serviceImageWeb == null ? Image.asset("assets/images/noImageIcon.jpg")
                  //   :Image.memory(serviceImageWeb!),
                  //   borderRadius: BorderRadius.circular(300.0),
                  // )
                  // :
                  // ClipRRect( 
                  //   child: serviceImage == null ? Image.asset("assets/images/noImageIcon.jpg")
                  //   :Image.file(serviceImage!),
                  //   borderRadius: BorderRadius.circular(300.0),
                  // ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              // if(doneArabic == false)
                TextFeildWidget(controller: nameArabic, hint: 'إسم الخدمة', maxLines: 1, icon: Icon(Icons.location_city_outlined)),
              // if(doneArabic == true)
                TextFeildWidget(controller: nameEnglish, hint: 'Service Name', maxLines: 1, icon: Icon(Icons.location_city_outlined)),
              TextFeildWidget(controller: price, hint: AppLocalizations.of(context)!.price, maxLines: 1, icon: Icon(Icons.price_check),),
              TextFeildWidget(controller: discount, hint: AppLocalizations.of(context)!.discount, maxLines: 1, icon: Icon(Icons.percent),),
              Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                   width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                   child: DropdownButtonFormField( 
                          items: BaseScreen.allServiceTypes.map((ServiceType value){
                            return new DropdownMenuItem<String>(
                              value: value.serviceId.toString(),
                              child: Container(
                                width: 160,
                                child: Text(value.name!, style: TextStyle(fontSize: 12),)),
                            );
                          }).toList(),
                          validator: (val){
                             if(val == null)
                             return 'Select Service Type';
                             else return null;
                          },
                          onChanged: (v){
                            // print(v.toString());
                            setState(() {
                              selectedServiceTypeId = int.parse(v.toString());
                            });                           
                          },

                            hint: Text(AppLocalizations.of(context)!.serviceType, style:  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade900
                                )
                            ),
                            decoration: InputDecoration( 
                              prefixIcon: Icon(Icons.apartment_rounded, size:30),
                              border: OutlineInputBorder(

                              )
                           ),
                        ),                                                                                                                                                                                                                                                                                                
                 ),  

              Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                   width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                   child: DropdownButtonFormField( 
                          items: BranchesScreen.approvedBranches.map((Branch value){
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
                          onChanged: (v) async{
                            // print(v.toString());  
                            setState(() {
                              selectedBranchId = int.parse(v.toString());
                            });                      
                          },

                            hint: Text(AppLocalizations.of(context)!.branch, style:  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade900
                                )
                            ),
                            decoration: InputDecoration( 
                              prefixIcon: Icon(Icons.apartment_rounded, size:30),
                              border: OutlineInputBorder(

                              )
                           ),
                        ),                                                                                                                                                                                                                                                                                                
                 ),
              // if(doneArabic == false)
                TextFeildWidget(controller: descriptionArabic, hint: 'الوصف', maxLines: 3, icon: Icon(Icons.description_outlined),),
              // if(doneArabic == true)
                TextFeildWidget(controller: descriptionEnglish, hint: 'Description', maxLines: 3, icon: Icon(Icons.description_outlined),),
              SizedBox(
                height: 1.h,
              ),
              
              // Spacer(),
      
              Container(
                    key: keyAddService,
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.h : 0),
                    decoration: BoxDecoration(
                    color: silverLakeBlue,
                    borderRadius: BorderRadius.circular(8.0)),
                    child: isLoading == false ?
                    TextButton(
                      onPressed: () async {
                        

                        // if(doneArabic == false){
                        if(nameArabic.text.isNotEmpty && price.text.isNotEmpty && descriptionArabic.text.isNotEmpty){
                        Map map = new Map();
                        map['servicesId'] = selectedServiceTypeId;
                        map["name"] = nameArabic.text;
                        map["name_en"] = nameEnglish.text;
                        map["image"] = "string";
                        map["description"] = descriptionArabic.text;
                        map["description_en"] = descriptionEnglish.text;
                        map['is_deleted'] =  false;
                        map['is_Approved'] = false;
                        map['price'] = price.text;
                        map['discount'] = double.parse(discount.text);
                        map['code'] = "string";
                        map['id'] = 0;
                        map['languageId'] = 1;
                        map['languageId_en'] = 2;
                        map['serviceProviderId'] = BaseScreen.loggedInSP!.id!;
                        map['serviceProviderServicesId'] = 0;
                        map['serviceProviderBranchesId'] = selectedBranchId;
                        map['reason'] = 'reason';
                        map['note'] = 'note';
                        map['is_Added_By_Admin'] = true; 
                         
                        int s = await addService(map);
                        setState(() {
                          sNb = s;
                        });

                        if(sNb != 0){
                          // setState(() {
                          //   doneArabic = true;
                          // });
                          if(serviceImage != null){
                          String addImageRes = await addServiceImage(serviceImage!, sNb, imageBytes, fileName);
                          // print(addImageRes);
                          }
                          Observable.instance.notifyObservers([
                          "_ServicesProvidedScreenState",
                          ], notifyName : "update");
                          Navigator.pop(context);
                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.serviceAddedSuccessfully));
                        }
                        else{
                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.failedToAddService));
                        }
                      }
                      else{
                        showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.allFieldsAreRequired));
                      }
                      // }

                      // else if(doneArabic == true){
                      //   if(nameEnglish.text.isNotEmpty && price.text.isNotEmpty && descriptionEnglish.text.isNotEmpty){
                      //   Map map = new Map();
                      //   map['servicesId'] = selectedServiceTypeId;
                      //   map["name"] = nameEnglish.text;
                      //   map["image"] = "string";
                      //   map["description"] = descriptionEnglish.text;
                      //   map['is_deleted'] =  false;
                      //   map['is_Approved'] = false;
                      //   map['price'] = int.parse(price.text);
                      //   map['discount'] = double.parse(discount.text);
                      //   map['code'] = "string";
                      //   map['id'] = 0;
                      //   map['languageId'] = 2;
                      //   map['serviceProviderId'] = BaseScreen.loggedInSP!.id!;
                      //   map['serviceProviderServicesId'] = sNb;
                      //   map['serviceProviderBranchesId'] = selectedBranchId;
                      //   map['reason'] = 'reason';
                      //   map['note'] = 'note';
                      //   map['is_Added_By_Admin'] = true; 

                      //   int res = await addService(map);
      
                      //   if(res != 0){
                      //     if(serviceImage != null){
                      //     String addImageRes = await addServiceImage(serviceImage!, res);
                      //     // print(addImageRes);
                      //     }
                      //     Observable.instance.notifyObservers([
                      //     "_ServicesProvidedScreenState",
                      //     ], notifyName : "update");
                      //     Navigator.pop(context);
                      //     showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.serviceAddedSuccessfully));
                      //   }
                      //   else{
                      //     showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.failedToAddService));
                      //   }
                      // }
                      // else{
                      //   showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.allFieldsAreRequired));
                      // }
                      // }

                      },
                      child: Text(
                        AppLocalizations.of(context)!.addService,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18))
                    )
                    :
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0.8.h),
                      alignment: Alignment.center,
                      width: 10.w,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                   )
              ),
              SizedBox(
                height: 2.h
              )
            ],
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
      // textSkip: SplashScreen.langId! == 1 ? "تخطي" : "SKIP", 
      skipWidget: Row(mainAxisAlignment: MainAxisAlignment.end,children: [Text(SplashScreen.langId! == 1 ? "تخطي" : "SKIP")]),
      // alignSkip: SplashScreen.langId! == 1 ? Alignment.topLeft : Alignment.topRight,
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
        identify: "keyAddService",
        keyTarget: keyAddService,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.addServiceKeySentenceInAddServiceScreen,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
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