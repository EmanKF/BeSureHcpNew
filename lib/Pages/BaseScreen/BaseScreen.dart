import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Pages/ReconcilationReport/ReconcilationMainScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/City.dart';
import 'package:besure_hcp/Models/Gender.dart';
import 'package:besure_hcp/Models/ServiceProvider.dart';
import 'package:besure_hcp/Models/ServiceType.dart';
import 'package:besure_hcp/Pages/HomeScreen/HomeSceen.dart';
import 'package:besure_hcp/Pages/ProfileScreen/ProfileScreen.dart';
import 'package:besure_hcp/Pages/QrCodeScreen/QrCodeScreen.dart';
import 'package:besure_hcp/Pages/StatisticsScreen/StatisticsScreen.dart';
import 'package:besure_hcp/Services/GeneralServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key, this.billUploaded});
  final bool? billUploaded;
  static ServiceProvider? loggedInSP = new ServiceProvider();
  static num rating = 0;
  static num commission = 0;
  static List<City> allCities = [];
  static List<Gender> allGenders = [];
  static List<ServiceType> allServiceTypes = [];
  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  //  final channel = IOWebSocketChannel.connect(
  //       'ws://api.esnadtakaful.com/api/TestWebSocket/testwebsocket?Email=hudaabumayha.ham@gmail.com&Id='+BaseScreen.loggedInSP!.id!);
  late TutorialCoachMark tutorialCoachMark;

  // GlobalKey keyButton = GlobalKey();
  // GlobalKey keyButton1 = GlobalKey();
  // GlobalKey keyButton2 = GlobalKey();
  // GlobalKey keyButton3 = GlobalKey();
  // GlobalKey keyButton4 = GlobalKey();
  // GlobalKey keyButton5 = GlobalKey();

  GlobalKey keyBottomNavigation1 = GlobalKey();
  GlobalKey keyBottomNavigation2 = GlobalKey();
  GlobalKey keyBottomNavigation3 = GlobalKey();
  GlobalKey keyBottomNavigation4 = GlobalKey();


  int _selectedScreenIndex = 0;

  final List _screens = [
    {"screen": const HomeScreen(), "title": "Home Screen"},
    {"screen": const QrCodeScreen(), "title": "QrCode Screen"},
    {"screen": const StatisticsScreen(), "title": "Statistics Screen"},
    {"screen": const ProfileScreen(), "title": "Profile Screen"}
  ];

  //  Future<String?> getDeviceId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) { 
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else if(Platform.isAndroid) {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.id; // unique ID on Android
  //   }
  // }
  
  Future<void> _selectScreen(int index) async {
    //  String? deviceId = await getDeviceId();
    // channel.sink.add(BaseScreen.loggedInSP!.id!+"#"+deviceId!);
    setState(() {
      _selectedScreenIndex = index;
    });
  }
 
  @override
  void initState(){
    diplayTutorial();
    super.initState();
     if(widget.billUploaded == true){
        _selectedScreenIndex = 0;
      }
      else{
        _selectedScreenIndex = 0;
      }
    getAllCities();
    getAllGenders();
    getAllServiceTypes();
  }

  diplayTutorial()async{
    final prefs = await SharedPreferences.getInstance();
    bool isDisplayed = prefs.getBool('HomeDisplayedBefore') ?? false;
    if(isDisplayed == false){
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
      updateStatus();
    }
  }

  updateStatus() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('HomeDisplayedBefore',true);
  }

  show(String msg){
    showDialog(context: context, builder: (context) => MsgDialog(msg: msg));
  }

  @override
  Widget build(BuildContext context) {
    //  return StreamBuilder(
    //     stream: channel.stream,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.active) {
    //         log(ConnectionState.active.index.toString());
    //         channel.sink.add('Logout');
    //         //  show('${snapshot.data}');
    //          log('Received: ${snapshot.data}');
    //          return Text('Received: ${snapshot.data}');
    //       } else {
            return WillPopScope(
              onWillPop: () async{
                return false;
              },
              child: Scaffold(
                body: _screens[_selectedScreenIndex]["screen"],
                bottomNavigationBar: 
                Stack(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: Center(
                  child: SizedBox(
                    key: keyBottomNavigation1,
                    height: 40,
                    width: 40,
                  ),
                )),
                Expanded(
                    child: Center(
                  child: SizedBox(
                    key: keyBottomNavigation2,
                    height: 40,
                    width: 40,
                  ),
                )),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      key: keyBottomNavigation3,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                 Expanded(
                  child: Center(
                    child: SizedBox(
                      key: keyBottomNavigation4,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
                  currentIndex: _selectedScreenIndex,
                  onTap: _selectScreen,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: silverLakeBlue,
                  unselectedItemColor: Colors.grey.shade600,
                  selectedLabelStyle: SplashScreen.langId == 1 ? TextStyle(fontFamily: arabicHeadersFontFamily, fontSize: 13) : TextStyle(fontSize: 13),
                  unselectedLabelStyle: SplashScreen.langId == 1 ? TextStyle(fontFamily: arabicHeadersFontFamily, fontSize: 13) : TextStyle(fontSize: 13),
                  iconSize: 28,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined), label: AppLocalizations.of(context)!.home),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.qr_code_scanner_rounded), label: AppLocalizations.of(context)!.qr),
                    BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: AppLocalizations.of(context)!.statistics),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle_outlined), label: AppLocalizations.of(context)!.profile)
                  ],
                ),
              ],
      ),
    ));
    // return Scaffold(
    //   body: _screens[_selectedScreenIndex]["screen"],
    //   bottomNavigationBar: BottomNavigationBar(
    //     currentIndex: _selectedScreenIndex,
    //     onTap: _selectScreen,
    //     selectedItemColor: greenSheen,
    //     unselectedItemColor: Colors.grey.shade500,
    //     items: const [
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.grid_view_outlined), label: ''),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.qr_code_scanner_rounded), label: ''),
    //       BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: ''),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.account_circle_outlined), label: '')
    //     ],
    //   ),
    // );
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
        // print("finish");
      },
      onClickTarget: (target) {
        // print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        // print("target: $target");
        // print(
        //     "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        // print('onClickOverlay: $target');
      },
      onSkip: () {
        // print("skip");
        return true;
      },
    );
  }

List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation1",
        keyTarget: keyBottomNavigation1,
        alignSkip: Alignment.topRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.home, size: 30, color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.home,
                        style: TextStyle(
                          // color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 15),
                  Text(AppLocalizations.of(context)!.homeSentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation2",
        keyTarget: keyBottomNavigation2,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.qr_code_scanner_sharp, size: 30, color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.qr,
                        style: TextStyle(
                          // color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 15),
                  Text(AppLocalizations.of(context)!.qrScannerSentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation3",
        keyTarget: keyBottomNavigation3,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.graphic_eq, size: 30, color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.statistics,
                        style: TextStyle(
                          // color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 15),
                  Text(AppLocalizations.of(context)!.statisticsSentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "keyBottomNavigation4",
        keyTarget: keyBottomNavigation4,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.account_circle_outlined, size: 30, color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.profile,
                        style: TextStyle(
                          // color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 15),
                  Text(AppLocalizations.of(context)!.profileSentence,
                    style: TextStyle(
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
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