import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/Components/DeleteDialog.dart';
import 'package:besure_hcp/Pages/ServicesScreen/ServiceDetailsScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ServiceProvidedWidget extends StatefulWidget {
  const ServiceProvidedWidget({super.key, this.service, this.isHome});

  final ServiceModel? service;
  final bool? isHome;

  @override
  State<ServiceProvidedWidget> createState() => _ServiceProvidedWidgetState();
}

class _ServiceProvidedWidgetState extends State<ServiceProvidedWidget> {
  bool isDisplayedDescription = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showDialog(context: context, builder: (context) => ServiceDetails(service: widget.service));
        // Navigator.s(context, MaterialPageRoute(builder: (context) => ServiceDetails(service: widget.service)));
      },
      child: Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.w : 2.w),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.w : 3.w),
        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 80.w: 90.w,
        decoration: BoxDecoration(
            color: lightBlue, borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 15.w,
                  height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 15.w,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: 
                         widget.service!.image!.contains('/') || ! widget.service!.image!.contains('.')
                          ? 
                          Image.asset('assets/images/esnadTakaful.png')
                          : 
                          Image.network(swaggerImagesUrl + "Services/" + widget.service!.image!, fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                            return Icon(Icons.error);
                          },)
                        ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 50.w,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w :5.w,
                          ),
                          Text(
                            widget.service!.name!,
                            style: TextStyle(fontWeight: FontWeight.w500, 
                            fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                            fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 17.sp),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w : 5.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:6),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.service!.price!.toString(),
                                      style: TextStyle(color:Colors.black, fontWeight: FontWeight.w400, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.sp :17.sp),
                                  ),
                                  TextSpan(
                                    text: '  '+AppLocalizations.of(context)!.sar,
                                      style: TextStyle(color:Colors.black, fontWeight: FontWeight.w300, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.sp :15.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Spacer(),
                if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
                if(widget.isHome == false)
                IconButton(onPressed: (){
                  showDialog(context: context, builder: (context) => DeleteDialog(service: widget.service!));
                }, 
                icon: Icon(Icons.delete, color: silverLakeBlue)),

                // if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
                // if(widget.isHome == true)
                // IconButton(
                //   onPressed: (){
                //    print('hhh');
                //    if(isDisplayedDescription == false){
                //       setState(() {
                //         isDisplayedDescription = true;
                //       });
                //    }
                //    else{
                //        setState(() {
                //         isDisplayedDescription = false;
                //       });
                //    }
                //   }, 
                // icon: Icon(isDisplayedDescription == false ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: silverLakeBlue, size: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.w : 10.w,)),

                //  if(LoginScreen.isAdmin != "true" && LoginScreen.isAdmin != "True")
                //  IconButton(
                //   onPressed: (){
                //    print('hhh');
                //    if(isDisplayedDescription == false){
                //       setState(() {
                //         isDisplayedDescription = true;
                //       });
                //    }
                //    else{
                //        setState(() {
                //         isDisplayedDescription = false;
                //       });
                //    }
                //   }, 
                // icon: Icon(isDisplayedDescription == false ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: silverLakeBlue, size: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.w : 10.w,)),
                // if(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height)
                // SizedBox(
                //   width: 2.w,
                // )
              ],
            ),
            
          //  if(isDisplayedDescription == true)
          //   Container(
          //     margin: EdgeInsets.symmetric(vertical: 1.h),
          //     child: Row(
          //       children: [
          //         SizedBox(
          //           width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.w : 3.w,
          //         ),
          //         Container(
          //           child: Text(widget.service!.description!, style: TextStyle(fontSize: 9.sp),),
          //         ),
                  
          //       ],
          //     ),
          //   )
          ],
        ),
      ),
    );
  }
}

class ServiceDetails extends StatelessWidget {
  ServiceDetails({super.key, this.service});
  ServiceModel? service;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: BeveledRectangleBorder(),
      insetPadding: EdgeInsets.all(0),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 100.w,
        height: 20.h,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 14.w,
                  height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 14.w,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: 
                         service!.image!.contains('/') || ! service!.image!.contains('.')
                          ? 
                          Image.asset('assets/images/esnadTakaful.png')
                          : 
                          Image.network(swaggerImagesUrl + "Services/" + service!.image!, fit: BoxFit.cover, errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                            return Icon(Icons.medical_services);
                          },)
                        ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 20.w : 50.w,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w :2.w,
                          ),
                          Text(
                            service!.name!,
                            style: TextStyle(color: silverLakeBlue, 
                             fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                            fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 17.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ]),
                
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Text(
                        service!.description!,
                        style: TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 16.sp),
                      ),
                    ),
                  ],
                ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}