import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Pages/ForgetPasswordScreen/ResetPasswordScreen.dart';
import 'package:besure_hcp/Pages/ForgetPasswordScreen/VerifyScreen.dart';
import 'package:besure_hcp/Services/PasswordServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class FindAccountScreen extends StatefulWidget {
  const FindAccountScreen({super.key});

  @override
  State<FindAccountScreen> createState() => _FindAccountScreenState();
}

class _FindAccountScreenState extends State<FindAccountScreen> {
  bool isEmail = false;
  bool isLoading = false;
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: grey,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 40.w : 85.w,
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.findAccount, style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 10.sp : 18.sp
                  )),
                ],
              ),
            ),

             SizedBox(
                  height: 2.h,
             ),
      
            Container(
              width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 40.w : 85.w,
              child: Row(
                children: [
                  Text(isEmail == false ? AppLocalizations.of(context)!.enterYourPhoneNumber : AppLocalizations.of(context)!.enterYourEmailAddress),
                ],
              ),
            ),
          
            SizedBox(
                  height: 3.h,
            ),

            isEmail == false ?
            Container(
              width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 40.w : 85.w,
              child: TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.phoneNumber,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  )
                ),
              ),
            )
            :
            Container(
              width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 40.w : 85.w,
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  )
                ),
              ),
            ),

            SizedBox(
                  height: 2.h,
            ),
      
             Container(
                    width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 40.w : 85.w,
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 1.h : 0),
                    decoration: BoxDecoration(
                        color: greenSheen,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: isLoading == false ? 
                    TextButton(
                        onPressed: () async{
                          if(emailController.text.isNotEmpty || mobileController.text.isNotEmpty){
                          setState(() {
                            isLoading = true;
                          });
                          FocusScope.of(context).unfocus();
                          Map map = new Map();
                          map["email_Phone"] = isEmail == true ? emailController.text : mobileController.text;
                          map["is_Email"] = isEmail;
                          bool res = await sendCode(map);

                          setState(() {
                            isLoading = false;
                          });

                          if(res == true){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyScreen(isEmail: isEmail, email_Phone: isEmail == true ? emailController.text : mobileController.text)));
                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: 'No Account with this phone Nb found'));
                          }

                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: 'Please enter your email or password to verify your account and reset password'));
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.findAccount,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18)))
                        :
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 0.8.h),
                          alignment: Alignment.center,
                          width: 10.w,
                          child: CircularProgressIndicator(
                            color: Colors.white
                          ),
                        )
                  ),
                  
                  SizedBox(
                    height: 2.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          FocusScope.of(context).unfocus();
                          mobileController.clear();
                          emailController.clear();
                          if(isEmail == false){
                          setState(() {
                            isEmail = true;
                          });
                          }
                          else{
                            setState(() {
                              isEmail = false;
                            });
                          }
                        },
                        child: Text(isEmail == false ? AppLocalizations.of(context)!.searchByEmailAddress : AppLocalizations.of(context)!.searchByPhoneNumber))
                    ],
                  )
            
          ],
        ),
      ),
    );
  }
}