import 'dart:io';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/EditProfileScreen/Components/TextFeildWidget.dart';
import 'package:besure_hcp/Services/ServiceProviderInfo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  TextEditingController address = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController ownerName = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController shortDescription = new TextEditingController();
  File? businessImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(BaseScreen.loggedInSP!.name!);
    name.text = BaseScreen.loggedInSP!.name!;
    address.text = BaseScreen.loggedInSP!.address!;
    phone.text = BaseScreen.loggedInSP!.phoneNumber!;
    ownerName.text = BaseScreen.loggedInSP!.ownerName!;
    description.text = BaseScreen.loggedInSP!.description!;
    shortDescription.text = BaseScreen.loggedInSP!.shortDescription!;
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
          height: 100.h,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 35.w,
                    height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 35.w,
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
                    });
                  },
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle
                    ),
                    child: ClipRRect(
                      child: businessImage == null ? Image.asset("assets/images/esnadTakaful.png")
                      :Image.file(businessImage!),
                      borderRadius: BorderRadius.circular(300.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              TextFeildWidget(controller: name, hint: AppLocalizations.of(context)!.businessName, maxLines: 1, icon: Icon(Icons.person),),
              TextFeildWidget(controller: ownerName, hint: 'Owner Name', maxLines: 1, icon: Icon(Icons.personal_injury_rounded),),
              TextFeildWidget(controller: address, hint: 'Address', maxLines: 1, icon: Icon(Icons.location_on_outlined),),
              TextFeildWidget(controller: phone, hint: AppLocalizations.of(context)!.phoneNumber, maxLines: 1, icon: Icon(Icons.phone),),
              TextFeildWidget(controller: shortDescription, hint: 'Short Description', maxLines: 1, icon: Icon(Icons.description),),
              TextFeildWidget(controller: description, hint: 'Description', maxLines: 3, icon: Icon(Icons.description_outlined),),
              SizedBox(
                height: 4.h,
              ),
      
              Container(
                    width: 85.w,
                    decoration: BoxDecoration(
                        color: greenSheen,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: isLoading == false ?
                    TextButton(
                        onPressed: () async {                
                          var map = new Map(); 
                          map['id'] = BaseScreen.loggedInSP!.id!;
                          map['name'] = name.text;
                          map['name_en'] = name.text;
                          map['phoneNumber2'] = phone.text;
                          map['address'] = address.text;
                          map['address_en'] = address.text;
                          map['ownerName'] = ownerName.text;
                          map['ownerName_en'] = ownerName.text;
                          map['description'] = description.text;
                          map['updated_by'] = BaseScreen.loggedInSP!.serviceProviderId!;
                          map['cityId'] = 1;
                          map['long'] = 0;
                          map['lat'] = 0;
                          map['shortDescription'] = shortDescription.text;
                          map['profile'] = '';
                          bool res = await editServiceProviderInfo(map);
                          if(res == true){
                            print('trueeeeeeee');
                            await getServiceProviderBasicInfo(BaseScreen.loggedInSP!.id!);
                            setState(() {
                              
                            });
                          }
                          else{
                            print('falseeeeeeeee');
                          }
                        },
                        child: Text('Save',
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
      
            ],
          ),
        ),
      ),
    );
  }
}