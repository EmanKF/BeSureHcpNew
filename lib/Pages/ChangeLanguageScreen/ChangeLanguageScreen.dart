import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Language.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/QrCodeScreen/QrCodeScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Services/GeneralServices.dart';
import 'package:besure_hcp/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 50.w : 80.w,
              child: Text(
                'Select Language',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 8.sp : 15.sp),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            for (Language lang in languages)
              Container(
                padding: EdgeInsets.all( MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 0.5.w : 1.w),
                width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 50.w : 80.w,
                margin: EdgeInsets.all(MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 0.5.w : 1.w),
                decoration: BoxDecoration(color: lightGrey),
                child: TextButton(
                  onPressed: () async {
                    MyApp.setLocale(context, Locale(lang!.languageCode!));
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setInt('langId', lang.id!);
                    SplashScreen.langId = lang.id!;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(lang!.name!, style: TextStyle(fontSize: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 6.sp : 12.sp)),
                      SizedBox(
                        width:  1.w,
                      ),
                      lang.flag!.contains('.')
                      ?
                      Container(
                        width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 3.w : 5.w,
                        child: Image.network(swaggerFlagsUrl + lang.flag!),
                      )
                      :
                      Text(
                        lang.flag!,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ),
            // SizedBox(
            //   height: 1.h,
            // ),
            // Container(
            //   width: 80.w,
            //   color: ConstantColors.blueColor,
            //   child: TextButton(
            //       onPressed: () {
            //         Navigator.pushReplacement(context,
            //             MaterialPageRoute(builder: (context) => LoginScreen()));
            //       },
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             'Next',
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 20),
            //           ),
            //           Icon(
            //             Icons.navigate_next_outlined,
            //             color: Colors.white,
            //           )
            //         ],
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}
