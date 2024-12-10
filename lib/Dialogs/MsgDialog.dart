import 'package:besure_hcp/Constants/constantColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class MsgDialog extends StatelessWidget {
  const MsgDialog({super.key, this.msg});

  final String? msg;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      contentPadding: EdgeInsets.all(10.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         Container(
          margin: EdgeInsets.all(5.0),
           child: Text(msg!,
           textAlign: TextAlign.start,
            ),
         ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: Text(AppLocalizations.of(context)!.ok, style: TextStyle(
                    color: silverLakeBlue
                  ))
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}