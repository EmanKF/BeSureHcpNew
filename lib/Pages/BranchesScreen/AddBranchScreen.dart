import 'dart:convert';
import 'dart:developer';
// import 'dart:html' as html;
import 'dart:io';
import 'dart:ui';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/Components/AddGoogleMapsAdress.dart';
import 'package:besure_hcp/Pages/BranchesScreen/Components/TextFeildWidget.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Services/BranchesServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen({super.key});

  @override
  State<AddBranchScreen> createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyAddBranch = GlobalKey();
  bool isLoading = false;
  var imageBytes = '';
  String fileName = ''; 
  TextEditingController phone = new TextEditingController();
  TextEditingController nameArabic = new TextEditingController();
  TextEditingController addressArabic = new TextEditingController();
  TextEditingController descriptionArabic = new TextEditingController();
  TextEditingController nameEnglish = new TextEditingController();
  TextEditingController addressEnglish = new TextEditingController();
  TextEditingController descriptionEnglish = new TextEditingController();
  TextEditingController specialityArabic = new TextEditingController();
  TextEditingController specialityEnglish = new TextEditingController();
  TextEditingController websiteUrl = new TextEditingController();

  File? branchImage;
  var branchImageWeb;
  // bool doneArabic = false;
  int branchNb = 0;
  LatLng latLng = LatLng(0, 0);

  @override
  void initState() {
    diplayTutorial();
    super.initState();
  }

  diplayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('AddBranchDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('AddBranchDisplayedBefore',true);
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.addNewBranch.toString())
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: 100.w,
          child: Column(
            children: [
              SizedBox(
                height: 1.h,
              ),
              branchImage != null ?
              Container(
                child: 
                kIsWeb? 
                      ClipRRect(
                        borderRadius: BorderRadius.circular(300.0),
                        child: branchImage != null ? Image.network(
                          branchImage!.path,
                          fit: BoxFit.fill,
                          // width: MediaQuery.of(context).size.width/3,
                          height: 10.h,
                        ) 
                        :
                        Image.asset("assets/images/noImageIcon.jpg")
                      )
                      :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(300.0),
                        child: branchImage != null ? Image.file(
                          branchImage!,
                          fit: BoxFit.fill,
                          width: 150,
                          height: 150,
                        )
                        :
                        Image.asset("assets/images/noImageIcon.jpg"),
                       ) )
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
                          //       print('eeeeeeeeeeeeeeeeeeeeeeeeeeeewwwwwe');
                          //       branchImage = File(_imageUrl);
                          //       imageBytes = _imageBytes;
                          //         fileName = file.name;
                          //     });
                          //     print(branchImage);
                          //     print('eeeeeeeeeeeeeeeeeeeeeeeeeeeee');
                          //   }
                         
                        }
                        else{

                          if(file.path != null){
                           
                            setState(() {
                              branchImage = File(file.path!);
                            });
                            print(branchImage);
                          }

                        }
                      }    


                  //-------------------
                  // if(!kIsWeb){
                  //  var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
                  //   if(pickedFile != null){
                  //   File img = File(pickedFile.path);
                  //   setState(() {
                  //     branchImage = img;
                  //   });
                  //   }
                  // }
                  // else if(kIsWeb){
                    
                  //   var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
                  //   if(pickedFile != null){
                  //   var img = await pickedFile.readAsBytes();
                  //   setState(() {
                  //     branchImageWeb = img;
                  //   });
                  //   }
                  // }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 15.w : 35.w,
                  height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 15.w : 35.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400
                    ),
                    shape: BoxShape.circle
                  ),
                  child: Image.asset("assets/images/noImageIcon.jpg"),
                  
                      )
                  // kIsWeb ? 
                  // ClipRRect( 
                  //   child: branchImageWeb == null ? Image.asset("assets/images/noImageIcon.jpg")
                  //   :Image.memory(branchImageWeb!),
                  //   borderRadius: BorderRadius.circular(300.0),
                  // )
                  // :
                  // ClipRRect( 
                  //   child: branchImage == null ? Image.asset("assets/images/noImageIcon.jpg")
                  //   :Image.file(branchImage!),
                  //   borderRadius: BorderRadius.circular(300.0),
                  // )
                ),
              
              SizedBox(
                height: 3.h,
              ),
              // if(doneArabic == false)
                TextFeildWidget(controller: nameArabic, hint: 'إسم الفرع', maxLines: 1, icon: Icon(Icons.location_city_outlined)),
              // if(doneArabic == true)
                TextFeildWidget(controller: nameEnglish, hint: 'Branch Name', maxLines: 1, icon: Icon(Icons.location_city_outlined)),
              // if(doneArabic == false)
                TextFeildWidget(controller: addressArabic, hint: 'العنوان', maxLines: 1, icon: Icon(Icons.edit_location_outlined),),
              // if(doneArabic == true)
                TextFeildWidget(controller: addressEnglish, hint: 'Address', maxLines: 1, icon: Icon(Icons.edit_location_outlined),),
                
                TextFeildWidget(controller: phone, hint: AppLocalizations.of(context)!.phoneNumber, maxLines: 1, icon: Icon(Icons.phone),),
              // if(doneArabic == false)
                TextFeildWidget(controller: descriptionArabic, hint: 'الوصف', maxLines: 3, icon: Icon(Icons.description_outlined),),
              // if(doneArabic == true)
                TextFeildWidget(controller: descriptionEnglish, hint: 'Description', maxLines: 3, icon: Icon(Icons.description_outlined),),
              SizedBox(
                height: 1.h,
              ),
              
              // Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: grey
                  )
                ),
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                child: TextButton(
                  
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(grey)
                  ),
                  onPressed: () async{
                    LocationPermission permission = await Geolocator.requestPermission();
                    Position? position = await Geolocator.getCurrentPosition();
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => AddGoogleMapsAddress(lat: position.latitude, long: position.longitude)))).then((value) {
                      if(value != null){
                      setState(() {
                        latLng = value;
                      });
                      print(latLng.latitude.toString() + latLng.longitude.toString());
                      }
                    });
                  }, 
                  child: 
                  latLng.latitude == 0 && latLng.longitude == 0 ? Row(
                    children: [
                       Icon(Icons.add_location_alt_outlined),
                       SizedBox(width: 3.w),
                      Text(AppLocalizations.of(context)!.selectLocation),
                    ],
                  ) :
                  Row(
                    mainAxisAlignment: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? MainAxisAlignment.start : MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.add_location_alt_outlined),
                      Row(
                        children: [
                          Text(AppLocalizations.of(context)!.locationOnMap),
                          Text(' :'),
                        ],
                      ),
                      Text(latLng.latitude.toStringAsFixed(3) + " , " + latLng.longitude.toStringAsFixed(3)),
                    ],
                  )),
              ),
          
              TextFeildWidget(controller: websiteUrl, hint: AppLocalizations.of(context)!.websiteUrl, maxLines: 1, icon: Icon(Icons.web_outlined),),

              // if(doneArabic == false)
                TextFeildWidget(controller: specialityArabic, hint: 'الخاصية', maxLines: 1, icon: Icon(Icons.wb_iridescent_outlined)),
              // if(doneArabic == true)
                TextFeildWidget(controller: specialityEnglish, hint: 'Speciality', maxLines: 1, icon: Icon(Icons.wb_iridescent_outlined)),
              
              
              Container(
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(AppLocalizations.of(context)!.specialitySentence, style: TextStyle(
                  color: grey,
                  fontSize: 12
                ))
              ),

              SizedBox(
                height: 2.h,
              ),
              
      
              Container(
                    key: keyAddBranch,
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                    decoration: BoxDecoration(
                    color: silverLakeBlue,
                    borderRadius: BorderRadius.circular(12.0)),
                    child: isLoading == false ?
                    TextButton(
                      onPressed: () async {
                        
                        setState(() {
                          isLoading = true;
                        });

                        if(nameArabic.text.isNotEmpty && phone.text.isNotEmpty && addressArabic.text.isNotEmpty && descriptionArabic.text.isNotEmpty){
                        if(phone.text.isNotEmpty && phone.text.length != 10){
                          setState(() {
                          isLoading = false;
                        });
                           showDialog(context: context, builder: (context) => MsgDialog(msg: SplashScreen.langId == 1 ? 'يجب أن يحتوي رقم الهاتف على 10 أرقام' : 'The phone number must be 10 numbers'));
                        }
                        else{
                        Map map = new Map();
                        map["name"] = nameArabic.text;
                        map["name_en"] = nameEnglish.text;
                        map["image"] = "string";
                        map["description"] = descriptionArabic.text;
                        map["description_en"] = descriptionEnglish.text;
                        map['mobile'] = phone.text;
                        map['address'] = addressArabic.text;
                        map['address_en'] = addressEnglish.text;
                        map['long'] = latLng.longitude;
                        map['lat'] = latLng.latitude;
                        map['is_deleted'] =  false;
                        map['is_Approved'] = false;
                        map['id'] = 0;
                        map['languageId'] = 1;
                        map['serviceProviderId'] = BaseScreen.loggedInSP!.id!;
                        map['serviceProviderBranchesId'] = 0;
                        map['websitUrl'] = websiteUrl.text != null ? websiteUrl.text : '';
                        map['speciality'] = specialityArabic.text != null ? specialityArabic.text : '';
                        map['speciality_en'] = specialityEnglish.text != null ? specialityEnglish.text : '';
                        map['cityId'] = 1;
                        // Branch b = new Branch(id: 0, address: address.text, cityId: 1, description: description.text, image: branchImage!.path, is_Approved: false, is_deleted: false, languageId: 1, lat: 0.0, long: 0.0, mobile: phone.text, name:  name.text, serviceProviderId: BaseScreen.loggedInSP!.id!, serviceProviderBranchesId: 1);
                        log(json.encode(map));
                        int bn = await addNewBranch(map);
                        setState(() {
                          branchNb = bn;
                        });
                        if(branchNb != 0){
                          
                          if(branchImage != null){
                          String addImageRes = await addBranchImage(branchImage!, branchNb, imageBytes, fileName);
                          print(addImageRes);
                          }
                          setState(() {
                            isLoading = false;
                          });
                          Observable.instance.notifyObservers([
                          "_BranchesScreenState",
                          ], notifyName : "update");
                          Navigator.pop(context);
                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.branchAddedSuccessfully));
                        }
                        else{
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.failedToAddBranch));
                        }
                        }
                      }
                      else{
                        setState(() {
                            isLoading = false;
                          });
                        showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.allFieldsAreRequired));
                      }
      
            
                      },
                      child: Text(
                        AppLocalizations.of(context)!.addBranch,
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
                height: 2.h,
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
        identify: "keyAddBranch",
        keyTarget: keyAddBranch,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.addBranchKeySentenceInAddBranchScreen,
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