import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/ClientCard.dart';
import 'package:besure_hcp/Models/ClientService.dart';
import 'package:besure_hcp/Models/Transaction.dart';
import 'package:besure_hcp/Services/TakeServices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../Services/TransactionsServices.dart';

class SingleTransactionScreen extends StatefulWidget {
  const SingleTransactionScreen({super.key, this.transaction});

  final Transaction? transaction;

  @override
  State<SingleTransactionScreen> createState() => _SingleTransactionScreenState();
}

class _SingleTransactionScreenState extends State<SingleTransactionScreen> {
  ClientCard? card;
  bool getResult = false;
  
  @override
  void initState() {
    super.initState();
    getClientCardInfo();
  }

  getClientCardInfo() async {
    card = await getClientCard(widget.transaction!.cardId!);
    setState(() {
      getResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   foregroundColor: grey,
      //   elevation: 0,
      // ),
      body: 
       getResult == false ?
       SkeltonLoading() 
       :
       Container(
        width: 100.w,
        height: 100.h,
        color: silverLakeBlue,
        child: Column(
          children: [
            Container(
              width: 100.w,
              height: 40.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                  silverLakeBlue,
                  // azureishBlue,
                  silverLakeBlue
                ])
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SizedBox(
                  //   height: 5.h,
                  // ),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Container(
                      margin: EdgeInsets.all(1.w),
                      padding: EdgeInsets.all(1.w),
                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                      height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(300.0),
                          child: 
                              widget.transaction!.profile!.contains('/') || ! widget.transaction!.profile!.contains('.') || widget.transaction!.profile! == ''
                              ? 
                              Image.asset('assets/images/esnadTakaful.png')
                              : 
                              Image.network(swaggerImagesUrl + "Profiles/" + widget.transaction!.profile!, fit: BoxFit.cover)
                            ),
                    ),
                    Text(widget.transaction!.fullName!, style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 13.sp
                    ),)
                    ],
                  ),

                  Column(
                    children: [
                      Text('Total', style: TextStyle(color: Colors.white, 
                      fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 16.sp)),
                      if(card != null)
                      Text(card!.amount!.toString() +' SAR', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 8.sp : 18.sp
                    ),),
                    if(card == null)
                      Text('', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 8.sp : 18.sp
                    ),),
                    ],
                  ),

            if(card != null)
            if(card!.uploadedReciept != null && card!.uploadedReciept != "")
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 107, 170, 199),
                borderRadius: BorderRadius.circular(30.0)
              ),
              width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 50.w,
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  DisplayFullImage(image: card!.uploadedReciept)));
                }, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('View Bill', style: TextStyle(color: Colors.white, 
                    fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 13.sp
                    ),),
                     Lottie.asset(
                        'assets/animations/nextAnimation.json',
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 6.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 6.w,
                      ),
                  ],
                )),
            ),

            if(card != null)
            if(card!.uploadedReciept == null || card!.uploadedReciept == '' )
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 107, 170, 199),
                borderRadius: BorderRadius.circular(30.0)
              ),
              width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 50.w,
              child: TextButton(
                onPressed: () async{
                  showDialog(context: context, builder: (context) => GalleryOrCameraDialog(cardId: widget.transaction!.cardId));                 
                }, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Add Bill', style: TextStyle(color: Colors.white, 
                    fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 13.sp
                    ),),
                     Lottie.asset(
                        'assets/animations/addBillAnimation.json',
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 6.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 6.w,
                      ),
                  ],
                )),
            ),
            
                ],
              ),
            ),

            Container(
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0)
                )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                  SizedBox(
                    height: 4.h,
                  ),
              
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 6.w,
                      ),
                      Text('Services Taken', style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 14.sp,
                        fontWeight: FontWeight.bold),),
                    ],
                  ),
              
                   SizedBox(
                    height: 2.h,
                  ),
                         
                  if(card != null)
                  for(ClientService cs in card!.clientServices!)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 1.w,
                        ),
                        Container(
                        margin: EdgeInsets.all(1.w),
                        padding: EdgeInsets.all(1.w),
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: 
                                cs.serviceImage!.contains('/') || cs.serviceImage! == ''
                                ? 
                                Image.asset('assets/images/esnadTakaful.png')
                                : 
                                Image.network(swaggerImagesUrl + "Services/" + cs.serviceImage!, fit: BoxFit.cover)
                              ),
                      ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Container(
                          width: 40.w,
                          child: Text(cs.serviceName!,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp
                          )
                          )),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              width: 20.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('-' + cs.discount!.toString()+'%', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, 
                                  fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 13.sp
                                  )),
                                ],
                              )),
                            Container(
                              width: 20.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(cs.amount!.toString() + ' SAR', style: TextStyle(
                                   fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 13.sp
                                    ),),
                                ],
                              )),
                          ],
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ),
                  ),

                  
                        
                  ]),
              )
            ),
        
            // SizedBox(
            //   height: 1.h,
            // )
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 2.h),
            //   width: 80.w,
            //   height: 60.h,
            //   child: Image.network(swaggerImagesUrl+"Bills/"+card!.uploadedReciept!),
            // )
                 
          ]
        ),
      ),
    );
  }
}

class GalleryOrCameraDialog extends StatefulWidget {
  const GalleryOrCameraDialog({super.key, this.cardId});

  final int? cardId;

  @override
  State<GalleryOrCameraDialog> createState() => _GalleryOrCameraDialogState();
}

class _GalleryOrCameraDialogState extends State<GalleryOrCameraDialog> {
  String isUploaded = 'false';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: 
      isUploaded == "uploading" ?
      Container(
        child: Lottie.asset(
                        'assets/animations/uploadingImage.json',
                        width: 30.w,
                        height: 20.w,
                      ),
      ) 
      :
      Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Container(
            color: silverLakeBlue,
            width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 30.w : 70.w,
            child: TextButton(
              onPressed: () async{
                var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 60);
                if(pickedFile != null){
                  File img = File(pickedFile.path);
                  setState(() {
                    isUploaded = "uploading";
                  });
                  String res = await uploadBill(widget.cardId!, img);
                  print(res);  
                  Navigator.pop(context);
                  showDialog(context: context, builder: (context) => MsgDialog(msg: 'Image uploaded successfully',));
                }   
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Pick Image from Gallery', style: TextStyle(
                    color: Colors.white
                  ),),
                  Icon(Icons.image, color: Colors.white,)
                ],
              ),
            ),
          ),
          if (!kIsWeb)
          SizedBox(
            height: 1.h,
          ),
          if (!kIsWeb)
           Container(
            color: silverLakeBlue,
           width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 30.w : 70.w,
            child: TextButton(
              onPressed: () async{
                 var pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 60);
                if(pickedFile != null){
                  File img = File(pickedFile.path);
                  setState(() {
                    isUploaded = "uploading";
                  });
                  String res = await uploadBill(widget.cardId!, img);
                  print(res);  
                  Navigator.pop(context);
                  showDialog(context: context, builder: (context) => MsgDialog(msg: 'Image uploaded successfully',));

                }              
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Pick Image from Camera', style: TextStyle(
                    color: Colors.white
                  ),),
                  Icon(Icons.camera_alt, color: Colors.white,)
                ],
              ),
            ),
          )
        ]
      )
    );
  }
}

class DisplayFullImage extends StatefulWidget {
  const DisplayFullImage({ Key? key,
  this.image }) : super(key: key);

  final String? image;
  @override
  State<DisplayFullImage> createState() => _DisplayFullImageState();
}

class _DisplayFullImageState extends State<DisplayFullImage> {
  PageController? scrollController;

  @override
  Widget build(BuildContext context) {

      // scrollController = PageController(
      //    initialPage: widget.index!,
      //    keepPage: true,
      // );
     
     return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // color: Colors.red,
            child: GestureDetector(
              child: 
              Image.network(
                swaggerImagesUrl + "Bills/"+widget.image!,
                fit: BoxFit.cover,
                // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                //   return Center(child: CircularProgressIndicator(
                //     color: Colors.red,
                //   ));
                // },
              ),
            onTap: () {
              Navigator.pop(context);
            },
          )
         )
        );
  }
}

class SkeltonLoading extends StatelessWidget {
  const SkeltonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100.w,
        height: 100.h,
        child: Column(
          children: [
            Container(
              width: 100.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: silverLakeBlue.withOpacity(0.04)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, color: Colors.black.withOpacity(0.04)),
                      ),
                      Container(
                      margin: EdgeInsets.all(1.w),
                      padding: EdgeInsets.all(1.w),
                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                      height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                       color: Colors.black.withOpacity(0.04),),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(300.0),
                       ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.04),
                      child: Text('     ', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 13.sp
                      ),),
                    )
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                      color: Colors.black.withOpacity(0.04),
                      child: Text('  ', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 16.sp))),
                      
                      Container(
                        color: Colors.black.withOpacity(0.04),
                        child: Text('  ', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 8.sp : 18.sp
                         ),),
                      ),
                    ],
                  ),

           
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(30.0)
              ),
              width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 50.w,
              child: TextButton(
                onPressed: (){
                }, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('   ', style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 13.sp),),
                     Lottie.asset(
                        'assets/animations/nextAnimation.json',
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 6.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 6.w,
                      ),
                  ],
                )),
            ),
            
                ],
              ),
            ),

            Container(
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0)
                )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                  SizedBox(
                    height: 4.h,
                  ),
              
                  Row(
                    children: [
                      SizedBox(
                        width: 6.w,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.04),
                        child: Text('   ', style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 14.sp,
                          fontWeight: FontWeight.bold),)),
                    ],
                  ),
              
                   SizedBox(
                    height: 2.h,
                  ),
                         
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 1.w,
                        ),
                        Container(
                        margin: EdgeInsets.all(1.w),
                        padding: EdgeInsets.all(1.w),
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.black.withOpacity(0.04),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.04),
                          width: 40.w,
                          child: Text('   ', 
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp
                          ),)),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              color: Colors.black.withOpacity(0.04),
                              width: 20.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('    ', style: TextStyle(fontWeight: FontWeight.bold, 
                                  fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 13.sp)),
                                ],
                              )),
                            Container(
                              width: 20.w,
                              color: Colors.black.withOpacity(0.04),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('   ', style: TextStyle(fontSize: 13.sp),),
                                ],
                              )),
                          ],
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 1.w,
                        ),
                        Container(
                        margin: EdgeInsets.all(1.w),
                        padding: EdgeInsets.all(1.w),
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.black.withOpacity(0.04),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.04),
                          width: 40.w,
                          child: Text('   ')),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              color: Colors.black.withOpacity(0.04),
                              width: 20.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('    ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                                ],
                              )),
                            Container(
                              width: 20.w,
                              color: Colors.black.withOpacity(0.04),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('   ', style: TextStyle(fontSize: 13.sp),),
                                ],
                              )),
                          ],
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 1.w,
                        ),
                        Container(
                        margin: EdgeInsets.all(1.w),
                        padding: EdgeInsets.all(1.w),
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 12.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.black.withOpacity(0.04),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.04),
                          width: 40.w,
                          child: Text('   ')),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              color: Colors.black.withOpacity(0.04),
                              width: 20.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('    ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                                ],
                              )),
                            Container(
                              width: 20.w,
                              color: Colors.black.withOpacity(0.04),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('   ', style: TextStyle(fontSize: 13.sp),),
                                ],
                              )),
                          ],
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ),
                  ),


                  ]),
              )
            ),
      
          ]
        ),
      );
  }
}