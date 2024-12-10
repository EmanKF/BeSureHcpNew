import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/ProfileScreen/Components/ProfileItemWidget.dart';
import 'package:besure_hcp/Pages/SettingsScreen/SubScreens/changeLang.dart';
import 'package:besure_hcp/Pages/SettingsScreen/SubScreens/changePass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: grey,
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: Column(
          children:[
            SizedBox(
                height: 2.h,
              ),

            ProfileItemWidget(
                icon: Icons.language_rounded,
                text: AppLocalizations.of(context)!.changeLanguage,
                function: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeLang()));
                },
              ),
              SizedBox(
                height: 1.h,
              ),
              ProfileItemWidget(
                icon: Icons.key_rounded,
                text: AppLocalizations.of(context)!.changePassword,
                function: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePass()));
                },
              ),
              
          ]
        ),
      ),
    );
  }
}