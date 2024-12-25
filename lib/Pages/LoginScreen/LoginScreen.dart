import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:besure_hcp/Functions/OneSignalWeb.dart';
import 'package:besure_hcp/Pages/RegistrationScreen/RegistrationScreen.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:besure_hcp/configure_ws.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Functions/parseTokenFunction.dart';
import 'package:besure_hcp/Services/CustomerReviewsServices.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/ForgetPasswordScreen/FindAccountScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/Components/CustomTextFeild.dart';
import 'package:besure_hcp/Services/ServiceProviderInfo.dart';
import 'package:besure_hcp/Services/ServicesServices.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static String token = '';
  static String refreshToken = '';
  static Map<String, dynamic> tokenMap = Map();
  static String isAdmin = '';
  static String SPSAID = '';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isLoading = false;
  var uuid = const Uuid();
  TabController? _tabController;
  List? tabs;
  int _currentIndex = 0;

  // Future<String?> getDeviceId() async {
  //   var deviceInfo;
  //   if(!kIsWeb){
  //   if (Platform.isIOS) { 
  //     deviceInfo = DeviceInfoPlugin();
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else if(Platform.isAndroid) {
  //       try {
  //       deviceInfo = await GetMac.macAddress;
  //       } on PlatformException {
  //         deviceInfo = 'Failed to get Device MAC Address.';
  //       }
  //       return deviceInfo;
  //     // var androidDeviceInfo = await deviceInfo.androidInfo;
  //     // return androidDeviceInfo.id; // unique ID on Android
  //   }
  //   }
  //   // else{
  //   //    try {
  //   //     deviceInfo = await GetMac.macAddress;
  //   //     } on PlatformException {
  //   //       deviceInfo = 'Failed to get Device MAC Address.';
  //   //     }
  //   //     return deviceInfo;
  //   //   // var androidDeviceInfo = await deviceInfo.androidInfo;
  //   //   // return androidDeviceInfo.id; // unique ID on Android
    // }

  // }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  tabs = [AppLocalizations.of(context)!.email, AppLocalizations.of(context)!.phoneNumber];
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController!.index;
    });
  }

   @override
  void dispose() {

    _tabController!.dispose();
    super.dispose();
  }

  _tabsContent() {
    if (_currentIndex == 0) {
      return CustomTextFeild(obsecureText: false, hintText: 'Email', textInputType: TextInputType.text, controller: emailController);
    } else if (_currentIndex == 1) {
      return CustomTextFeild(obsecureText: false, hintText: 'Phone', textInputType: TextInputType.number, controller: phoneController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: 100.w,
            height: 100.h,
            child: Column(
              children: [

               SizedBox(
                  height: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 5.h : 15.h,
                ),

                Container(
                  width: 50.w,
                  height: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 15.w : 50.w,
                  child: Image.asset('assets/images/BeSureHCP.png'),
                ),
               
                SizedBox(
                  height: 6.h,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 75.w,
                      child: TabBar(
                        indicatorColor: silverLakeBlue,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Colors.red,
                        dividerHeight: 0,
                        indicator: UnderlineTabIndicator(
                          insets: EdgeInsets.symmetric(horizontal:15, vertical: 5),
                          borderSide: BorderSide(
                            width: 4,
                            color: silverLakeBlue,
                          )
                        ),
                        indicatorPadding: EdgeInsets.zero,
                        labelColor: Colors.black,
                        labelStyle: TextStyle(
                          fontSize: 16
                        ),
                        unselectedLabelColor: Colors.black,
                        controller: _tabController,
                        tabs: [
                          Tab(
                            text: AppLocalizations.of(context)!.email,
                          ),
                          Tab(
                            text: AppLocalizations.of(context)!.phoneNumber,
                          )
                        ]
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 3.h,
                ),

                _tabsContent(),
              
                SizedBox(
                  height: 2.h,
                ),
                
                CustomTextFeild(obsecureText: true, hintText: 'Password', textInputType: TextInputType.text, controller: passwordController),
                
                SizedBox(
                  height: 3.h,
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 1.h : 0),
                  width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 40.w : 90.w,
                  decoration: BoxDecoration(
                      color: silverLakeBlue,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: isLoading == false ?
                  TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          var onesignalId = '2219b7bc-722b-e852-e229-0e2ead6f9cdf';
                          if(!kIsWeb){
                            onesignalId = await OneSignal.User.getOnesignalId() ?? 'N/A';
                          }
                          else if(kIsWeb){
                            onesignalId = await getOneSignalPlayerId();
                            log(onesignalId);
                          }



                          var map = new Map();
                          // log(onesignalId +' on loginn');
                          map["email_Phone"] = _currentIndex == 0 ? emailController.text.trim() : phoneController.text.trim();
                          map["password"] = passwordController.text.trim();
                          map["is_Email"] = _currentIndex == 0 ? true : false;
                          map["external_id"] = onesignalId ;
                          // log(map.toString());
                          var loginResponse = await http.post(
                            Uri.parse(swaggerApiUrl + "ServiceProvider/Login"),
                             headers: {
                              "Accept": "application/json",
                              "content-type":"application/json"
                             // "Authorization": "Bearer " + LoginScreen.token
                             },
                             body: json.encode(map)
                          );
                          // print(loginResponse.body);
                          
                          Map loginMapResonse = json.decode(loginResponse.body);
                          if(loginMapResonse["httpStatusCode"] == 200){
                             String token = loginMapResonse['data']['token'];
                             String refreshToken = loginMapResonse['data']['refreshToken'];
                             LoginScreen.token = token;
                             LoginScreen.refreshToken = refreshToken;
                             Map<String, dynamic> tokenMap = parseJwt(token);
                             LoginScreen.tokenMap = tokenMap;
                             LoginScreen.isAdmin = tokenMap["Is_Admin"].toString();
                            //  log(tokenMap.toString());
                            //  log('this is token map id');
                             final prefs = await SharedPreferences.getInstance();
                             await prefs.setString('token',token);
                             await prefs.setString('isAdmin', tokenMap["Is_Admin"].toString());
                             await prefs.setString('refreshToken', refreshToken);
                             await prefs.setString('SPId',tokenMap["Id"]);
                            //  print('before getting info');
                            //  print(tokenMap["Id"]);
                             await getServiceProviderBasicInfo(tokenMap["Id"]);
                             if(!kIsWeb){
                               OneSignal.login(onesignalId ?? '');
                             }
                             else if(kIsWeb){
                              //  loginWeb(onesignalId ?? '');
                             }
                            //  print('after getting info');
                               await prefs.setString('deviceId',onesignalId);
                               
                             
                            //  void _handleGetOnesignalId() async {
                            //   var onesignalId = await OneSignal.shared.ge
                            //   print('OneSignal ID: $onesignalId');
                            // }
                             final message = {
                              "Action":"LoginRequest",
                             "SP":LoginScreen.SPSAID,
                             "Client":"",
                             "Message":"string",
                             "DeviceId":onesignalId,
                             "Data":["Test Test","Test Test 22"]};
                              ref.read(websocketProvider).sendMessage(json.encode(message));

                         //  final MySP = context.read(serviceProviderProvider);
                            //  print(BaseScreen.loggedInSP!.branchId!.toString());
                             await getAllApprovedServices(BaseScreen.loggedInSP!.branchId!);
                             bool res2 = await getAllCustomerReviews(0,100);
                             setState(() {
                              isLoading = false;
                            });
                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BaseScreen()));
                          }
                          else{
                            setState(() {
                              isLoading = false;
                            });
                            if(loginMapResonse["message"] == 'df_invalid_credentials'){
                              showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.invalidAccount));
                            }
                            else if(loginMapResonse["message"] == 'df_invalid_email'){
                              showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.invalidAccount));
                            }
                            else if(loginMapResonse["message"] == 'df_invalid_password'){
                              showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.wrongPassword));
                            }
                            else if(loginMapResonse["message"] == 'df_account_deleted'){
                              showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.invalidAccount));
                            }
                            else if(loginMapResonse["message"] == 'df_invalid_phonenumber'){
                              showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.invalidAccount));
                            }
                          }
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.login,
                          style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.w00,
                              fontFamily: SplashScreen.langId == 1 ? arabicHeadersFontFamily : null,
                              fontSize: 18)))
                              :
                              Container(
                                // margin: EdgeInsets.symmetric(vertical: 0.8.h),
                                alignment: Alignment.center,
                                width: 10.w,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                ),
                SizedBox(
                  height: 2.h,
                ),
                RichText(
                  text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.registerSentence,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      )
                    ),
                    TextSpan(
                      text: '  '
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.registerNow,
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                      },
                      style: TextStyle(
                        color: silverLakeBlue,
                        fontSize: 16
                      )
                    )
                  ]
                )
                ),
                SizedBox(
                  height: 1.h,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FindAccountScreen()));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.forgetPassword,
                      style: TextStyle(color: Colors.red),
                    )),
                // Spacer(),
                // Container(
                //   margin: EdgeInsets.all(3.h),
                //   child: Text(
                //     'By Esnad Takaful',
                //     style: TextStyle(
                //         fontFamily: beSureFontFamily,
                //         fontSize: 18,
                //         color: grey),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
