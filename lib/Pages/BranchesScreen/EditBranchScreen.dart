import 'dart:io';
// import 'dart:html' as html;
import 'package:besure_hcp/Pages/BranchesScreen/Components/AddGoogleMapsAdress.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/Components/TextFeildWidget.dart';
import 'package:besure_hcp/Services/BranchesServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class EditBranchScreen extends StatefulWidget {
  const EditBranchScreen({super.key, this.branch});

  final Branch? branch;

  @override
  State<EditBranchScreen> createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {
  bool isLoading = false;
  bool editedImage = false;
  var imageBytes = '';
  String fileName = ''; 
  TextEditingController phone = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController speciality = new TextEditingController();
  TextEditingController websiteUrl = new TextEditingController();
  File? branchImage;
  var branchImageWeb;
  LatLng latLng = LatLng(0, 0);


  @override
  void initState() {
    super.initState();
    phone.text = widget.branch!.mobile!;
    name.text = widget.branch!.name!;
    address.text = widget.branch!.address!;
    description.text = widget.branch!.description!;
    speciality.text = widget.branch!.speciality!;
    websiteUrl.text = widget.branch!.websiteUrl!;
    latLng = LatLng(widget.branch!.lat!, widget.branch!.long!);
  }
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.editBranch),
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
                          //       branchImage = File(_imageUrl);
                          //       imageBytes = _imageBytes;
                          //         fileName = file.name;
                          //     });
                            
                          //   }
                         
                        }
                        else{

                          if(file.path != null){
                           
                            setState(() {
                              branchImage = File(file.path!);
                            });
                          }

                        }
                      }    
                  //--------------------
                  // if(!kIsWeb){
                  //  var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
                  //   if(pickedFile != null){
                  //   File img = File(pickedFile.path);
                  //   setState(() {
                  //     branchImage = img;
                  //     editedImage = true;
                  //   });
                  //   }
                  // }
                  // else if(kIsWeb){
                  //   var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
                  //   if(pickedFile != null){
                  //   var img = await pickedFile.readAsBytes();
                  //   setState(() {
                  //     branchImageWeb = img;
                  //     editedImage = true;
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
                  child: 
                  editedImage == false ?
                   ClipRRect( 
                    child: 
                    widget.branch!.image!.contains("/") || !widget.branch!.image!.contains(".")? 
                    Image.asset("assets/images/noImageIcon.jpg")
                    : Image.network(swaggerImagesUrl + "Branches/"+widget.branch!.image!),
                    borderRadius: BorderRadius.circular(300.0),
                  )
                  :
                  ClipRRect( 
                    child: 
                    Image.file(branchImage!),
                    borderRadius: BorderRadius.circular(300.0),
                  )
                  ,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              TextFeildWidget(controller: name, hint: AppLocalizations.of(context)!.branchName, maxLines: 1, icon: Icon(Icons.location_city_outlined)),
              TextFeildWidget(controller: address, hint: AppLocalizations.of(context)!.address, maxLines: 1, icon: Icon(Icons.edit_location_outlined),),
              TextFeildWidget(controller: phone, hint: AppLocalizations.of(context)!.phoneNumber, maxLines: 1, icon: Icon(Icons.phone),),
              TextFeildWidget(controller: description, hint: AppLocalizations.of(context)!.description, maxLines: 3, icon: Icon(Icons.description_outlined),),
               
              SizedBox(
                height: 1.h,
              ),
               Container(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0.5.h : 0),
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
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => AddGoogleMapsAddress(lat: widget.branch!.lat, long: widget.branch!.long,)))).then((value) {
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
              SizedBox(
                height: 1.h,
              ),
              TextFeildWidget(controller: websiteUrl, hint: AppLocalizations.of(context)!.websiteUrl, maxLines: 1, icon: Icon(Icons.web_outlined),),
              TextFeildWidget(controller: speciality, hint: 'الخاصية', maxLines: 1, icon: Icon(Icons.wb_iridescent_outlined)),
             
              SizedBox(
                height: 1.h,
              ),
                    
              Container(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0.5.h : 0),
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                    decoration: BoxDecoration(
                    color: silverLakeBlue,
                    borderRadius: BorderRadius.circular(8.0)),
                    child: isLoading == false ?
                    TextButton(
                      onPressed: () async {
                        if(name.text.isNotEmpty && phone.text.isNotEmpty && address.text.isNotEmpty && description.text.isNotEmpty){
                        Map map = new Map();
                        map["name"] = name.text;
                        map["image"] = widget.branch!.image;
                        map["description"] = description.text;
                        map['mobile'] = phone.text;
                        map['address'] = address.text;
                        map['long'] = latLng.longitude;
                        map['lat'] = latLng.latitude;
                        map['id'] = widget.branch!.id;
                        map['languageId'] = SplashScreen.langId!.toString();
                        map['serviceProviderId'] = BaseScreen.loggedInSP!.id!;
                        map['speciality'] = speciality.text ?? '';
                        map['websitUrl'] = websiteUrl.text ?? '';
                        map['serviceProviderBranchesId'] = widget.branch!.serviceProviderBranchesId;
                        map['cityId'] = 1;
                        
                        bool res = await editBranch(map);
      
                        if(res == true){
                          if(branchImage != null){
                          String addImageRes = await addBranchImage(branchImage!, widget.branch!.id!, imageBytes, fileName);
                          print(addImageRes);
                          }

                          Observable.instance.notifyObservers([
                          "_BranchesScreenState",
                          ], notifyName : "update");
                          Navigator.pop(context);
                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.branchEditedSuccessfully));
                        }
                        else{
                          showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.failedToEditBranch));
                        }
                      }
                      else{
                        showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.allFieldsAreRequired));
                      }
      
                      },
                      child: Text(
                        AppLocalizations.of(context)!.editBranch,
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
}