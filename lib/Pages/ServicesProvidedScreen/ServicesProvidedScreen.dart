import 'dart:developer';
import 'dart:ui';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/Service.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/AddServiceScreen.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/Components/ServiceProvidedWidget.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Services/ServicesServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ServicesProvidedScreen extends StatefulWidget {
  const ServicesProvidedScreen({super.key});
  static List<ServiceModel> allServices = [];
  static List<ServiceModel> allApprovedServices = [];
  @override
  State<ServicesProvidedScreen> createState() => _ServicesProvidedScreenState();
}

class _ServicesProvidedScreenState extends State<ServicesProvidedScreen> with Observer{
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyApprovedServices = GlobalKey();
  GlobalKey keyAllServices = GlobalKey();
  GlobalKey keyAddService = GlobalKey();
  bool isLoadingAllServices = false;
  bool isLoadingApprovedServices = false;
  bool allServicesButton = false;
  bool approvedServicesButton = true;

  @override
  void initState() {
    diplayTutorial();
    Observable.instance.addObserver(this);
    super.initState();
    if(ServicesProvidedScreen.allServices.isEmpty){
      getServices();
    }
    // if(ServicesProvidedScreen.allApprovedServices.isEmpty){
    //   getApprovedServices();
    // }
  }

  diplayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('ServicesDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ServicesDisplayedBefore',true);
  }

  @override
  update(Observable observable, String? notifyName, Map? map){
    log('Provided Services Observableee');
    getServices();
    getApprovedServices();
    setState(() {
      
    });
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  void getApprovedServices() async{
    ServicesProvidedScreen.allApprovedServices = await getAllApprovedServices(BaseScreen.loggedInSP!.branchId!);
    setState(() {
      isLoadingApprovedServices = true;
    });
  }

  void getServices() async{
    bool res = await getAllServices();
    setState(() {
      isLoadingAllServices = res;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.providedServices),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  key: keyApprovedServices,
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.h : 0),
                  width: 50.w,
                  color: approvedServicesButton == true ? silverLakeBlue : lightGrey,
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        allServicesButton = false;
                        approvedServicesButton = true;
                      });
                    }, 
                    child: Text(AppLocalizations.of(context)!.approvedServices, 
                    style: TextStyle(color: approvedServicesButton == true ? Colors.white : silverLakeBlue),)
                  ),
                ),
                Container(
                  key: keyAllServices,
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.h : 0),
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: allServicesButton  == true ? silverLakeBlue : lightGrey
                  ),
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        approvedServicesButton = false;
                        allServicesButton = true;
                      });
                    }, 
                    child: Text(AppLocalizations.of(context)!.allServices,
                    style: TextStyle(color: allServicesButton  == true ? Colors.white : silverLakeBlue),)
                  ),
                ),
              ],
            ),
            approvedServicesButton == true?
            Container(
               margin: EdgeInsets.only(top: 1.h),
                height: 72.h,
              child: 
              SingleChildScrollView(
              child: 
              Column(
                children: [
                  for(ServiceModel service in ServicesProvidedScreen.allApprovedServices)
                  ServiceProvidedWidget(service: service, isHome: false)
                ],
              ),
              )
            )
            :
            Container(
              margin: EdgeInsets.only(top: 1.h),
              height: 72.h,
              child: 
              SingleChildScrollView(
                child: Column(
                  children: [
                    for(ServiceModel service in ServicesProvidedScreen.allServices)
                    ServiceProvidedWidget(service: service, isHome: false)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      
      floatingActionButton: 
      LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True"?
      Container(
        key: keyAddService,
        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 18.w : 40.w,
        decoration: BoxDecoration(
            color: silverLakeBlue,
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddServiceScreen()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.addService, style: TextStyle(
                fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 12.sp,
                color: Colors.white
              ),),
              Icon(Icons.add, color: Colors.white)
            ],
          ),
        ),
      )
      :
      null,
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
        identify: "keyApprovedServices",
        keyTarget: keyApprovedServices,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(AppLocalizations.of(context)!.approvedServicesKeySentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyAllServices",
        keyTarget: keyAllServices,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(AppLocalizations.of(context)!.allServicesKeySentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                 
                ],
              );
            },
          ),
        ],
      ),
    );

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.addServiceKeySentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              );
            },
          ),
        ],
       )
      );

    return targets;
  }

}