import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Services/PasswordServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.isEmail, this.email_Phone, this.otp});

  final bool? isEmail;
  final String? email_Phone, otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController newPass = new TextEditingController();
  TextEditingController confirmPass = new TextEditingController();
  String confirmPassValidationText ='';
  String newPassValidationText ='';
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
        title: Text(AppLocalizations.of(context)!.resetPassword),
      ),
      body: Container(
          height: 100.h,
          width: 100.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                   obscureText:
                    showPassword == false ? true : false,
                  controller: newPass,
                  decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.newPassword,
                  border: OutlineInputBorder(
                    borderSide:BorderSide(
                      width: 1,
                      color: lightGrey
                    )
                  )
                ),
                ),
              ),

                if(newPassValidationText != '')
                  Container(
                    margin: EdgeInsets.only(top:5, bottom: 8),
                    width: MediaQuery.of(context).size.width * 0.78,
                      child: Text(newPassValidationText, textScaleFactor: 1.0,style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.justify,),
                      
                    ),  
              SizedBox(
                height: 1.h,
              ),
              Container(
                width: 85.w,
                child: TextFormField( 
                  controller: confirmPass,
                   obscureText:
                    showPassword == false ? true : false,
                  decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.confirmPassword,
                  border: OutlineInputBorder(
                    borderSide:BorderSide(
                      width: 1,
                      color: lightGrey
                    )
                  )
                ),
                ),
              ),

              if(confirmPassValidationText != '')
                  Container(
                    margin: EdgeInsets.only(top:5, bottom: 8),
                    width: MediaQuery.of(context).size.width * 0.78,
                      child: Text(confirmPassValidationText,textScaleFactor: 1.0, style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.justify,),
                      
                    ), 

              Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.showPassword,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Checkbox(
                                  value: showPassword,
                                  checkColor: Colors.white,
                                  activeColor: silverLakeBlue,
                                  onChanged: onChanged),
                              const SizedBox(
                                width: 22,
                              ),
                            ],
                          ),      

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              Spacer(),

              Container(
                margin: const EdgeInsets.fromLTRB(35, 0, 35, 25),
                        width: double.infinity,
                        height: 53,
                        decoration: BoxDecoration(
                          color: greenSheen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                child: 
                isLoading == false ? MaterialButton(
                  onPressed: () async{
                        if(newPass.text.isNotEmpty && confirmPass.text.isNotEmpty){
                          if(newPass.text == confirmPass.text){
                          setState(() {
                            isLoading = true;
                          });
                          FocusScope.of(context).unfocus();
                          Map map = new Map();
                          map["email_Phone"] = widget.email_Phone;
                          map["is_Email"] = widget.isEmail;
                          map["otp"] = widget.otp!;
                          map["newPassword"] = newPass.text;
                          bool res = await resetPassword(map);

                          setState(() {
                            isLoading = false;
                          });

                          if(res == true){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: 'Failed to reset password'));
                          }
                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: "Passwords doesn't match"));
                          }

                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: 'All feilds are required'));
                          }
                  },
                  child: Text(AppLocalizations.of(context)!.changePassword, textScaleFactor: 1.0, style: TextStyle(
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