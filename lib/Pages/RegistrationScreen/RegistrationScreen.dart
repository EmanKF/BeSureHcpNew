import 'dart:convert';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Models/City.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:http/http.dart' as http;
import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Constants/constantFontFamily.dart';
import 'package:besure_hcp/Constants/constantUrls.dart';
import 'package:besure_hcp/Models/ServiceProvider.dart';
import 'package:besure_hcp/Pages/RegistrationScreen/CustomTextFeild.dart';
import 'package:besure_hcp/Pages/SplashScreen/SplashScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController name_en = TextEditingController();
  TextEditingController ownerName = TextEditingController();
  TextEditingController ownerName_en = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController address_en = TextEditingController();
  TextEditingController shortDescription = TextEditingController();
  TextEditingController shortDescription_en = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController description_en = TextEditingController();
  TextEditingController cityId = TextEditingController();
  int selectedCityId = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('BeSure HCP'),
          centerTitle: true,
          foregroundColor: silverLakeBlue,
          backgroundColor: Colors.white,
        ),
        body: Container(
          width: 100.w,
          height: 100.h,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextFeild(controller: name, hintText: 'الإسم', textInputType: TextInputType.name,),
                CustomTextFeild(controller: name_en, hintText: 'Name', textInputType: TextInputType.name,),
                CustomTextFeild(controller: ownerName, hintText: 'إسم المالك', textInputType: TextInputType.name,),
                CustomTextFeild(controller: ownerName_en, hintText: 'Owner Name', textInputType: TextInputType.name,),
                CustomTextFeild(controller: username, hintText: 'Username', textInputType: TextInputType.name,),
                CustomTextFeild(controller: email, hintText: 'Email', textInputType: TextInputType.name,),
                CustomTextFeild(controller: phoneNumber, hintText: 'Phone Number', textInputType: TextInputType.number,),
                CustomTextFeild(controller: password, hintText: 'Password', textInputType: TextInputType.name, obsecureText: true),
                CustomTextFeild(controller: address, hintText: 'Address', textInputType: TextInputType.name,),
                CustomTextFeild(controller: address_en, hintText: 'العنوان', textInputType: TextInputType.name,),
                CustomTextFeild(controller: shortDescription, hintText: 'وصف مختصر', textInputType: TextInputType.name,),
                CustomTextFeild(controller: shortDescription_en, hintText: 'Short Description', textInputType: TextInputType.name,),
                CustomTextFeild(controller: description, hintText: 'وصف مفصل', textInputType: TextInputType.name,),
                CustomTextFeild(controller: description_en, hintText: 'Description', textInputType: TextInputType.name,),
                          
                Container(
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                    width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 40.w : 90.w,
                    child: DropdownButtonFormField( 
                            items: BaseScreen.allCities.map((City value){
                              return new DropdownMenuItem<String>(
                                value: value.id.toString(),
                                child: Container(
                                  width: 160,
                                  child: Text(value.code!, style: TextStyle(fontSize: 12),)),
                              );
                            }).toList(),
                            validator: (val){
                              if(val == null)
                              return 'Select City';
                              else return null;
                            },
                            onChanged: (v) async{
                              // print(v.toString());  
                              setState(() {
                                selectedCityId = int.parse(v.toString());
                              });                      
                            },

                              hint: Text('City', style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade900
                                  )
                              ),
                              decoration: InputDecoration( 
                                prefixIcon: Icon(Icons.apartment_rounded, size:30),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 0.5
                                  )
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: silverLakeBlue)
                                ),
                                ),
                                borderRadius: BorderRadius.circular(10.0), 
                                  
                          ),                                                                                                                                                                                                                                                                                                
                  ),
      
                Container(
                  margin: EdgeInsets.all(5),
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 1.h : 0),
                    width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 40.w : 90.w,
                    decoration: BoxDecoration(
                        color: silverLakeBlue,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: isLoading == false ?
                    TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if(password.text.length < 8){
                              showDialog(context: context, builder: (context) => MsgDialog(msg: 'Password cannot be less than 8 characters'));
                            }
                            else{
                            setState(() {
                              isLoading = true;
                            });
                            ServiceProvider sp = ServiceProvider(name: name.text, name_en: name_en.text, ownerName: ownerName.text, ownerName_en: ownerName_en.text, username: username.text, email: email.text, password: password.text, phoneNumber: phoneNumber.text, address: address.text, address_en: address_en.text, shortDescription: shortDescription.text, shortDescription_en: shortDescription_en.text, description: description.text, description_en: description_en.text, cityId: selectedCityId);
                            var map = sp.spRegister(sp);
                           
                            var registerResponse = await http.post(
                              Uri.parse(swaggerApiUrl + "ServiceProvider/Register"),
                               headers: {
                                "Accept": "application/json",
                                "content-type":"application/json"
                               // "Authorization": "Bearer " + LoginScreen.token
                               },
                               body: json.encode(map)
                            );
                            setState(() {
                              isLoading = false;
                            });
                            // print(registerResponse.body);
                            
                            Map loginMapResonse = json.decode(registerResponse.body);
                            if(loginMapResonse["httpStatusCode"] == 200){
                              Navigator.pop(context);
                               showDialog(context: context, builder: (context) => MsgDialog(msg: 'لقد تمت إضافة الحساب بنجاح'));
                            }
                            else if(loginMapResonse["message"] == "df_email_exist"){
                               showDialog(context: context, builder: (context) => MsgDialog(msg: 'Email already exist'));
                            }
                            else if(loginMapResonse["message"] == "df_phone_exist"){
                               showDialog(context: context, builder: (context) => MsgDialog(msg: 'Phone already exist'));
                            }
                            else if(loginMapResonse["message"] == "df_username_exist"){
                               showDialog(context: context, builder: (context) => MsgDialog(msg: 'Username already exist'));
                            }
                            else{
                              showDialog(context: context, builder: (context) => MsgDialog(msg: 'لقد فشلت عملية إضافة حساب  '));
                            }
                          //      String token = loginMapResonse['data']['token'];
                          //      String refreshToken = loginMapResonse['data']['refreshToken'];
                          //      LoginScreen.token = token;
                          //      LoginScreen.refreshToken = refreshToken;
                          //      Map<String, dynamic> tokenMap = parseJwt(token);
                          //      LoginScreen.tokenMap = tokenMap;
                          //      LoginScreen.isAdmin = tokenMap["Is_Admin"].toString();
                          //      log(tokenMap.toString());
                          //      log('this is token map id');
                          //      final prefs = await SharedPreferences.getInstance();
                          //      await prefs.setString('token',token);
                          //      await prefs.setString('isAdmin', tokenMap["Is_Admin"].toString());
                          //      await prefs.setString('refreshToken', refreshToken);
                          //      await prefs.setString('SPId',tokenMap["Id"]);
                          //      await getServiceProviderBasicInfo(tokenMap["Id"]);
                          //      if(PlayerId != null ) {
                          //        BaseScreen.loggedInSP!.deviceId = PlayerId;
                          //        await prefs.setString('deviceId',PlayerId);
                          //      }
                               
      
                          //  //  final MySP = context.read(serviceProviderProvider);
                          //      print(BaseScreen.loggedInSP!.branchId!.toString());
                          //      await getAllApprovedServices(BaseScreen.loggedInSP!.branchId!);
                          //      bool res2 = await getAllCustomerReviews(0,100);
                          //      setState(() {
                          //       isLoading = false;
                          //     });
                          //      Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => BaseScreen()));
                          //   }
                          //   else{
                          //     setState(() {
                          //       isLoading = false;
                          //     });
                          //     if(loginMapResonse["message"] == 'df_invalid_credentials'){
                          //       showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.invalidAccount));
                          //     }
                          //     else if(loginMapResonse["message"] == 'df_invalid_email'){
                          //       showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.invalidAccount));
                          //     }
                          //     else if(loginMapResonse["message"] == 'df_invalid_password'){
                          //       showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.wrongPassword));
                          //     }
                          //     else if(loginMapResonse["message"] == 'df_account_deleted'){
                          //       showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.invalidAccount));
                          //     }
                          //     else if(loginMapResonse["message"] == 'df_invalid_phonenumber'){
                          //       showDialog(context: context, builder: (context) => MsgDialog(msg: AppLocalizations.of(context)!.invalidAccount));
                          //     }
                          //   }
                          }
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.register,
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
                  
              ],
            ),
          ),
        ),
      ),
    );
  }
}