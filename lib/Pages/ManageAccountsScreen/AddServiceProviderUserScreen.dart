import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Models/City.dart';
import 'package:besure_hcp/Models/Gender.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/ManageAccountsScreen/Components/TextFeildWidget.dart';
import 'package:besure_hcp/Services/ServiceProviderUserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AddServiceProviderUserScreen extends StatefulWidget {
  const AddServiceProviderUserScreen({super.key});

  @override
  State<AddServiceProviderUserScreen> createState() => _AddServiceProviderUserScreenState();
}

class _AddServiceProviderUserScreenState extends State<AddServiceProviderUserScreen> {
  bool isLoading = false;
  int selectedGenderId = 0;
  int selectedBranchId = 0;
  TextEditingController phone = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController password = new TextEditingController();
  DateTime? dob;
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyAddUser = GlobalKey();
 

  File? branchImage;

   @override
  void initState() {
    diplayTutorial();
    super.initState();
  }

  diplayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('AddUserDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('AddUserDisplayedBefore',true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: silverLakeBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.addNewUser, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: 100.w,
            // height: 100.h,
            child: Column(
              children: [
                SizedBox(
                  height: 1.h,
                ),
                 InkWell(
                  onTap: () async{
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if(image != null){
                    setState(() {
                      branchImage = File(image.path);
                    });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 12.w : 35.w,
                    height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 12.w : 35.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400
                      ),
                      shape: BoxShape.circle
                    ),
                    child: ClipRRect( 
                      child: branchImage == null ? Image.asset("assets/images/noImageIcon.jpg")
                      :Image.file(branchImage!, fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(300.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
              Container(
                key: keyAddUser,
                child: Column(children: [  
                  TextFeildWidget(controller: name, hint: AppLocalizations.of(context)!.fullName, maxLines: 1, icon: Icon(Icons.location_city_outlined)),
                  TextFeildWidget(controller: email, hint: AppLocalizations.of(context)!.email, maxLines: 1, icon: Icon(Icons.email)),
                  TextFeildWidget(controller: password, hint: AppLocalizations.of(context)!.password, maxLines: 1, icon: Icon(Icons.key)),
                  TextFeildWidget(controller: address, hint: AppLocalizations.of(context)!.address, maxLines: 1, icon: Icon(Icons.edit_location_outlined),),
                  TextFeildWidget(controller: phone, hint: AppLocalizations.of(context)!.phoneNumber, maxLines: 1, icon: Icon(Icons.phone),),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                          decoration: BoxDecoration(

                            border: Border.all(
                                color: Colors.black,
                                width: 0.5
                            ),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                          child: TextButton(
                          onPressed: () async{
                             final DateTime? picked = await showDatePicker(
                                          helpText: AppLocalizations.of(context)!.dateOfBirth,
                                          context: context,
                                          initialDate: DateTime(1990),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2010),
                                          );
                                      if (picked != null) {
                                        setState(() {
                                          dob = picked;
                                        });
                                      }
                            },
                            
                            child: Row(
                              children: [
                                Icon(Icons.event, color: Colors.grey.shade600,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    dob != null ? dob.toString().split(' ').first.toString() : AppLocalizations.of(context)!.dateOfBirth,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                ),
                              ],
                            )),
                          )
                     ]
                    ),
        
                Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                     width:MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                     child: DropdownButtonFormField( 
                            items: BaseScreen.allGenders.map((Gender value){
                              return new DropdownMenuItem<String>(
                                value: value.id.toString(),
                                child: Container(
                                  width: 160,
                                  child: Text(value.code!, style: TextStyle(fontSize: 12),)),
                              );
                            }).toList(),
                            validator: (val){
                               if(val == null)
                               return 'Select Gender';
                               else return null;
                            },
                            onChanged: (v){
                              print(v.toString());
                              setState(() {
                                selectedGenderId = int.parse(v.toString());
                              });                           
                            },
        
                              hint: Text(AppLocalizations.of(context)!.gender, style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: silverLakeBlue
                                  )
                              ),
                              decoration: InputDecoration( 
                                prefixIcon: Icon(Icons.public_rounded, size:30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: Colors.black, width: 0.5)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: silverLakeBlue, width: 1)
                                ),
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
                            onChanged: (v){
                              print(v.toString());
                              setState(() {
                                selectedBranchId = int.parse(v.toString());
                              });                           
                            },
        
                              hint: Text(AppLocalizations.of(context)!.branch, style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: silverLakeBlue
                                  )
                              ),
                              decoration: InputDecoration( 
                                prefixIcon: Icon(Icons.apartment_rounded, size:30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: Colors.black, width: 0.5)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: silverLakeBlue, width:1)
                                ),
                             ),
                          ),                                                                                                                                                                                                                                                                                                
                   ),  
        
                   
                 
                SizedBox(
                  height: 2.h,
                ),
                
                // Spacer(),
        
                Container(
                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.h : 0),
                      decoration: BoxDecoration(
                      color: silverLakeBlue,
                      borderRadius: BorderRadius.circular(5.0)),
                      child: isLoading == false ?
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          // if(name.text.isNotEmpty && email.text.isNotEmpty && password.text.isNotEmpty && selectedBranchId != 0){
                            bool hasMinLength = password.text.length > 7;
                          if(name.text.isEmpty){
                            showDialog(context: context, builder: (context) => MsgDialog(msg: SplashScreen.langId == 1 ? 'ادخل اسم الموظف' : 'Add Employee Name'));
                          }
                          else if(hasMinLength == false){
                            showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.passwordValidationMsg));
                          }
                          else if(selectedBranchId == 0){
                            showDialog(context: context, builder: (context) => MsgDialog(msg: SplashScreen.langId == 1 ? 'حدد الفرع' : 'Select a branch'));
                          }
                          else if(phone.text.isNotEmpty && phone.text.length != 10){
                            showDialog(context: context, builder: (context) => MsgDialog(msg: SplashScreen.langId == 1 ? 'يجب أن يحتوي رقم الهاتف على 10 أرقام' : 'The phone number must be 10 numbers'));
                          }
                          else{
                            if(! (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,5}').hasMatch(email.text))){
                              showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.emailValidationMsg));
                            }
                          else{  
                          double long = 0.0, lat=0.0;
        
                          for(Branch b in BranchesScreen.approvedBranches){
                            if(b.id == selectedBranchId){
                              long = b.long!;
                              lat = b.lat!;
                            }
                          }  
                          Map map = new Map();
                        
                          map["id"] = "";
                          map["fullName_en"] = name.text.trim();
                          map["fullName"] = name.text.trim();
                          map["email"] = email.text.trim();
                          map["password"] = password.text.trim();
                          map["external_id"] = "string";
                          map['address'] = address.text != null ? address.text : '';
                          map['address_en'] = address.text != null ? address.text : '';
                          map['long'] = long != null ? long : 0;
                          map['lat'] = lat != null ? lat : 0;
                          map["birthDate"] = dob!= null ? dob!.toIso8601String() : DateTime(0001,01,01).toIso8601String();
                          map['is_deleted'] =  false;
                          map["mobileNb"] = phone.text != null ? phone.text.trim() : '';
                          map["profile"] = "string";
                          map['serviceProviderBranchesId'] = selectedBranchId;
                          map["genderId"] = selectedGenderId != null ? selectedGenderId : 0;
                          map["is_Admin"] = true;
                          map["serviceProviderId"] = BaseScreen.loggedInSP!.id;
                          print(json.encode(map));
                          String uId = await addSPUser(map);
                          print(uId);
                          if(uId != ''){
                            if(branchImage != null){
                              print('lolll');
                            String addImageRes = await addUserImage(branchImage!, uId);
                            log(addImageRes);
                            }
                            Observable.instance.notifyObservers([
                            "_ManageAccountsScreenState",
                            ], notifyName : "update");
                            Navigator.pop(context);
                            showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.userAddedSuccessfully));
                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.failedToAddUser));
                          }
                          }
                        }
                          setState(() {
                            isLoading = false;
                          });
                       
                        },
                        child: Text(
                          AppLocalizations.of(context)!.addUser,
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
        identify: "keyAddUser",
        keyTarget: keyAddUser,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.addUserKeySentenceInAddUserScreen,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
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