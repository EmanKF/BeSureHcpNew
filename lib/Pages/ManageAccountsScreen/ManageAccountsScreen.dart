import 'dart:developer';
import 'dart:ui';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Models/SPUSer.dart';
import 'package:besure_hcp/Models/ServiceProvider.dart';
import 'package:besure_hcp/Pages/ManageAccountsScreen/AddServiceProviderUserScreen.dart';
import 'package:besure_hcp/Pages/ManageAccountsScreen/Components/SPUserWidget.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Services/ServiceProviderUserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ManageAccountsScreen extends StatefulWidget {
  const ManageAccountsScreen({super.key});
  static List<ServiceProvider> sPUsers = [];
  @override
  State<ManageAccountsScreen> createState() => _ManageAccountsScreenState();
}

class _ManageAccountsScreenState extends State<ManageAccountsScreen> with Observer{
  bool isLoading = false;
  late TutorialCoachMark tutorialCoachMark;
  GlobalKey keyAddUser = GlobalKey();

   @override
  void initState() {
    diplayTutorial();
    Observable.instance.addObserver(this);
    super.initState();
    loadApis();
  }

  void loadApis() async{
    if(ManageAccountsScreen.sPUsers.isEmpty){
      setState(() {
        isLoading = true;
      });
        getSPUsers();
    }
  }

  diplayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('ManageAccountsDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ManageAccountsDisplayedBefore',true);
  }

  @override
  update(Observable observable, String? notifyName, Map? map){
    log('Branches Observableee');
    getSPUsers();
    setState(() {
      
    });
  }

  void getSPUsers() async{
    bool res = await getAllSPUsers();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        foregroundColor: silverLakeBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.manageUsers, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: Column(
          children: [
            Container(
               margin: EdgeInsets.only(top: 1.h),
              child: 
              isLoading == true?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: CircularProgressIndicator(
                      color: silverLakeBlue,
                    ),
                  )
                ],
              )
              :
              Container(
                height: 85.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for(ServiceProvider user in ManageAccountsScreen.sPUsers)
                      SPUserWidget(spUser: user)
                    ],
                  ),
                ),
              ),
            )
            
          ],
        ),
      ),
      floatingActionButton: Container(
        key: keyAddUser,
        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 15.w : 40.w,
        decoration: BoxDecoration(
            color: silverLakeBlue,
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddServiceProviderUserScreen()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.addUser, style: TextStyle(
                fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 12.sp : 17.sp,
                color: Colors.white
              ),),
              Icon(Icons.add, color: Colors.white)
            ],
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
                  Text(AppLocalizations.of(context)!.addUserKeySentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
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