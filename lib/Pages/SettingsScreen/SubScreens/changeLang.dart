import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/Language.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Services/BranchesServices.dart';
import 'package:besure_hcp/Services/GeneralServices.dart';
import 'package:besure_hcp/Services/ServicesServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:besure_hcp/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ChangeLang extends StatelessWidget {
  const ChangeLang({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.selectLanguage),
      ),
      body: Container(
        color: Colors.white,
        // height: 100.h,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   width: 80.w,
            //   child: Text(
            //     AppLocalizations.of(context)!.selectLanguage,
            //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),
            //   ),
            // ),
            SizedBox(
              height: 10.h,
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
                    print(lang.languageCode!);
                    getAllApprovedBranches();
                    getAllBranches(BaseScreen.loggedInSP!.id!);
                    getAllServices();
                    getAllApprovedServices(BaseScreen.loggedInSP!.branchId!);
                    getAllGenders();
                    getAllServiceTypes();
                    Navigator.pop(context);
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
             
          ],
        ),
      ),
    );
  }
}