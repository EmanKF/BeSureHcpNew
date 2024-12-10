import 'dart:io';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/Components/TextFeildWidget.dart';
import 'package:besure_hcp/Services/ServicesServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class EditServiceScreen extends StatefulWidget {
  const EditServiceScreen({super.key, this.service});

  final ServiceModel? service;

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  bool isLoading = false;
  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController description = new TextEditingController();
  File? branchImage;

  @override
  void initState() {
    super.initState();
    name.text = widget.service!.name!;
    address.text = widget.service!.description!;
    description.text = widget.service!.image!;
  }
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text('Edit Service'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: 100.w,
          height: 100.h,
          child: Column(
            children: [
              SizedBox(
                height: 1.h,
              ),
               InkWell(
                onTap: () async{
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    branchImage = File(image!.path);
                  });
                },
                child: Container(
                  width: 35.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400
                    ),
                    shape: BoxShape.circle
                  ),
                  child: ClipRRect( 
                    child: branchImage == null ? Image.asset("assets/images/noImageIcon.jpg")
                    :Image.file(branchImage!),
                    borderRadius: BorderRadius.circular(300.0),
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              TextFeildWidget(controller: name, hint: 'Branch Name', maxLines: 1, icon: Icon(Icons.location_city_outlined)),
              TextFeildWidget(controller: address, hint: 'Availability', maxLines: 1, icon: Icon(Icons.edit_location_outlined),),
              TextFeildWidget(controller: description, hint: 'ImageUrl', maxLines: 3, icon: Icon(Icons.description_outlined),),
              SizedBox(
                height: 12.h,
              ),
                    
              Container(
                    width: 85.w,
                    decoration: BoxDecoration(
                    color: silverLakeBlue,
                    borderRadius: BorderRadius.circular(15.0)),
                    child: isLoading == false ?
                    TextButton(
                      onPressed: () async {
                        if(name.text.isNotEmpty && address.text.isNotEmpty && description.text.isNotEmpty){
                        Map map = new Map();
                        map["name"] = name.text;
                        map["image"] ='';
                        map["description"] = description.text;
                        map['address'] = address.text;
                        map['long'] = '202';
                        map['lat'] = '202';
                        map['is_deleted'] =  false;
                        map['is_Approved'] = false;
                        map['languageId'] = 1;
                        map['serviceProviderId'] = BaseScreen.loggedInSP!.id!;
                        map['serviceProviderBranchesId'] = 1;
                        map['cityId'] = 1;
                        
                        bool res = await editService(map);
      
                        if(res == true){
                          Observable.instance.notifyObservers([
                          "_BranchesScreenState",
                          ], notifyName : "update");
                          Navigator.pop(context);
                          showDialog(context: context, builder: (context) => MsgDialog(msg: 'Branch edited successfully',));
                        }
                        else{
                          showDialog(context: context, builder: (context) => MsgDialog(msg: 'Failed to edit branch',));
                        }
                      }
                      else{
                        showDialog(context: context, builder: (context) => MsgDialog(msg: 'All feilds are required',));
                      }
      
                      },
                      child: Text(
                        'Edit Branch',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}