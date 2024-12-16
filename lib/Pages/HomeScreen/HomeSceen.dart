import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Models/CustomerReview.dart';
import 'package:besure_hcp/Pages/ActivityScreen/ActivityScreen.dart';
import 'package:besure_hcp/Pages/AllCustomerReviewsScreen/AllCustomerReviewsScreen.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/EditProfileScreen/EditProfileScreen.dart';
import 'package:besure_hcp/Pages/HomeScreen/CustomerReviewsDetails.dart';
import 'package:besure_hcp/Services/GeneralServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Pages/BeneficiariesScreen/BeneficiariesScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/DiscountSreen/DiscountScreen.dart';
import 'package:besure_hcp/Pages/HomeScreen/Components/CustomerReviewWidget.dart';
import 'package:besure_hcp/Pages/HomeScreen/Components/ServiceWidget.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/Components/ServiceProvidedWidget.dart';
import 'package:besure_hcp/Pages/ServicesScreen/AllServicesScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Services/BranchesServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static List<CustomerReview> allCustomerReviews = [];
  static int loyaltyPoints = 0;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Observer{
  String branchName = '';

  @override
  void initState() {
    Observable.instance.addObserver(this);
    super.initState();
    loadApis();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }
  


  String formatNumber(int number){
    if(number >= 1000000){
      return (number/1000000).toStringAsFixed(1)+'M';
    }
    else if(number >= 1000){
      return (number/1000).toStringAsFixed(1)+'k';
    }
    else{
      return number.toString();
    }
  }

  void loadApis() async{
    String id = LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True" ?  BaseScreen.loggedInSP!.id! : LoginScreen.SPSAID!;
    getLoyaltyPoints(id.toString());
    await getAllLanguages();
    if(BranchesScreen.approvedBranches.isEmpty)
     bool res = await getAllApprovedBranches();
     for(Branch b in BranchesScreen.approvedBranches){
      // print( b.serviceProviderBranchesId.toString() +'lllllllllllllllllll');
      if(BaseScreen.loggedInSP!.branchId! ==  b.serviceProviderBranchesId){
        setState(() {
          branchName = b.name!;
        });
      }
     }
    //  bool res2 = await getAllCustomerReviews(1,0,2);
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //   stream: channel.stream,
    //   builder: (context, snapshot) {
    //     print(snapshot.connectionState.toString());
    //     print(snapshot.data.toString());
      return Scaffold(
        body: Container(
          width: 100.w,
          height: 100.h,
          // color: Colors.whit,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Stack(
                   children: [
                     SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 22.h : 18.h,
                          // child: SvgPicture.asset('assets/images/bgHue.svg',
                          //     fit: BoxFit.fill, color: silverLakeBlue)
                              ),
                     Row(
                       children: [
                        SizedBox(
                          width: 5.w,
                        ),
                         InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                          },
                           child: AvatarGlow(
                            startDelay: const Duration(milliseconds: 1500),
                            glowColor: silverLakeBlue,
                            glowShape: BoxShape.circle,
                            curve: Curves.easeIn,
                            glowCount: 1,
                             child: Material(
                              // elevation: 4.0,
                              shape: CircleBorder(),
                              // color: grey,
                               child: Container(
                                                     width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 7.w : 16.w,
                                                     height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 7.w : 16.w,
                                                     decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                                                     child: Container(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0.5.w : 0.5.w),
                                decoration: BoxDecoration(shape: BoxShape.circle),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(300.0),
                                    child:
                                     BaseScreen.loggedInSP!.profile! == '' || BaseScreen.loggedInSP!.profile!.contains("/")
                                    ?
                                    Image.asset("assets/images/esnadTakaful.png")
                                    :
                                    Image.network(swaggerImagesUrl + "serviceproviderprofiles/" + BaseScreen.loggedInSP!.profile!,
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                            return Icon(Icons.person);
                          },)
                                )
                                                     ),
                                                   ),
                             ),
                           ),
                         ),
                      SizedBox(
                          width: 4.w,
                        ),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(LoginScreen.isAdmin != true && LoginScreen.isAdmin != "true" && LoginScreen.isAdmin != "True" && BaseScreen.loggedInSP!.serviceProvideName_en != null && BaseScreen.loggedInSP!.serviceProvideName_en != '')
                                  Container(
                                    width: 50.w,
                                    child: Row(
                                      children: [
                                        Text(
                                          SplashScreen.langId! == 1 ? BaseScreen.loggedInSP!.serviceProvideName! : BaseScreen.loggedInSP!.serviceProvideName_en!,
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.sp : 16.sp
                                        ),),
                                        // SizedBox(width:5),
                                        // InkWell(
                                        //   onTap: (){
                                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerReviewsDetails()));
                                        //   },
                                        //   child: Container(
                                        //   width: 40.w,
                                        //   child: RatingBarIndicator(
                                        //     rating: BaseScreen.rating.toDouble(),
                                        //     itemBuilder: (context, index) => Icon(
                                        //       Icons.star,
                                        //       color: silverLakeBlue,
                                        //     ),
                                        //     unratedColor: Colors.grey.shade300,
                                        //     itemCount: 5,
                                        //     itemSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.6.w : 6.w,
                                        //     direction: Axis.horizontal,
                                        //   ),
                                        //                                         ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 50.w,
                                    child: Row(
                                      children: [
                                        Text(BaseScreen.loggedInSP!.name!, style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.sp : 16.sp
                                        ),),
                                        // if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
                                        // Text(
                                        //   '('+AppLocalizations.of(context)!.admin+')', style: TextStyle(
                                        //   fontWeight: FontWeight.bold,
                                        //   fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.sp : 16.sp
                                        // ),),
                                        if(LoginScreen.isAdmin != "true" && LoginScreen.isAdmin != "True")
                                        Text(
                                          ' ('+ AppLocalizations.of(context)!.employee+')', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.sp : 16.sp
                                        ),),
                                      ],
                                    ),
                                  ),
                                  // if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
                                  //     InkWell(
                                  //       onTap: (){
                                  //         Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerReviewsDetails()));
                                  //       },
                                  //       child: Container( 
                                  //         width: 70.w,
                                  //         child: RatingBarIndicator(
                                  //           rating: BaseScreen.rating.toDouble(),
                                  //           itemBuilder: (context, index) => Icon(
                                  //             Icons.star,
                                  //             color: silverLakeBlue,
                                  //           ),
                                  //           unratedColor: Colors.grey.shade300,
                                  //           itemCount: 5,
                                  //           itemSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.6.w : 6.w,
                                  //           direction: Axis.horizontal,
                                  //         ),
                                  //       ),
                                  //     ),
                                  // SizedBox(height: 1.h),
                                  if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
                                        Text(
                                          '('+AppLocalizations.of(context)!.admin+')', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.sp : 15.sp
                                        ),),
                                   Container(
                                    width: 50.w,
                                     child: Text(branchName, style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.sp : 11.sp
                                                                   ),),
                                   ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: silverLakeBlue,
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: RichText
                                ( text : TextSpan(
                                  children: [
                                    TextSpan(
                                    text:formatNumber(HomeScreen.loyaltyPoints),
                                      style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!.points,
                                      style: TextStyle(color:Colors.white, fontWeight: FontWeight.w400),
                                  ),

                                ]), 
                                ),)
                       ],
                     )   
                   ],
                   alignment: Alignment.center,
                 ),
                SizedBox(
                  height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.h : 2.h,
                ),
                // snapshot.hasData ? Text(snapshot.data.toString()) : Text(''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityScreen()));
                      },
                      child: Container(
                        width: 40.w,
                        height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 30.h : 22.h,
                        decoration: BoxDecoration(
                            color: silverLakeBlue,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                'assets/animations/bargraph1.json',
                                delegates: LottieDelegates(
                                  values: [
                                    ValueDelegate.color(
                                      const['**','Comp 1','**'],
                                      value: Colors.white
                                    )
                                  ]
                                ),
                                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 10.w : 24.w,
                                height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 10.w : 30.w,
                              ),
                            // Icon(
                            //   Icons.bar_chart,
                            //   // color: ConstantColors.bl,
                            //   size: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.w : 24.w,
                            // ),
                            Text(
                              AppLocalizations.of(context)!.activity,
                              style: TextStyle(
                                fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 17.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: (){
                            // var r= channel.sink.add('Login');
                            // print(r.toString());
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DiscountScreen()));
                          },
                          child: Container(
                            width: 45.w,
                            height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 14.h : 10.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: silverLakeBlue),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.w : 3.w,
                                    ),
                                    // Icon(Icons.disc_full_outlined, size: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w :6.w),
                                  Lottie.asset(
                                'assets/animations/discountAnimation.json',
                                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.w : 10.w,
                                height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.w : 10.w,
                              ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.discounts,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                                        color: Colors.white,
                                        fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 17.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BeneficiariesScreen()));
                          },
                          child: Container(
                            width: 45.w,
                            height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 14.h : 10.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: silverLakeBlue),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    // Icon(Icons.people_outline, size: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.w : 6.w),
                                    Lottie.asset(
                                      'assets/animations/personAnimation.json',
                                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 3.w : 6.w,
                                      height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 4.w : 8.w,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.beneficiaries,
                                      style: TextStyle(
                                        fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 17.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                // Container(
                //   width: 90.w,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     gradient: LinearGradient(
                //       colors: [Color.fromARGB(255, 27, 64, 82), navyBlue])
                //   ),
                //   child: Column(
                //     children: [
                //       Row(
                //         children: [
                //           Container(
                //             margin: EdgeInsets.all(10),
                //             child: Text('Loyalty Balance', style: TextStyle(
                //               color: Colors.white,
                //               fontWeight: FontWeight.w700
                //             ),),
                //           ),
                //         ],
                //       ),
                //       Row(
                //         children: [
                //           Container(
                //             padding: EdgeInsets.all(12),
                //             margin: EdgeInsets.all(12),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(300),
                //               border: Border.all(
                //                 color: Colors.white,
                //                 width: 2
                //               )
                //             ),
                //             child: Image.asset("assets/images/trophy.png", height: 30, width:30)
                //           ),
                //           Column(
                //             children: [
                //               Container(
                //                 width: 60.w,
                //                 child: Text(HomeScreen.loyaltyPoints.toString()+'pts', style: TextStyle( 
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 26,
                //                   color: Colors.yellow.shade700
                //                 ),),
                //               ),
                //               Container(
                //                 width: 60.w,
                //                 child: Text('Total loyalty points', style: TextStyle(color: Colors.white,),))
                //             ],
                //           )
                //         ],
                //       ),
                //       Text('--------------------------------------', style: TextStyle(
                //         color: Colors.white
                //       ),),
                //       Container(
                //         margin: EdgeInsets.all(10),
                //         child: Row(
                //           children: [
                //            InkWell(
                //                           onTap: (){
                //                             Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerReviewsDetails()));
                //                           },
                //                           child: Container(
                //                           width: 40.w,
                //                           child: RatingBarIndicator(
                //                             rating: BaseScreen.rating.toDouble(),
                //                             itemBuilder: (context, index) => Icon(
                //                               Icons.star,
                //                               color: Colors.yellow.shade700,
                //                             ),
                //                             unratedColor: Colors.grey.shade200,
                //                             itemCount: 5,
                //                             itemSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 1.6.w : 6.w,
                //                             direction: Axis.horizontal,
                //                           ),
                //                                                                 ),
                //                         ),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 10.h : 5.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      AppLocalizations.of(context)!.services,
                      style:
                          TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 7.sp : 18.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                if(AllServicesScreen.allApprovedServices.length >= 2)
                Column(
                  children: [
                    ServiceProvidedWidget(service: AllServicesScreen.allApprovedServices[0], isHome: true),
                    ServiceProvidedWidget(service: AllServicesScreen.allApprovedServices[1], isHome: true),
                  ],
                ),
                if(AllServicesScreen.allApprovedServices.length == 1)
                ServiceProvidedWidget(service: AllServicesScreen.allApprovedServices[0], isHome: true),
                Container(
                  width: 82.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllServicesScreen()));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.viewAll,
                            style: TextStyle(fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.sp :14.sp),
                          ))
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 5.h,
                // ),
                // Row(
                //   children: [
                //     SizedBox(
                //       width: 10.w,
                //     ),
                //     Text(
                //       AppLocalizations.of(context)!.customerReviews,
                //       style:
                //           TextStyle(color: silverLakeBlue, fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 7.sp : 14.sp),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 2.h,
                // ),
                // if(HomeScreen.allCustomerReviews.length >= 2)
                // Column(
                //   children: [
                //     CustomerReviewWidget(customerReview: HomeScreen.allCustomerReviews[0]),
                //     CustomerReviewWidget(customerReview: HomeScreen.allCustomerReviews[1]),
                //   ],
                // ),
                // if(HomeScreen.allCustomerReviews.length == 1)
                // CustomerReviewWidget(customerReview: HomeScreen.allCustomerReviews[0]),
                // Container(
                //   width: 82.w,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       InkWell(
                //           onTap: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => AllCustomerReviewsScreen()));
                //           },
                //           child: Text(
                //             AppLocalizations.of(context)!.viewAll,
                //             style: TextStyle(fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 5.sp : 9.sp),
                //           ))
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 5.h,
                // ),
              ],
            ),
          ),
        ),
      );
      }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    setState(() {
      
    });
  }
  //   );
  // }
}
