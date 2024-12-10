import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Dialogs/ProfileDialog.dart';
import 'package:besure_hcp/Pages/AppointmentsScreen/AppointmentsScreen.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/BranchesScreen/BranchesScreen.dart';
import 'package:besure_hcp/Pages/EditProfileScreen/EditProfileScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Pages/ManageAccountsScreen/ManageAccountsScreen.dart';
import 'package:besure_hcp/Pages/ProfileScreen/Components/DeleteAccountDialog.dart';
import 'package:besure_hcp/Pages/ProfileScreen/Components/ProfileItemWidget.dart';
import 'package:besure_hcp/Pages/ReconcilationReport/PreReconcilationScreen.dart';
import 'package:besure_hcp/Pages/ReconcilationReport/ReconcilationMainScreen.dart';
import 'package:besure_hcp/Pages/ServicesProvidedScreen/ServicesProvidedScreen.dart';
import 'package:besure_hcp/Pages/SettingsScreen/SettingsScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/Pages/TransactionsScreen/TransactionsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Observer{

  @override
  void initState() {
    Observable.instance.addObserver(this);
    super.initState();
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    setState(() {
      
    });
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> share() async {
    print('hhh');
    await FlutterShare.share(
        title: 'BeSure HCP',
        text: 'BeSure HCP',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.myapp.besure_hcp',
        chooserTitle: 'BeSure HCP');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: 100.w,
          height: 100.h,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 100.w,
                          height: 22.h,
                          child: Image.asset("assets/images/bk.png", fit: BoxFit.cover,),
                          // color: silverLakeBlue,
                        ),
                        Container(
                          width: 100.w,
                          height: 5.h,
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 10.w : 30.w,
                      height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 10.w : 30.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0.5.w : 2.w),
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
                            return Icon(Icons.error);
                          },)
                        )
                      ),
                    )
                  ],
                  alignment: Alignment.bottomCenter,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 0 : 2.h,
                ),
                Text(
                  BaseScreen.loggedInSP!.ownerName!,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 7.sp : 12.sp,
                      color: silverLakeBlue,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      AppLocalizations.of(context)!.businessDetails,
                      style: TextStyle(
                          color: silverLakeBlue,
                          fontWeight: FontWeight.w500,
                          fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 14.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                ProfileItemWidget(
                  icon: Icons.person_outline,
                  text: AppLocalizations.of(context)!.editProfile,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen()));
                  },
                ),
                ProfileItemWidget(
                  icon: Icons.location_on_rounded,
                  text: AppLocalizations.of(context)!.branches,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BranchesScreen()));
                  },
                ),
                ProfileItemWidget(
                  icon: Icons.supervised_user_circle_outlined,
                  text: AppLocalizations.of(context)!.servicesProvided,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServicesProvidedScreen()));
                  },
                ),
                if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
                ProfileItemWidget(
                  icon: Icons.manage_accounts_outlined,
                  text: AppLocalizations.of(context)!.manageAccounts,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageAccountsScreen()));
                  },
                ),

                ProfileItemWidget(
                  icon: Icons.book_outlined,
                  text: AppLocalizations.of(context)!.appointments,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppointmentsScreen()));
                  },
                ),
               
                if(LoginScreen.isAdmin == "true" || LoginScreen.isAdmin == "True")
                ProfileItemWidget(
                  icon: Icons.receipt_long_outlined,
                  text: 'Reconcilation Report',
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreReconcilationScreen()));
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      AppLocalizations.of(context)!.appSettings,
                      style: TextStyle(
                          color: silverLakeBlue,
                          fontWeight: FontWeight.w500,
                          fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                          fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 6.sp : 14.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                ProfileItemWidget(
                  icon: Icons.settings,
                  text: AppLocalizations.of(context)!.settings,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                ),
                ProfileItemWidget(
                  icon: Icons.share,
                  text: AppLocalizations.of(context)!.shareApp,
                  function: share,
                ),
                // ProfileItemWidget(
                //   icon: Icons.help_rounded,
                //   text: AppLocalizations.of(context)!.about,
                //   function: () {
                //     showDialog(
                //         context: context, builder: (context) => ProfileDialog());
                //   },
                // ),
                ProfileItemWidget(
                  icon: Icons.help_outline_outlined,
                  text: AppLocalizations.of(context)!.privacyPolicy,
                  function: () {
                    showDialog(
                        context: context, builder: (context) => ProfileDialog());
                  },
                ),
                // ProfileItemWidget(
                //   icon: Icons.person,
                //   text: 'Delete Account',
                //   function: () {
                //     showDialog(
                //         context: context, builder: (context) => DeleteAccountDialog());
                //   },
                // ),
                ProfileItemWidget(
                  icon: Icons.logout,
                  text: AppLocalizations.of(context)!.logout,
                  function: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('token', '');
                    await prefs.setString('SPId', '');
                    BranchesScreen.allBranches.clear();
                    BranchesScreen.approvedBranches.clear();
                    ServicesProvidedScreen.allApprovedServices.clear();
                    ServicesProvidedScreen.allServices.clear();
                    OneSignal.logout();
                    LoginScreen.SPSAID = '';
                    BaseScreen.loggedInSP = null;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }
  
}
