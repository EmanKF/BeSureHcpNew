import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Dialogs/MsgDialog.dart';
import 'package:besure_hcp/Pages/BaseScreen/BaseScreen.dart';
import 'package:besure_hcp/Pages/LoginScreen/LoginScreen.dart';
import 'package:besure_hcp/Services/PasswordServices.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  TextEditingController oldPass = new TextEditingController();
  TextEditingController newPass = new TextEditingController();
  TextEditingController confirmPass = new TextEditingController();
  String confirmPassvalidationText ='';
  String newPassVelidationText ='';
  String oldPasswordVelidationText ='';
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
        title: Text(AppLocalizations.of(context)!.changePassword),
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
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                child: TextField(
                  controller: oldPass,
                  obscureText:
                    showPassword == false ? true : false,
                  decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.oldPassword,
                  border: OutlineInputBorder(
                    borderSide:BorderSide(
                      width: 1,
                      color: lightGrey
                    )
                  )
                ),
                ),
              ),

              if(oldPasswordVelidationText!= '')
                  Container(
                    margin: EdgeInsets.only(top:5, bottom: 8),
                    width:MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 78.w,
                      child: Text(oldPasswordVelidationText, textScaleFactor: 1.0,style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.justify,),
                      
                    ),  
 
               SizedBox(
                height: 1.h,
              ),

              Container(
                width:  MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
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

                if(newPassVelidationText != '')
                  Container(
                    margin: EdgeInsets.only(top:5, bottom: 8),
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 78.w,
                      child: Text(newPassVelidationText, textScaleFactor: 1.0,style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.justify,),
                      
                    ),  
              SizedBox(
                height: 1.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
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

              if(confirmPassvalidationText != '')
                  Container(
                    margin: EdgeInsets.only(top:5, bottom: 8),
                    width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 78.w,
                      child: Text(confirmPassvalidationText,textScaleFactor: 1.0, style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.justify,),
                      
                    ), 

              Container(
                width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : 85.w,
                child: Row(
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
                                // const SizedBox(
                                //   width: 22,
                                // ),
                              ],
                            ),
              ),      

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              Spacer(),

              Container(
                margin: const EdgeInsets.fromLTRB(35, 0, 35, 25),
                        width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 40.w : double.infinity,
                        height: 53,
                        decoration: BoxDecoration(
                          color: silverLakeBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                child: MaterialButton(
                  onPressed: () async{
                        if(oldPass.text.isNotEmpty && newPass.text.isNotEmpty && confirmPass.text.isNotEmpty){
                          if(newPass.text == confirmPass.text){
                          setState(() {
                            isLoading = true;
                          });
                          FocusScope.of(context).unfocus();
                          Map map = new Map();
                          map["currentPassword"] = oldPass.text;
                          map["newPassword"] = newPass.text;
                          map["userId"] = BaseScreen.loggedInSP!.id!;
                          String res = await changePassword(map);

                          setState(() {
                            isLoading = false;
                          });

                          if(res == "true" || res == "True"){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            showDialog(context: context, builder: (context) => MsgDialog(msg: 'Password changed successfully, Login to your account with the new password'));
                          }
                          else if(res == "df_error_old_password"){
                            showDialog(context: context, builder: (context) => MsgDialog(msg: 'Old password is wrong'));
                          }
                          else{
                            showDialog(context: context, builder: (context) => MsgDialog(msg: 'Failed to change password'));
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
                  ),
              )
            ],
          ),
        ),
    );
  }
}