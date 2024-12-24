import 'dart:developer';
import 'dart:ui';

import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Models/Branch.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/AddBranchScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/Components/BranchWidget.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Services/BranchesServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});
  static List<Branch> approvedBranches = [];
  static List<Branch> allBranches = [];
  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> with Observer{
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyApprovedBranches = GlobalKey();
  GlobalKey keyAllBranches = GlobalKey();
  GlobalKey keyAddBranch = GlobalKey();
  bool isLoadingBranches = false;
  bool allBranchesButton = false;
  bool approvedBranchesButton = true;

  @override
  void initState() {
    diplayTutorial();
    Observable.instance.addObserver(this);
    super.initState();
    if(BranchesScreen.approvedBranches.isEmpty){
      print('empty branches approveddd');
      getApprovedBranches();
     }
    // if(BranchesScreen.allBranches.isEmpty){
      getBranches();
    // }
  }

  @override
  update(Observable observable, String? notifyName, Map? map){
    log('Branches Observableee');
    getBranches();
    getApprovedBranches();
    setState(() {
      
    });
  }

  diplayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('BranchesDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('BranchesDisplayedBefore',true);
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  void getApprovedBranches() async{
    // setState(() {
    //   isLoadingApprovedBranches = true;
    // });
    bool res = await getAllApprovedBranches();
    // setState(() {
    //   isLoadingApprovedBranches = false;
    // });
  }

  void getBranches() async{
     setState(() {
      isLoadingBranches = true;
    });
    bool res = await getAllBranches(BaseScreen.loggedInSP!.serviceProvideId!);
     setState(() {
      isLoadingBranches = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.branches, style: TextStyle(fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null),),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: 
        // isLoadingBranches == true ?
        // Container(
        //   alignment: Alignment.center,
        //   width: 20.w,
        //   height: 20.w,
        //   child: CircularProgressIndicator(
        //     color: silverLakeBlue,
        //   ),
        // )
        // :
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  key: keyApprovedBranches,
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.h : 0),
                  width: 50.w,
                  color: approvedBranchesButton == true ? silverLakeBlue : lightGrey,
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        allBranchesButton = false;
                        approvedBranchesButton = true;
                      });
                    }, 
                    child: Text(AppLocalizations.of(context)!.approvedBranches, 
                    style: TextStyle(color: approvedBranchesButton == true ? Colors.white : silverLakeBlue, fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null),)
                  ),
                ),
                Container(
                  key: keyAllBranches,
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 2.h : 0),
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: allBranchesButton  == true ? silverLakeBlue : lightGrey
                  ),
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        approvedBranchesButton = false;
                        allBranchesButton = true;
                      });
                    }, 
                    child: Text(AppLocalizations.of(context)!.allBranches,
                    style: TextStyle(color: allBranchesButton  == true ? Colors.white : silverLakeBlue, fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null),)
                  ),
                ),
              ],
            ),
            approvedBranchesButton == true?
            Container(
               margin: EdgeInsets.only(top: 1.h),
               height: 72.h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for(Branch branch in BranchesScreen.approvedBranches)
                    BranchWidget(branch: branch)
                  ],
                ),
              ),
            )
            :
            Container(
              margin: EdgeInsets.only(top: 1.h),
              height: 72.h,
              child: SingleChildScrollView(
              child: Column(
                children: [
                  for(Branch branch in BranchesScreen.allBranches)
                  BranchWidget(branch: branch)
                ],
              ),
            )
            )
          ],
        ),
      ),
      floatingActionButton: 
       LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True"?
      Container(
        key: keyAddBranch,
        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 18.w : 40.w,
        decoration: BoxDecoration(
            color: silverLakeBlue,
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddBranchScreen()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.addBranch, style: TextStyle(
                fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 12.sp : 16.sp,
                color: Colors.white
              ),),
              Icon(Icons.add, color: Colors.white)
            ],
          ),
        ),
      )
      :
      null
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
        identify: "keyApprovedBranches",
        keyTarget: keyApprovedBranches,
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
                  Text(AppLocalizations.of(context)!.approvedBranchesKeySentence,
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
        identify: "keyAllBranches",
        keyTarget: keyAllBranches,
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
                  Text(AppLocalizations.of(context)!.allBranchesKeySentence,
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
        identify: "keyAddBranch",
        keyTarget: keyAddBranch,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.addBranchKeySentence,
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