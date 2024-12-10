import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:besure_hcp/Services/GeneralServices.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  String pp = '';

  @override
  void initState() {
    super.initState();
    getPP();
  }

  void getPP() async{
    String res = await getPrivacyPolicy();
    setState(() {
      pp = res;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      contentPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: 
        pp == "" ?
        [
          Container(
            padding: EdgeInsets.all(5.0),
            child: CircularProgressIndicator(
              color: silverLakeBlue,
            ),
          )
        ]
        :
        [
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 2.0),
            height: 50.h,
            width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 30.w : 80.w,
            child: SingleChildScrollView(
              child: Text( pp,
              textAlign: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? TextAlign.start : TextAlign.justify,
              )),
          ),
          Container(
            width: MediaQuery.of(context).size.width + 200 > MediaQuery.of(context).size.height ? 30.w : 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)
              ),
              color: silverLakeBlue
            ),
            child: TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text(AppLocalizations.of(context)!.ok, style: TextStyle(
                color: Colors.white
              ))
            ),
          )
        ],
      ),
    );
  }
}