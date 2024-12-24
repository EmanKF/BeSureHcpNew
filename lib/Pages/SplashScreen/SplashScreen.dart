import 'dart:async';
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/ChangeLanguageScreen/ChangeLanguageScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Services/CustomerReviewsServices.dart';
import 'package:besure_hcp/Services/GeneralServices.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:besure_hcp/Services/ServiceProviderInfo.dart';
import 'package:besure_hcp/Services/ServicesServices.dart';
import 'package:besure_hcp/main.dart';
import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner_web.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();
  // final WebSocketChannel? channel;
  static int? langId;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // static const String oneSignalAppId = "e17aafef-af94-4ed5-b729-c74c74ff5547";

  // Future<void> initPlatformState() async {
  //   OneSignal.initialize(oneSignalAppId);
  //   OneSignal.Notifications.requestPermission(true);
  // }
  
  @override
  void initState() {
    super.initState();
    // // print('bbbbbbbbbbb');
    // if(!kIsWeb){
    //   initPlatformState();
    // }
    // print('donee initt before navigate from splash');
    Timer(Duration(seconds: 2), () => navigateFromSplash());
  }

  Future<void> navigateFromSplash() async {
    final prefs = await SharedPreferences.getInstance();
    if(kIsWeb){
      MyApp.setLocale(context, Locale('ar'));
      SplashScreen.langId = 1;
      String id = prefs.getString('SPId') ?? '';
      // print(id);
      if (id == '') {   
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
      else{
         BaseScreen.loggedInSP!.deviceId = prefs.getString('deviceId');
        LoginScreen.token = prefs.getString('token') ?? '';
        print(LoginScreen.token);
        LoginScreen.refreshToken = prefs.getString('refreshToken') ?? '';
        LoginScreen.isAdmin = prefs.getString('isAdmin') ?? '';
        await refreshToken();
        await getServiceProviderBasicInfo(id);
        await getAllApprovedServices(BaseScreen.loggedInSP!.branchId!);
        bool res2 = await getAllCustomerReviews(0,100);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BaseScreen()));
      }
        
    }
    else{
      // print('lll');
      int? langId = prefs.getInt('langId');
      if(langId == 1){
        // print('arrr');
        MyApp.setLocale(context, Locale('ar'));
        SplashScreen.langId = 1;
      }
      else{
        // print('enn');
        MyApp.setLocale(context, Locale('en'));
        SplashScreen.langId = 2;
      }
      await getAllLanguages();
      // prefs.setString('SPId', '');
      String id = prefs.getString('SPId') ?? '';
      // print(id);
      if (id == '') {
        // print('kkk');
        if(langId == null){
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChangeLanguage()));
        }
        else{
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      } else {
        // print('nnn');
        BaseScreen.loggedInSP!.deviceId = prefs.getString('deviceId');
        LoginScreen.token = prefs.getString('token') ?? '';
        LoginScreen.refreshToken = prefs.getString('refreshToken') ?? '';
        LoginScreen.isAdmin = prefs.getString('isAdmin') ?? '';
        await refreshToken();
        await getServiceProviderBasicInfo(id);
        await getAllApprovedServices(BaseScreen.loggedInSP!.branchId!);
        bool res2 = await getAllCustomerReviews(0,100);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BaseScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 50.w,
                height: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 25.w : 50.w,
                child: Image.asset('assets/images/BeSureHCP.png'),
              ),
            ),
          ],
        ),
      ),
      //  body: StreamBuilder(
      //   stream: widget.channel?.stream,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.active) {
      //       // Handle incoming data here
      //       return Center(
      //         child: Text('Received: ${snapshot.data}'),
      //       );
      //     } else {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
