import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Pages/ForgetPasswordScreen/ResetPasswordScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Services/PasswordServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, this.isEmail, this.email_Phone});

  final bool? isEmail;
  final String? email_Phone;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  TextEditingController otpController = new TextEditingController();
  String otpValidationText ='';
  bool isLoading = false;

  bool showPassword = false;
  void onChanged(bool? value) {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: grey,
        elevation: 0,
        title: Text('Verify Otp'),
      ),
      body: Container(
          height: 100.h,
          width: 100.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.h
              ),
              Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  // Text(AppLocalizations.of(context)!.changePassword,style: TextStyle(
                  //   fontSize: 20.sp,
                  //   fontWeight: FontWeight.bold,
                  //   color: grey
                  // )),
                ],
              ),

              SizedBox(
                height: 3.h,
              ),

               Container(
                width: 85.w,
                child: TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                  hintText: 'Otp code',
                  border: OutlineInputBorder(
                    borderSide:BorderSide(
                      width: 1,
                      color: lightGrey
                    )
                  )
                ),
                ),
              ),

                if(otpValidationText != '')
                  Container(
                    margin: EdgeInsets.only(top:5, bottom: 8),
                    width: MediaQuery.of(context).size.width * 0.78,
                      child: Text(otpValidationText, textScaleFactor: 1.0,style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.justify,),
                      
                    ),  
              SizedBox(
                height: 2.h,
              ),

            
              Container(
                        width: 85.w,
                        height: 53,
                        decoration: BoxDecoration(
                          color: greenSheen,
                          borderRadius: BorderRadius.circular(5),
                        ),
                child: 
                isLoading == false ? MaterialButton(
                  onPressed: () async{
                        if(otpController.text.isNotEmpty){
                          setState(() {
                            isLoading = true;
                          });
                          FocusScope.of(context).unfocus();
                          Map map = new Map();
                          map["email_Phone"] = widget.email_Phone;
                          map["is_Email"] = widget.isEmail;
                          map["otp"] = otpController.text;
                          bool res = await verify(map);

                          setState(() {
                            isLoading = false;
                          });

                          if(res == true){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(email_Phone: widget.email_Phone, isEmail: widget.isEmail, otp: otpController.text)));
                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: 'Wrong Otp Code'));
                          }

                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: 'Enter Otp Code'));
                          }
                  },
                  child: Text('Verify', textScaleFactor: 1.0, style: TextStyle(
                    color: Colors.white
                  )),
                  )
                  :
                   Container(
                          margin: EdgeInsets.symmetric(vertical: 0.8.h),
                          alignment: Alignment.center,
                          width: 10.w,
                          child: CircularProgressIndicator(
                            color: Colors.white
                          ),
                        )
              )
            ],
          ),
        ),
    );
  }
}