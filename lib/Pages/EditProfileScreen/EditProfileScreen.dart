import 'dart:developer';
import 'dart:io';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/EditProfileScreen/Components/TextFeildWidget.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Services/ServiceProviderInfo.dart';
import 'package:besure_hcp/Services/ServiceProviderUserServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController address = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController ownerName = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController shortDescription = new TextEditingController();
  File? businessImage;
  bool editedImage = false;
  bool isLoading = false;
  DateTime? dob;

  @override
  void initState() {
    super.initState();
    print(BaseScreen.loggedInSP!.profile!);
    name.text = BaseScreen.loggedInSP!.name!;
    address.text = BaseScreen.loggedInSP!.address!;
    phone.text = BaseScreen.loggedInSP!.phoneNumber!;
    ownerName.text = BaseScreen.loggedInSP!.ownerName!;
    description.text = BaseScreen.loggedInSP!.description!;
    shortDescription.text = BaseScreen.loggedInSP!.shortDescription!;
    if(BaseScreen.loggedInSP!.birthDate! != ''){
      dob = DateTime.parse(BaseScreen.loggedInSP!.birthDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        title: Text(AppLocalizations.of(context)!.editProfile),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 100.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                 width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 10.w : 35.w,
                    height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 10.w : 35.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.fromARGB(255, 205, 203, 203)
                      )
                ),
                    
                child: InkWell(
                  onTap: () async{
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      businessImage = File(image!.path);
                      editedImage = true;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 15.w : 35.w,
                    height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 15.w : 35.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle
                    ),
                    child: 
                    editedImage == false ?
                    ClipRRect(
                      child:
                       BaseScreen.loggedInSP!.profile! == '' || BaseScreen.loggedInSP!.profile!.contains('/')
                       ? 
                       Image.asset("assets/images/esnadTakaful.png")
                      :Image.network(swaggerImagesUrl + "serviceproviderprofiles/" + BaseScreen.loggedInSP!.profile!,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                            return Icon(Icons.person);
                          },),
                      borderRadius: BorderRadius.circular(300.0),
                    )
                    :
                    ClipRRect(
                      child: Image.file(businessImage!),
                      borderRadius: BorderRadius.circular(300.0),
                    )
                    
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              TextFeildWidget(controller: name, hint: AppLocalizations.of(context)!.fullName, maxLines: 1, icon: Icon(Icons.person),),
              if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
              TextFeildWidget(controller: ownerName, hint: 'Owner Name', maxLines: 1, icon: Icon(Icons.personal_injury_rounded),),
              TextFeildWidget(controller: address, hint: AppLocalizations.of(context)!.address, maxLines: 1, icon: Icon(Icons.location_on_outlined),),
              TextFeildWidget(controller: phone, hint: AppLocalizations.of(context)!.phoneNumber, maxLines: 1, icon: Icon(Icons.phone),),
              if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
              TextFeildWidget(controller: shortDescription, hint: 'Short Description', maxLines: 1, icon: Icon(Icons.description),),
              if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
              TextFeildWidget(controller: description, hint: AppLocalizations.of(context)!.description, maxLines: 3, icon: Icon(Icons.description_outlined),),
              // if(LoginScreen.isAdmin != "true" && LoginScreen.isAdmin != "True")
              // Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // children: [
              //   Container(
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //                 color: Colors.grey.shade500
              //             ),
              //             borderRadius: BorderRadius.circular(5)
              //           ),
              //           width: 85.w,
              //           child: TextButton(
              //           onPressed: () async{
              //              final DateTime? picked = await showDatePicker(
              //                           helpText: 'Date of birth',
              //                           context: context,
              //                           initialDate: DateTime(1990),
              //                           firstDate: DateTime(1950),
              //                           lastDate: DateTime(2010),
              //                           );
              //                       if (picked != null) {
              //                         setState(() {
              //                           dob = picked;
              //                         });
              //                       }
              //             },
                          
              //             child: Row(
              //               children: [
              //                 Icon(Icons.event, color: Colors.grey.shade600,),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Text(
              //                     dob != null && dob != '' ? dob.toString().split(' ').first.toString() : 'Date of birth',
              //                     textScaleFactor: 1.0,
              //                     style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              //                 ),
              //               ],
              //             )),
              //           )
              //      ]
              //     ),
              SizedBox(
                height: 4.h,
              ),
      
              Container(
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.h : 0),
                    decoration: BoxDecoration(
                        color: silverLakeBlue,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: isLoading == false ?
                    TextButton(
                        onPressed: () async {  
                          setState(() {
                            isLoading = true;
                          });              
                          var map = new Map(); 
                          map['id'] = BaseScreen.loggedInSP!.id!;
                          map['address'] = address.text;
                          map['address_en'] = address.text;
                          map['long'] = 0;
                          map['lat'] = 0;
                          map['profile'] = BaseScreen.loggedInSP!.profile;
                          map['email'] = BaseScreen.loggedInSP!.email;
                          bool res;
                          if(LoginScreen.isAdmin == "true" ||LoginScreen.isAdmin == "True"){
                            map['ownerName'] = ownerName.text;
                            map['ownerName_en'] = ownerName.text;
                            map['name'] = name.text;
                            map['phoneNumber2'] = phone.text;
                            map['phoneNumber'] = phone.text;
                            map['name_en'] = name.text;
                            map['shortDescription'] = shortDescription.text.isNotEmpty ? shortDescription.text : 'short description';
                            map['description'] = description.text.isNotEmpty ?  description.text : 'description';
                            map['updated_by'] = BaseScreen.loggedInSP!.serviceProviderId!;
                            map['cityId'] = 1;
                            res = await editServiceProviderInfo(map);
                          }
                          else{
                            map['fullName'] = name.text;
                            map['phoneNumber'] = phone.text;
                            map['fullName_en'] = name.text;
                            // map['birthDate'] = BaseScreen.loggedInSP!.birthDate!;
                            map['shortDescription'] = shortDescription.text;
                             res = await editSPUser(map);
                          }
                          if(res == true){
                            if(businessImage != null){
                            String addImageRes = await addUserImage(businessImage!, BaseScreen.loggedInSP!.id!);
                            print(addImageRes);
                            }
                            print('trueeeeeeee');
                            await getServiceProviderBasicInfo(BaseScreen.loggedInSP!.id!);
                            setState(() {
                              
                            });
                            Observable.instance.notifyObservers([
                              "_ProfileScreenState",
                            ], notifyName : "update");
                          }
                          else{
                            print('falseeeeeeeee');
                          }
                          setState(() {
                            isLoading = false;
                          }); 
                        },
                        child: Text(AppLocalizations.of(context)!.save,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18)))
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
}